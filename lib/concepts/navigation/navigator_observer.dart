import 'package:flutter/material.dart' hide NavigatorState;
import 'package:xayn_architecture/concepts/navigation/navigator_delegate.dart';
import 'package:xayn_architecture/concepts/navigation/navigator_manager.dart';
import 'package:xayn_architecture/concepts/navigation/navigator_state.dart';
import 'package:xayn_architecture/concepts/navigation/page_data.dart';

/// An interface for observing the behavior of a [Navigator].
class NavigatorObserver {
  /// [BuildContext], in which the [Navigator] build inside [NavigatorDelegate]
  BuildContext? get context => _context;
  BuildContext? _context;

  /// Updates the [_context]
  void updateContext(BuildContext? context) {
    _context = context;
  }

  /// Triggered, when [NavigatorState.source] is [Source.initialization]
  void init() {}

  /// Called, when [NavigatorState] is restored via [NavigatorManager.restoreState]
  void restored() {}

  /// Called everytime, when [StackManipulation.pop] is triggered
  void didPop(PageData? next, PageData? prev) {}

  /// Called everytime, when [StackManipulation.push] or [StackManipulation.pushForResult] is triggered
  void didPush(PageData next, PageData? prev) {}
}
