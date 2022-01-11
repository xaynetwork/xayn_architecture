import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide NavigatorState;
import 'package:xayn_architecture/xayn_architecture_navigation.dart';

/// An interface for observing the behavior of a [NavigatorDelegate].
class NavigatorDelegateObserver {
  /// Generic method that will be called when the UI received a [NavigatorState] update.
  /// Should be called after the build cycle is completed.
  @mustCallSuper
  void didChangeState(
    BuildContext context,
    NavigatorState? oldState,
    NavigatorState newState,
  ) {
    final oldPages = oldState?.pages;
    final newPages = newState.pages;

    /// This is an incomplete representation of all possible transitions between two stacks.
    /// It exists to mimic the behaviour of the [NavigatorObserver].
    /// Handle this with care.
    /// Best alternative to the usage of [didPop] [didPush] or [didReplace] is to use [didChangeState] which is
    /// guaranteed to be called when a new state was created.
    if (oldPages == null || oldPages.isEmpty) {
      if (newPages.isNotEmpty) {
        didPush(context);
      } else {
        // nothing happened, no new state was pushed
      }
    } else {
      const equality = DeepCollectionEquality();
      if (equality.equals(oldPages, newPages)) {
        // nothing happened
      } else if (oldPages.length < newPages.length &&
          equality.equals(oldPages, newPages.slice(0, oldPages.length))) {
        didPush(context);
      } else if (oldPages.length > newPages.length &&
          equality.equals(newPages, oldPages.slice(0, newPages.length))) {
        didPop(context);
      } else if (oldPages.length == newPages.length &&
          oldPages.last != newPages.last) {
        didReplace(context);
      }
    }
  }

  /// Will notify when one or multiple pages were removed from the stack
  void didPop(BuildContext context) {}

  /// Will notify when one or multiple pages were added on the stack
  void didPush(BuildContext context) {}

  /// Will notify when one or multiple pages were replaced from the stack
  void didReplace(BuildContext context) {}
}
