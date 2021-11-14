import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/test.dart';
import 'package:xayn_architecture/xayn_architecture.dart';

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
              onFailure: (e, s) => -2.0,
            ),
        expect: () => const [.0]);

    blocTest('standard throughput using inner async generator: ',
        build: () => TestCubit.consume(
              initialState: -1.0,
              initialData: 0,
              useCase: IntToDoubleGeneratorUseCase(),
              onSuccess: (double it) => it,
              onFailure: (e, s) => -2.0,
            ),
        expect: () => const [.0]);

    blocTest('transformed throughput: ',
        build: () => TestCubit.consume(
            initialState: '-1.0',
            initialData: 0,
            useCase: IntToDoubleUseCase(),
            onSuccess: (String it) => it,
            onFailure: (e, s) => '-2.0',
            transformer: (Stream<double> out) =>
                out.map((it) => it.toString())),
        expect: () => const ['0.0']);
  });

  group('pipe: ', () {
    blocTest('standard throughput: ',
        build: () => TestCubit.pipe(
              initialState: -1.0,
              useCase: IntToDoubleUseCase(),
              onSuccess: (double it) => it,
              onFailure: (e, s) => -2.0,
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
              onFailure: (e, s) => -2.0,
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
            onFailure: (e, s) => '-2.0',
            transformer: (Stream<double> out) =>
                out.map((it) => it.toString())),
        act: (TestCubit<String, int, double, String> cubit) {
          cubit.onHandler(1);
          cubit.onHandler(2);
          cubit.onHandler(3);
        },
        expect: () => const ['3.0']);
  });
}

class TestCubit<T, In, Out, OutNext> extends Cubit<T>
    with UseCaseBlocHelper<T> {
  final T Function(OutNext out) _onSuccess;
  final T Function(Object e, StackTrace? s) _onFailure;

  late final UseCaseValueStream _handler;

  TestCubit.consume({
    required T initialState,
    required UseCase<In, Out> useCase,
    required T Function(OutNext out) onSuccess,
    required T Function(Object e, StackTrace? s) onFailure,
    required In initialData,
    Transformer<Out, OutNext>? transformer,
  })  : _onSuccess = onSuccess,
        _onFailure = onFailure,
        super(initialState) {
    final t = transformer ?? (Stream<Out> out) => out as Stream<OutNext>;

    _handler = consume(useCase, initialData: initialData).transform(t);
  }

  TestCubit.pipe({
    required T initialState,
    required UseCase<In, Out> useCase,
    required T Function(OutNext out) onSuccess,
    required T Function(Object e, StackTrace? s) onFailure,
    Transformer<Out, OutNext>? transformer,
  })  : _onSuccess = onSuccess,
        _onFailure = onFailure,
        super(initialState) {
    final t = transformer ?? (Stream<Out> out) => out as Stream<OutNext>;

    _handler = pipe(useCase).transform<OutNext>(t);
  }

  void onHandler(In param) => (_handler as UseCaseSink<In, OutNext>)(param);

  @override
  T computeState() {
    T nextState = state;

    _handler.fold(
      defaultOnError: (Object e, StackTrace? s) => nextState = _onFailure(e, s),
      onValue: (dynamic it) => nextState = _onSuccess(it as OutNext),
    );

    return nextState;
  }
}
