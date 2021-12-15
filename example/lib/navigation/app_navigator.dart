import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture_navigation.dart' as xayn;
import 'package:xayn_architecture_example/navigation/pages.dart';

@singleton
class AppNavigatorManger extends xayn.NavigatorManager {
  AppNavigatorManger() : super(pages: PageRegistry.pages);

  PageIncrementExitActions get pageIncrementExitActions =>
      _PageIncrementExitActions(manipulateStack);

  PageDialogExitActions get pageDialogExitActions =>
      _PageDialogExitActions(manipulateStack);
}

class _PageIncrementExitActions extends PageIncrementExitActions {
  _PageIncrementExitActions(this.changeStack);

  final xayn.StackManipulationFunction changeStack;

  @override
  void onPlusButtonClicked(int argument) {
    changeStack((stack) => stack
        .push(PageRegistry.pageIncrement.copyWith(arguments: argument + 1)));
  }

  @override
  Future<int?> onPlusButtonClickedForResult(int argument) {
    return changeStack((stack) => stack.pushForResult(
        PageRegistry.pageDialog.copyWith(arguments: argument + 1)));
  }
}

class _PageDialogExitActions extends PageDialogExitActions {
  _PageDialogExitActions(this.changeStack);

  final xayn.StackManipulationFunction changeStack;

  @override
  void onPlusButtonClicked(int argument) {
    changeStack((stack) => stack
        .push(PageRegistry.pageIncrement.copyWith(arguments: argument + 1)));
  }

  @override
  void onSubmittedResult(int result) {
    changeStack((stack) => stack.pop(result));
  }
}
