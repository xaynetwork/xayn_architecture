library use_case_bloc_helper;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture/concepts/use_case/use_case_stream.dart';
import 'package:xayn_architecture/concepts/use_case/use_case_base.dart';

/// A method signature, defines a Function with exactly one parameter.
/// Used in or `cubit`s to define handlers that are exposed to widgets.
typedef Handler<Next> = void Function(Next data);

/// A mixin which exposes [UseCase] helper methods for binding changes to the [BlocBase.state]
mixin UseCaseBlocHelper<State> on BlocBase<State> {
  final List<StreamController> _subjects = <StreamController>[];
  final CompositeSubscription _subscriptions = CompositeSubscription();
  var _didInitHandlers = false;

  @override
  Stream<State> get stream {
    if (!_didInitHandlers) {
      _didInitHandlers = true;

      computeState();
    }

    return super.stream;
  }

  FutureOr<State?> computeState() {}

  @override
  Future<void> close() {
    _subscriptions.dispose();

    for (var subject in _subjects) {
      subject.close();
    }

    _subscriptions.clear();
    _subjects.clear();

    return super.close();
  }

  /// Consumes the [useCase] as a `Stream` and wraps the `Sink.add` handler,
  /// which can then be resolved to a `Cubit`'s state.
  ///
  /// Should you wish to prematurely close it, then use [UseCaseSubscription.cancel],
  /// or use [UseCaseSinkResolver.close] to terminate the `sink`.
  ///
  /// When using [UseCaseSinkResolver.close], then be aware that any future
  /// incoming events will throw a [StateError] on that same `sink`.
  UseCaseSink<In, Out> pipe<In, Out>(
    UseCase<In, Out> useCase,
  ) {
    final controller = StreamController<In>();

    _subjects.add(controller);

    return UseCaseSink(
      controller.sink,
      controller.stream.followedBy(useCase),
      () async {
        final nextState = await computeState();

        if (nextState != null) emit(nextState);
      },
      _subscriptions,
    );
  }

  /// Consumes the [useCase] as an open `Stream`.
  /// The connection stays open, until `close` is called on the `Cubit`.
  ///
  /// Should you wish to prematurely close it, then use [UseCaseSubscription.cancel].
  UseCaseValueStream<Out> consume<In, Out>(
    UseCase<In, Out> useCase, {
    required In initialData,
  }) =>
      UseCaseValueStream(
        Stream<In>.value(initialData).followedBy(useCase),
        () async {
          final nextState = await computeState();

          if (nextState != null) emit(nextState);
        },
        _subscriptions,
      );
}
