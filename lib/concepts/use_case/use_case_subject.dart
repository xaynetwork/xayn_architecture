part of use_case_bloc_helper;

/// An interface for the subscription that is returned when calling [UseCaseResolver.fold].
///
/// Use it to [cancel], [pause] or [resume] the active `StreamSubscription`.
abstract class UseCaseSubscription {
  void pause([Future<void>? resumeSignal]);

  void resume();

  Future<void> cancel();
}

/// An interface which exposes the current `StreamSubscription` as well as
/// a call handler to pass fresh data into the `useCase`.
abstract class UseCaseSubject<In> extends UseCaseSubscription {
  void call(In data);
}

class _Subscriber<State> implements UseCaseSubscription {
  final StreamSubscription<State> _subscription;

  _Subscriber(this._subscription);

  @override
  void pause([Future<void>? resumeSignal]) => _subscription.pause(resumeSignal);

  @override
  void resume() => _subscription.resume();

  @override
  Future<void> cancel() => _subscription.cancel();
}

/// A wrapper class, which presents the method [Sink.add] as a tear off.
class _Emitter<In, State> extends _Subscriber<State>
    implements UseCaseSubject<In> {
  final Sink<In> _sink;

  _Emitter(this._sink, StreamSubscription<State> subscription)
      : super(subscription);

  @override
  void call(In data) => _sink.add(data);
}
