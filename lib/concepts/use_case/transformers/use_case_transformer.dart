import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
// ignore: implementation_imports
import 'package:rxdart/src/utils/forwarding_sink.dart';
// ignore: implementation_imports
import 'package:rxdart/src/utils/forwarding_stream.dart';

typedef _Transaction<In, Out> = Stream<Out> Function(In);

/// A `Stream` transformer that binds the events of a parent `Stream`, as
/// the next input of a `useCase`.
@protected
class UseCaseStreamTransformer<In, Out> extends StreamTransformerBase<In, Out> {
  final _Transaction<In, Out> _transaction;
  final bool _expandAll;

  /// Creates a new UseCaseStreamTransformer.
  UseCaseStreamTransformer(this._transaction, this._expandAll);

  @override
  Stream<Out> bind(Stream<In> stream) =>
      forwardStream(stream, () => _UseCaseSink(_transaction, _expandAll));
}

class _UseCaseSink<In, Out> extends ForwardingSink<In, Out> {
  final _Transaction<In, Out> _transaction;
  final bool _expandAll;
  final Queue<StreamSubscription<Out>> _pendingSubscriptions =
      Queue<StreamSubscription<Out>>();
  StreamSubscription<Out>? subscription;
  bool _isDone = false;

  bool get _isSubscribed => subscription != null;

  _UseCaseSink(this._transaction, this._expandAll);

  @override
  FutureOr<void> onCancel() {
    subscription?.cancel();
    subscription = null;
  }

  @override
  void onData(In data) {
    final stream = _transaction(data);

    createSubscription() => stream.listen(
          sink.add,
          onError: sink.addError,
          onDone: () {
            subscription?.cancel();
            subscription = null;

            if (_expandAll && _pendingSubscriptions.isNotEmpty) {
              subscription = _pendingSubscriptions.removeFirst()..resume();

              return;
            }

            if (_isDone) {
              _maybeClose();
            }
          },
        );

    if (_expandAll) {
      _pendingSubscriptions.add(createSubscription()..pause());

      subscription ??= _pendingSubscriptions.removeFirst()..resume();
    } else {
      subscription?.cancel();

      subscription = createSubscription();
    }
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
