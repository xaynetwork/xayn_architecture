part of use_case_bloc_helper;

typedef Transformer<In, Out> = Stream<Out> Function(Stream<In> out);
typedef UseCaseResultToStateHandler<State, Out> = State? Function(Out it);
typedef UseCaseResultErrorHandler<State> = HandleFailure<State?>;
typedef _OnState<State> = void Function(State?);
typedef Guard<State> = bool Function(State nextState);

/// An interface which exposes methods to start consuming values from a `useCase`
/// which is being consumed as a `Stream`.
///
/// [fold] maps the latest output into a `state` for a `cubit`.
///
/// [transform] exposes the actual `Stream` and allows you to transform it,
/// before it is passed into [fold].
///
/// [transform] is also the entry point for chaining multiple `useCase`s together
/// using [UseCaseExtension.followedBy].
///
/// [guard] optionally allows for a `guard` handler, allowing you to compare
/// the `current` state versus the `next` state.
/// return `true` to allow emitting the `next` state, or false to discard it.
abstract class UseCaseResolver<In, Out, State> {
  UseCaseSubscription fold({
    required UseCaseResultToStateHandler<State, Out> onSuccess,
    required UseCaseResultErrorHandler<State> onFailure,
    Guard<State>? guard,
  });

  UseCaseResolver<In, OutNext, State> transform<OutNext>(
      Transformer<Out, OutNext> transform);
}

/// Identical to [UseCaseResolver], but adds methods to work with the wrapped `sink`
/// as well.
///
/// [close] will `close` the `sink`, after which no more incoming events will
/// be accepted, instead any additional events will trigger a [StateError].
abstract class UseCaseSinkResolver<In, Out, State>
    extends UseCaseResolver<In, Out, State> {
  void close();
}

class _Resolver<In, Out, State> implements UseCaseResolver<In, Out, State> {
  final Stream<Out> _stream;
  final _OnState<State?> _onState;
  final List<StreamSubscription<State?>> _subscriptions;

  _Resolver(
    this._stream,
    this._onState,
    this._subscriptions,
  );

  @override
  UseCaseSubscription fold({
    required UseCaseResultToStateHandler<State, Out> onSuccess,
    required UseCaseResultErrorHandler<State> onFailure,
    Guard<State>? guard,
  }) {
    final subscription = _stream
        .map((it) => onSuccess(it))
        .onErrorReturnWith((e, s) => onFailure(e, s))
        .where((it) => it != null && guard != null ? guard(it) : true)
        .listen(_onState);

    _subscriptions.add(subscription);

    return _Subscriber<State>(subscription);
  }

  @override
  UseCaseResolver<In, OutNext, State> transform<OutNext>(
      Transformer<Out, OutNext> transform) {
    return _Resolver<In, OutNext, State>(
      transform(_stream),
      _onState,
      _subscriptions,
    );
  }
}

class _SinkResolver<In, Out, State> extends _Resolver<In, Out, State>
    implements UseCaseSinkResolver<In, Out, State> {
  final Sink<In> _sink;

  _SinkResolver(
    Stream<Out> stream,
    _OnState<State> onState,
    List<StreamSubscription<State?>> subscriptions,
    this._sink,
  ) : super(
          stream,
          onState,
          subscriptions,
        );

  @override
  void close() => _sink.close();

  @override
  UseCaseSubject<In> fold({
    required UseCaseResultToStateHandler<State, Out> onSuccess,
    required UseCaseResultErrorHandler<State> onFailure,
    Guard<State>? guard,
  }) {
    final subscription = _stream
        .map((it) => onSuccess(it))
        .onErrorReturnWith((e, s) => onFailure(e, s))
        .where((it) => it != null && guard != null ? guard(it) : true)
        .listen(_onState);

    _subscriptions.add(subscription);

    return _Emitter<In, State>(_sink, subscription);
  }

  @override
  _SinkResolver<In, OutNext, State> transform<OutNext>(
      Transformer<Out, OutNext> transform) {
    return _SinkResolver<In, OutNext, State>(
      transform(_stream),
      _onState,
      _subscriptions,
      _sink,
    );
  }
}
