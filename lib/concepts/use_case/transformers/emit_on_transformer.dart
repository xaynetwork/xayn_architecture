import 'dart:async';

import 'package:flutter/foundation.dart';
// ignore: implementation_imports
import 'package:rxdart/src/utils/forwarding_sink.dart';
// ignore: implementation_imports
import 'package:rxdart/src/utils/forwarding_stream.dart';

/// Signature for the predicate which tests if an event should be consumed or not.
typedef Test<In> = bool Function(In data);

/// Signature for the handler which runs just before `computeState` does.
typedef Runner<In> = void Function(In);

/// A `Stream` transformer that binds the events of a parent `Stream`, as
/// the next input of a `useCase`.
class EmitOnTransformer<In> extends StreamTransformerBase<In, In> {
  final Test<In> _consumeEvent;
  final Runner<In> _run;

  /// Creates a new EmitOnTransformer.
  /// - [consumeEvent] determines if the event should be 'swallowed' or not.
  ///   if it returns `true`, then the event will not be propagated to any further
  ///   listeners.
  ///   Even when swallowed, `computeState` will still run.
  /// - [run] allows to act on the latest output, just before `computeState` runs.
  EmitOnTransformer({
    required Test<In> consumeEvent,
    required Runner<In> run,
  })  : _consumeEvent = consumeEvent,
        _run = run;

  @override
  Stream<In> bind(Stream<In> stream) => forwardStream(
      stream,
      () => _EmitOnSink<In>(
            consumeEvent: _consumeEvent,
            run: _run,
          ));
}

class _EmitOnSink<In> extends ForwardingSink<In, In> {
  final Test<In> _consumeEvent;
  final Runner<In> _run;

  _EmitOnSink({
    required Test<In> consumeEvent,
    required Runner<In> run,
  })  : _consumeEvent = consumeEvent,
        _run = run;

  @override
  FutureOr<void> onCancel() {}

  @override
  void onData(In data) {
    bool consumeEvent = false;

    try {
      consumeEvent = _consumeEvent(data);

      _run(data);

      sink.addError(const EmitOnInterceptor());
    } catch (e, s) {
      sink.addError(e, s);
    }

    if (!consumeEvent) sink.add(data);
  }

  @override
  void onDone() {}

  @override
  void onError(Object error, StackTrace st) => sink.addError(error, st);

  @override
  FutureOr<void> onListen() {}

  @override
  void onPause() {}

  @override
  void onResume() {}
}

/// Internal class which indicates an event should call `computeState`,
/// while at the same time optionally swallow the event that was last emitted.
@protected
class EmitOnInterceptor {
  /// Creates a new interceptor for an event.
  const EmitOnInterceptor();
}
