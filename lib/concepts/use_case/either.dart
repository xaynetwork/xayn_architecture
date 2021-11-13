import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xayn_architecture/concepts/on_failure.dart';
import 'package:xayn_architecture/concepts/use_case/emit_on_transformer.dart';

typedef Transformer<In, Out> = Stream<Out> Function(Stream<In> out);
typedef HandleValue<Right> = void Function(Right value);

abstract class Either<Value> {
  void fold({
    required OnFailureDefault defaultOnError,
    required HandleValue<Value> onValue,
    Set<On>? matchOnError,
  });
}

class UseCaseValueStream<Out> implements Either<Out> {
  final Stream<Out> _stream;
  final VoidCallback _onData;
  final CompositeSubscription _subscriptions;
  StreamSubscription<Out>? _subscription;
  Out? _value;
  Object? _error;
  StackTrace? _stackTrace;

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
      }

      _onData();
    })
      ..addTo(_subscriptions);
  }

  @override
  void fold({
    required OnFailureDefault defaultOnError,
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

  UseCaseValueStream<OutNext> transform<OutNext>(
          Transformer<Out, OutNext> transform) =>
      UseCaseValueStream(
        transform(_stream),
        _onData,
        _subscriptions,
      );
}

class UseCaseSink<In, Out> extends UseCaseValueStream<Out> {
  final Sink<In> _sink;

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
