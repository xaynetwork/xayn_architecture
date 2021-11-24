import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/transformers.dart';
// ignore: implementation_imports
import 'package:rxdart/src/utils/forwarding_sink.dart';
// ignore: implementation_imports
import 'package:rxdart/src/utils/forwarding_stream.dart';

typedef _OnNotification<Out> = Out Function();

/// An extension on [ChangeNotifier] which allows to consume notifications
/// as a Stream.
///
/// [onNotification] is a handler to resolve the event value from the
/// `ChangeNotifier`.
///
/// Upon listen, `onNotification` will be invoked immediately and the `Stream`
/// will emit the current value as a first event.
///
/// When listening to the `Stream` is cancelled, then the `Stream` will close.
extension ChangeNotifierExtension on ChangeNotifier {
  /// Used followedBy to chain multiple use cases.
  /// The output of the current use case will be the input for [useCase].
  Stream<Out> asStream<Out>(_OnNotification<Out> onNotification) =>
      const Stream.empty()
          .transform(ChangeNotifierStreamTransformer(this, onNotification))
          .transform(StartWithStreamTransformer(onNotification()));
}

/// A `StreamTransformer` which allows consuming notifications from a `ChangeNotifier`
/// as a `Stream`.
@protected
class ChangeNotifierStreamTransformer<In, Out>
    extends StreamTransformerBase<In, Out> {
  final ChangeNotifier _changeNotifier;
  final _OnNotification<Out> _onNotification;

  /// Creates a new ChangeNotifierStreamTransformer.
  const ChangeNotifierStreamTransformer(
    this._changeNotifier,
    this._onNotification,
  );

  @override
  Stream<Out> bind(Stream<In> stream) => forwardStream(
      stream, () => _ChangeNotifierSink(_changeNotifier, _onNotification));
}

class _ChangeNotifierSink<In, Out> extends ForwardingSink<In, Out> {
  final ChangeNotifier _changeNotifier;
  final _OnNotification<Out> _onNotification;

  _ChangeNotifierSink(
    this._changeNotifier,
    this._onNotification,
  );

  @override
  FutureOr<void> onCancel() {
    _changeNotifier.removeListener(_handleNotification);

    sink.close();
  }

  @override
  void onData(In data) {}

  @override
  void onDone() {}

  @override
  void onError(Object error, StackTrace st) => sink.addError(error, st);

  @override
  FutureOr<void> onListen() {
    _changeNotifier.addListener(_handleNotification);
  }

  @override
  void onPause() {}

  @override
  void onResume() {}

  void _handleNotification() {
    try {
      sink.add(_onNotification());
    } catch (e, s) {
      sink.addError(e, s);
    }
  }
}
