import 'dart:async';

// ignore: implementation_imports
import 'package:rxdart/src/utils/forwarding_sink.dart';
// ignore: implementation_imports
import 'package:rxdart/src/utils/forwarding_stream.dart';

typedef Test<In> = bool Function(In data);
typedef StateBuilder<In, State> = State Function(In);

/// A `Stream` transformer that binds the events of a parent `Stream`, as
/// the next input of a `useCase`.
class EmitOnTransformer<In, State> extends StreamTransformerBase<In, In> {
  final Test<In> _test;
  final StateBuilder<In, State> _stateBuilder;
  final bool _swallowEvent;

  EmitOnTransformer({
    required Test<In> test,
    required StateBuilder<In, State> stateBuilder,
    bool swallowEvent = true,
  })  : _test = test,
        _stateBuilder = stateBuilder,
        _swallowEvent = swallowEvent;

  @override
  Stream<In> bind(Stream<In> stream) => forwardStream(
      stream,
      () => _EmitOnSink(
            test: _test,
            stateBuilder: _stateBuilder,
            swallowEvent: _swallowEvent,
          ));
}

class _EmitOnSink<In, State> extends ForwardingSink<In, In> {
  final Test<In> _test;
  final StateBuilder<In, State> _stateBuilder;
  final bool _swallowEvent;

  _EmitOnSink({
    required Test<In> test,
    required StateBuilder<In, State> stateBuilder,
    bool swallowEvent = true,
  })  : _test = test,
        _stateBuilder = stateBuilder,
        _swallowEvent = swallowEvent;

  @override
  FutureOr<void> onCancel() {}

  @override
  void onData(In data) {
    if (_test(data)) {
      sink.addError(EmitOnInterceptor(_stateBuilder(data)));

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

class EmitOnInterceptor<State> {
  final State state;

  const EmitOnInterceptor(this.state);
}
