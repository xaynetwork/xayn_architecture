import 'dart:async';

import 'package:test/test.dart';
import 'package:xayn_architecture/concepts/use_case/transformers/use_case_transformer.dart';

import 'helpers/use_cases.dart';

void main() {
  late IntToStringUseCase useCase;
  late StreamController<int> controller;

  setUp(() {
    useCase = IntToStringUseCase();
    controller = StreamController<int>();
  });

  group('Use case stream transformer: ', () {
    group('followedBy: ', () {
      test('acts like switchMap: ', () {
        final stream = useCase.transform(controller.stream).transform(
              UseCaseStreamTransformer(
                useCase.transaction,
                false,
              ),
            );

        controller.add(1);
        controller.add(2);
        controller.add(3);
        controller.close();

        expect(stream, emitsInOrder(['3', emitsDone]));
      });
    });

    group('switchedBy: ', () {
      test('acts like asyncExpand: ', () {
        final stream = useCase.transform(controller.stream).transform(
              UseCaseStreamTransformer(
                useCase.transaction,
                true,
              ),
            );

        controller.add(1);
        controller.add(2);
        controller.add(3);
        controller.close();

        expect(stream, emitsInOrder(['1', '2', '3', emitsDone]));
      });
    });
  });
}
