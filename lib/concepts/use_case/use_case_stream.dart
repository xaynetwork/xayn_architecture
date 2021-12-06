import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xayn_architecture/concepts/use_case/handlers/on_failure.dart';
import 'package:xayn_architecture/concepts/use_case/transformers/emit_on_transformer.dart';

/// Signature for transforming an input `Stream` to an output `Stream`.
typedef Transformer<In, Out> = Stream<Out> Function(Stream<In> out);

/// Signature for handling an output event of a `Stream` created from a `UseCase`.
typedef HandleValue<Right> = void Function(Right value);

/// An `Object` which can hold either a value or an error.
abstract class Either<Value> {
  /// Resolves the current value or error and then calls the associated handler,
  /// - [onValue] when the value is set
  /// - [defaultOnError] or, if a specific error `Type` can be matched, the handler
  ///   from [matchOnError] when an error is set.
  void fold({
    required HandleOnFailure defaultOnError,
    required HandleValue<Value> onValue,
    Set<On>? matchOnError,
  });
}

/// Represents a `Stream` that was created from a `UseCase` via the `consume` handler.
class UseCaseValueStream<Out> implements Either<Out> {
  final Stream<Out> _stream;
  final VoidCallback _onData;
  final CompositeSubscription _subscriptions;
  StreamSubscription<Out>? _subscription;
  Out? _value;
  Object? _error;
  StackTrace? _stackTrace;

  /// Creates a new `UseCase` value `Stream`.
  UseCaseValueStream(
    this._stream,
    this._onData,
    this._subscriptions,
  );

  void _subscribeSelf() {
    _subscription ??= _stream.listen((it) {
      _value = it;
      _error = null;
      _stackTrace = null;

      _onData();
    }, onError: (Object e, StackTrace s) {
      if (e != const EmitOnInterceptor()) {
        _value = null;
        _error = e;
        _stackTrace = s;

        _onData();
      }
    })
      ..addTo(_subscriptions);
  }

  @override
  void fold({
    required HandleOnFailure defaultOnError,
    required HandleValue<Out> onValue,
    Set<On>? matchOnError,
  }) {
    final error = _error;

    _subscribeSelf();

    if (error != null) {
      HandleFailure(defaultOnError, matchers: matchOnError)
          .call(error, _stackTrace);
    } else if (_value != null) {
      onValue(_value!);
    }
  }

  /// If the output from the consumed `UseCase` requires further transformations,
  /// then use this handler.
  UseCaseValueStream<OutNext> transform<OutNext>(
          Transformer<Out, OutNext> transform) =>
      UseCaseValueStream(
        transform(_stream),
        _onData,
        _subscriptions,
      );
}

/// Represents a `Sink` and `Stream` that was created from a `UseCase` via the `pipe` handler.
class UseCaseSink<In, Out> extends UseCaseValueStream<Out> {
  final Sink<In> _sink;

  /// Creates a new `UseCase` value `Sink`.
  UseCaseSink(
    this._sink,
    Stream<Out> stream,
    VoidCallback onData,
    CompositeSubscription subscriptions,
  ) : super(
          stream,
          onData,
          subscriptions,
        );

  /// Adds a new [param] to the `Sink`.
  /// This `param` will be scheduled to invoke the wrapped `UseCase` with.
  @nonVirtual
  void call(In param) => _sink.add(param);

  @override
  UseCaseSink<In, OutNext> transform<OutNext>(
          Transformer<Out, OutNext> transform) =>
      UseCaseSink(
        _sink,
        transform(_stream),
        _onData,
        _subscriptions,
      );
}
