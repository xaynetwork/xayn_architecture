import 'package:test/test.dart';
import 'package:xayn_architecture/concepts/use_case_test.dart';

import 'helpers/use_cases.dart';

void main() {
  group('Use case', () {
    useCaseTest(
      'Returns UseCaseResult with data',
      build: () => IntToStringUseCase(),
      input: const [1],
      expect: [useCaseSuccess('1')],
    );

    useCaseTest(
      'Returns 3 UseCaseResults with data for multiUseCase',
      build: () => MultiOutputUseCase(),
      input: const [1],
      expect: [
        useCaseSuccess('1'),
        useCaseSuccess('1'),
        useCaseSuccess('1'),
      ],
    );

    useCaseTest(
      'Returns UseCaseResult with exception',
      build: () => IntToStringErrorUseCase(),
      input: [1],
      expect: [useCaseFailure(throwsException)],
    );

    // emits the input 3 times, but as a String, and then throws an ArgumentException
    useCaseTest(
      'Can mix results and errors',
      build: () => MixOutputAndErrorsUseCase(),
      input: [1],
      expect: [
        useCaseSuccess('1'),
        useCaseSuccess('1'),
        useCaseSuccess('1'),
        useCaseFailure(throwsArgumentError),
      ],
    );
  });
}
