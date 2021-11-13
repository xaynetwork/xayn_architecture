import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/test.dart';
import 'package:xayn_architecture/concepts/on_failure.dart';
import 'package:xayn_architecture/concepts/use_case.dart';

import 'helpers/use_cases.dart';

/// note that by default, use cases are consumed/piped in a switchMap fashion
void main() {
  group('consume: ', () {
    blocTest('standard throughput: ',
        build: () => TestCubit.consume(
              initialState: -1.0,
              initialData: 0,
              useCase: IntToDoubleUseCase(),
              onSuccess: (double it) => it,
              onFailure: HandleFailure((e, s) => -2.0),
            ),
        expect: () => const [.0]);

    blocTest('standard throughput using inner async generator: ',
        build: () => TestCubit.consume(
              initialState: -1.0,
              initialData: 0,
              useCase: IntToDoubleGeneratorUseCase(),
              onSuccess: (double it) => it,
              onFailure: HandleFailure((e, s) => -2.0),
            ),
        expect: () => const [.0]);

    blocTest('transformed throughput: ',
        build: () => TestCubit.consume(
            initialState: '-1.0',
            initialData: 0,
            useCase: IntToDoubleUseCase(),
            onSuccess: (String it) => it,
            onFailure: HandleFailure((e, s) => '-2.0'),
            transformer: (Stream<double> out) =>
                out.map((it) => it.toString())),
        expect: () => const ['0.0']);

    blocTest('guarded throughput: ',
        build: () => TestCubit.consume(
            initialState: -1.0,
            initialData: 0,
            useCase: IntToDoubleUseCase(),
            onSuccess: (double it) => it,
            onFailure: HandleFailure((e, s) => -2.0),
            guard: (double nextState) => nextState > .0),
        expect: () => const []);

    blocTest('catch specific error Type: ',
        build: () => TestCubit.consume(
              initialState: '-1',
              initialData: 2,
              useCase: MultiOutputWithFailureUseCase(),
              onSuccess: (String it) => it,
              onFailure: HandleFailure(
                (e, s) => 'Exception',
                matchers: {
                  On<ArgumentError>((e, s) => 'ArgumentError'),
                  On<StateError>((e, s) => 'StateError'),
                  On<TypeError>((e, s) => 'TypeError'),
                },
              ),
            ),
        expect: () => const ['StateError']);
  });

  group('pipe: ', () {
    blocTest('standard throughput: ',
        build: () => TestCubit.pipe(
              initialState: -1.0,
              useCase: IntToDoubleUseCase(),
              onSuccess: (double it) => it,
              onFailure: HandleFailure((e, s) => -2.0),
            ),
        act: (TestCubit<double, int, double, double> cubit) {
          cubit.onHandler(1);
          cubit.onHandler(2);
          cubit.onHandler(3);
        },
        expect: () => const [3.0]);

    blocTest('standard throughput using inner async generator: ',
        build: () => TestCubit.pipe(
              initialState: -1.0,
              useCase: IntToDoubleGeneratorUseCase(),
              onSuccess: (double it) => it,
              onFailure: HandleFailure((e, s) => -2.0),
            ),
        act: (TestCubit<double, int, double, double> cubit) {
          cubit.onHandler(1);
          cubit.onHandler(2);
          cubit.onHandler(3);
        },
        expect: () => const [3.0]);

    blocTest('transformed throughput: ',
        build: () => TestCubit<String, int, double, String>.pipe(
            initialState: '-1.0',
            useCase: IntToDoubleUseCase(),
            onSuccess: (String it) => it,
            onFailure: HandleFailure((e, s) => '-2.0'),
            transformer: (Stream<double> out) =>
                out.map((it) => it.toString())),
        act: (TestCubit<String, int, double, String> cubit) {
          cubit.onHandler(1);
          cubit.onHandler(2);
          cubit.onHandler(3);
        },
        expect: () => const ['3.0']);

    blocTest('guarded throughput: ',
        build: () => TestCubit.pipe(
            initialState: -1.0,
            useCase: IntToDoubleUseCase(),
            onSuccess: (double it) => it,
            onFailure: HandleFailure((e, s) => -2.0),
            guard: (double nextState) => nextState > .0),
        act: (TestCubit<double, int, double, double> cubit) {
          cubit.onHandler(1);
          cubit.onHandler(2);
          cubit.onHandler(3);
        },
        expect: () => const [3.0]);

    blocTest('catch specific error Type: ',
        build: () => TestCubit.pipe(
              initialState: '-1',
              useCase: MultiOutputWithFailureUseCase(),
              onSuccess: (String it) => it,
              onFailure: HandleFailure(
                (e, s) => 'Exception',
                matchers: {
                  On<ArgumentError>((e, s) => 'ArgumentError'),
                  On<StateError>((e, s) => 'StateError'),
                  On<TypeError>((e, s) => 'TypeError'),
                },
              ),
            ),
        act: (TestCubit<String, int, String, String> cubit) {
          //cubit.onHandler(1); // ArgumentError
          cubit.onHandler(2); // StateError
          //cubit.onHandler(3); // TypeError
          //cubit.onHandler(4); // Exception
        },
        expect: () => const [
              /*'ArgumentError',*/
              'StateError',
              /*'TypeError',*/
              /*'Exception',*/
            ]);
  });
}

class TestCubit<T, In, Out, OutNext> extends Cubit<T>
    with UseCaseBlocHelper<T> {
  final HandleValue<OutNext> _handleValue;

  late final UseCaseValueStream _handler;

  TestCubit.consume({
    required T initialState,
    required UseCase<In, Out> useCase,
    required HandleValue<OutNext> onSuccess,
    required UseCaseResultErrorHandler<T> onFailure,
    required In initialData,
    Transformer<Out, OutNext>? transformer,
  }) : _handleValue = onSuccess, super(initialState) {
    final t = transformer ?? (Stream<Out> out) => out as Stream<OutNext>;

    consume(useCase, initialData: initialData)
        .transform(t);
  }

  TestCubit.pipe({
    required T initialState,
    required UseCase<In, Out> useCase,
    required HandleValue<OutNext> onSuccess,
    required UseCaseResultErrorHandler<T> onFailure,
    Transformer<Out, OutNext>? transformer,
  }) : _handleValue = onSuccess, super(initialState) {
    final t = transformer ?? (Stream<Out> out) => out as Stream<OutNext>;

    _handler = pipe(useCase)
        .transform(t);
  }

  void onHandler(In param) => (_handler as UseCaseSink<In, OutNext>)(param);

  @override
  T computeState() {
    _handler.fold(defaultOnError: defaultOnError, onValue: (it) => _handleValue(it),);
  }
}
