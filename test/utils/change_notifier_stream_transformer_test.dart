import 'package:flutter/cupertino.dart';
import 'package:test/test.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture/xayn_architecture_test.dart';

void main() {
  late ChangeNotifier changeNotifier;

  group('Change Notifiers: ', () {
    useCaseTest(
      'ChangeNotifier: ',
      setUp: () {
        changeNotifier = TestChangeNotifier(initialValue: 0);
      },
      act: () {
        final notifier = changeNotifier as TestChangeNotifier;

        notifier.value = 1;
        notifier.value = 2;
        notifier.value = 3;
      },
      build: () => TestChangeNotifierUseCase(
          changeNotifier, () => (changeNotifier as TestChangeNotifier).value),
      input: const [0], // ignored
      expect: [
        useCaseSuccess(0),
        useCaseSuccess(1),
        useCaseSuccess(2),
        useCaseSuccess(3),
      ],
    );

    useCaseTest(
      'ValueNotifier: ',
      setUp: () {
        changeNotifier = ValueNotifier(0);
      },
      act: () {
        final notifier = changeNotifier as ValueNotifier;

        notifier.value = 1;
        notifier.value = 2;
        notifier.value = 3;
      },
      build: () => TestChangeNotifierUseCase(
          changeNotifier, () => (changeNotifier as ValueNotifier).value),
      input: const [0], // ignored
      expect: [
        useCaseSuccess(0),
        useCaseSuccess(1),
        useCaseSuccess(2),
        useCaseSuccess(3),
      ],
    );
  });
}

class TestChangeNotifierUseCase extends UseCase<int, int> {
  final ChangeNotifier _changeNotifier;
  final int Function() resolveValue;

  TestChangeNotifierUseCase(
    this._changeNotifier,
    this.resolveValue,
  );

  @override
  Stream<int> transaction(int param) async* {
    yield* _changeNotifier.asStream(resolveValue);
  }
}

class TestChangeNotifier extends ChangeNotifier {
  TestChangeNotifier({required int initialValue}) : _value = initialValue;

  int _value;

  int get value => _value;
  set value(int v) {
    if (_value != v) {
      _value = v;
      notifyListeners();
    }
  }
}
