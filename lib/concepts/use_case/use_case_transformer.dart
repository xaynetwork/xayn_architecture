import 'dart:async';

// ignore: implementation_imports
import 'package:rxdart/src/utils/forwarding_sink.dart';
// ignore: implementation_imports
import 'package:rxdart/src/utils/forwarding_stream.dart';

typedef _Transaction<In, Out> = Stream<Out> Function(In);

/// A `Stream` transformer that binds the events of a parent `Stream`, as
/// the next input of a `useCase`.
class UseCaseStreamTransformer<In, Out> extends StreamTransformerBase<In, Out> {
  final _Transaction<In, Out> _transaction;

  UseCaseStreamTransformer(this._transaction);

  @override
  Stream<Out> bind(Stream<In> stream) =>
      forwardStream(stream, () => _UseCaseSink(_transaction));
}

class _UseCaseSink<In, Out> extends ForwardingSink<In, Out> {
  final _Transaction<In, Out> _transaction;
  StreamSubscription<Out>? subscription;
  bool _isDone = false;

  bool get _isSubscribed => subscription != null;

  _UseCaseSink(this._transaction);

  @override
  FutureOr<void> onCancel() {
    subscription?.cancel();
    subscription = null;
  }

  @override
  void onData(In data) {
    final stream = _transaction(data);

    subscription?.cancel();

    subscription = stream.listen(
      sink.add,
      onError: sink.addError,
      onDone: () {
        subscription?.cancel();
        subscription = null;

        if (_isDone) {
          _maybeClose();
        }
      },
    );
  }

  @override
  void onDone() {
    _isDone = true;

    _maybeClose();
  }

  @override
  void onError(Object error, StackTrace st) => sink.addError(error, st);

  @override
  FutureOr<void> onListen() {}

  @override
  void onPause() => subscription?.pause();

  @override
  void onResume() => subscription?.resume();

  void _maybeClose() {
    if (_isDone && !_isSubscribed) {
      sink.close();
    }
  }
}
