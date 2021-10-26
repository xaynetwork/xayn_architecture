import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/test.dart';
import 'package:xayn_architecture/concepts/use_case.dart';

import 'helpers/use_cases.dart';

void main() {
  group('consume: ', () {
    blocTest('emits after consuming initial event: ',
        build: () => TestCubit.consume(
              initialState: -1.0,
              initialData: 0,
              useCase: IntToDoubleUseCase(),
              onSuccess: (double it, state) => it,
              onFailure: (e, s, state) => -2.0,
            ),
        expect: () => const [.0]);
  });

  group('pipe: ', () {
    blocTest('emits after calling the handler: ',
        build: () => TestCubit.pipe(
              initialState: -1.0,
              useCase: IntToDoubleUseCase(),
              onSuccess: (double it, state) => it,
              onFailure: (e, s, state) => -2.0,
            ),
        act: (TestCubit<double, int, double, double> cubit) {
          cubit.onHandler(1);
          cubit.onHandler(2);
          cubit.onHandler(3);
        },
        expect: () => const [3.0]);
  });
}

class TestCubit<T, In, Out, OutNext> extends Cubit<T>
    with UseCaseBlocHelper<T> {
  late final OnHandler<In> _handler;

  TestCubit.consume({
    required T initialState,
    required UseCase<In, Out> useCase,
    required UseCaseResultToStateHandler<T, OutNext> onSuccess,
    required UseCaseResultErrorHandler<T> onFailure,
    required In initialData,
    Transformer<Out, OutNext>? transformer,
    Guard<T>? guard,
  }) : super(initialState) {
    final t = transformer ?? (Stream<Out> out) => out as Stream<OutNext>;

    consume(useCase, initialData: initialData)
        .transform(t)
        .fold(onSuccess: onSuccess, onFailure: onFailure, guard: guard);
  }

  TestCubit.pipe({
    required T initialState,
    required UseCase<In, Out> useCase,
    required UseCaseResultToStateHandler<T, OutNext> onSuccess,
    required UseCaseResultErrorHandler<T> onFailure,
    Transformer<Out, OutNext>? transformer,
    Guard<T>? guard,
  }) : super(initialState) {
    final t = transformer ?? (Stream<Out> out) => out as Stream<OutNext>;

    _handler = pipe(useCase)
        .transform(t)
        .fold(onSuccess: onSuccess, onFailure: onFailure, guard: guard);
  }

  void onHandler(In param) => _handler(param);
}
