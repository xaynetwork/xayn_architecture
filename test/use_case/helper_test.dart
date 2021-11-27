import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:xayn_architecture/xayn_architecture.dart';

import '../helpers/use_cases.dart';
import 'use_case_bloc_helper_test.dart';

void main() {
  late NoInputUseCase useCase;
  late TestCubit testCubit;

  setUp(() {
    useCase = NoInputUseCase();
    testCubit = TestCubit<String, None, String, String>.consume(
        initialState: 'empty',
        useCase: useCase,
        onSuccess: (it) => it,
        onFailure: (e, s) => 'not ok',
        initialData: none);
  });

  group('Use case bloc helper: ', () {
    blocTest('consume with none: ',
        build: () => testCubit, expect: () => const ['ok!']);
  });
}
