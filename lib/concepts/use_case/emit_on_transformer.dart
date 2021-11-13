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
  final Test<In> _test;
  final Runner<In> _whenTrue;
  final bool _swallowEvent;

  EmitOnTransformer({
    required Test<In> test,
    required Runner<In> whenTrue,
    bool swallowEvent = true,
  })  : _test = test,
        _whenTrue = whenTrue,
        _swallowEvent = swallowEvent;

  @override
  Stream<In> bind(Stream<In> stream) => forwardStream(
      stream,
      () => _EmitOnSink<In>(
            test: _test,
            whenTrue: _whenTrue,
            swallowEvent: _swallowEvent,
          ));
}

class _EmitOnSink<In> extends ForwardingSink<In, In> {
  final Test<In> _test;
  final Runner<In> _whenTrue;
  final bool _swallowEvent;

  _EmitOnSink({
    required Test<In> test,
    required Runner<In> whenTrue,
    bool swallowEvent = true,
  })  : _test = test,
        _whenTrue = whenTrue,
        _swallowEvent = swallowEvent;

  @override
  FutureOr<void> onCancel() {}

  @override
  void onData(In data) {
    if (_test(data)) {
      try {
        _whenTrue(data);

        sink.addError(const EmitOnInterceptor());
      } catch (e, s) {
        sink.addError(e, s);
      }

      if (_swallowEvent) return;
    }

    sink.add(data);
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
