import 'dart:async';

// ignore: implementation_imports
import 'package:rxdart/src/utils/forwarding_sink.dart';
// ignore: implementation_imports
import 'package:rxdart/src/utils/forwarding_stream.dart';

typedef Test<In> = bool Function(In data);
typedef Runner<In> = void Function(In);

/// A `Stream` transformer that binds the events of a parent `Stream`, as
/// the next input of a `useCase`.
class EmitOnTransformer<In> extends StreamTransformerBase<In, In> {
  final Test<In> _consumeEvent;
  final Runner<In> _run;

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

class EmitOnInterceptor {
  const EmitOnInterceptor();
}
