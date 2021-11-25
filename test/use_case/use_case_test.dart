import 'package:test/test.dart';
import 'package:xayn_architecture/xayn_architecture_test.dart';

import '../helpers/use_cases.dart';

void main() {
  group('Use case: ', () {
    useCaseTest(
      'Returns UseCaseResult with data: ',
      build: () => IntToStringUseCase(),
      input: const [1],
      expect: [useCaseSuccess('1')],
    );

    useCaseTest(
      'Returns 3 UseCaseResults with data for multiUseCase: ',
      build: () => MultiOutputUseCase(),
      input: const [1],
      expect: [
        useCaseSuccess('1'),
        useCaseSuccess('1'),
        useCaseSuccess('1'),
      ],
    );

    useCaseTest(
      'Returns UseCaseResult with exception: ',
      build: () => IntToStringErrorUseCase(),
      input: [1],
      expect: [useCaseFailure(throwsException)],
    );

    // emits the input 3 times, but as a String, and then throws an ArgumentException
    useCaseTest(
      'Can mix results and errors: ',
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

  group('single output: ', () {
    test('can emit a single output: ', () async {
      final useCase = IntToStringUseCase();

      await expectLater(useCase.singleOutput(1), completion('1'));
    });

    test('throws on exceptions: ', () async {
      final useCase = IntToStringErrorUseCase();

      await expectLater(useCase.singleOutput(1), throwsException);
    });

    test('throws on exceptions even when emitting output as well: ', () async {
      final useCase = MixOutputAndErrorsUseCase();

      await expectLater(useCase.singleOutput(1), throwsArgumentError);
    });

    test('throws range error on multi output: ', () async {
      final useCase = MultiOutputUseCase();

      await expectLater(useCase.singleOutput(1), throwsRangeError);
    });

    test('throws range error on no output: ', () async {
      final useCase = NoOutputUseCase();

      await expectLater(useCase.singleOutput(1), throwsRangeError);
    });
  });
}
