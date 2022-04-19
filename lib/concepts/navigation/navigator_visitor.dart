import 'package:flutter/cupertino.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

/// Utilities that allow to find States / Elements in the build tree while
/// considering the navigator history.
class NavigatorVisitor {
  NavigatorVisitor._();

  /// This function finds [State]s that extend or are of type [T]
  /// First: searches within the ancestors of the current [context] - like [BuildContext.findAncestorStateOfType]
  /// and then widens the search if not successful to the children of the previous [ModalRoute]
  ///
  /// It returns the first found state or Null.
  static T? findStateOfType<T>(
    BuildContext context,
  ) {
    T? foundState;
    visitChildrenRecursively(Element element) {
      if (foundState != null) {
        return false;
      }

      if (element is StatefulElement && element.state is T) {
        foundState = element.state as T;
        return false;
      }

      element.visitChildren(visitChildrenRecursively);

      return true;
    }

    visitAncestors(Element element) {
      if (element is StatefulElement && element.state is T) {
        foundState = element.state as T;
        return false;
      }

      return true;
    }

    context.visitAncestorElements(visitAncestors);
    if (foundState != null) {
      return foundState;
    }

    final history = NavigationHistoryObserver().history.toList();
    // if history = [R1, R2, R3, R4] => we are interested in R3, because R4 is the current route
    // that was already searched with [visitAncestors]. Thus we need to have at leased 2 routes
    // present in the history
    if (history.length < 2) {
      return null;
    }
    // we are not interested in the last history element because we are right now in that route.
    history.removeLast();

    while (history.isNotEmpty) {
      final last = history.removeLast();
      if (last is! ModalRoute) {
        continue;
      }

      final subtreeContext = last.subtreeContext;
      if (subtreeContext is! Element) {
        continue;
      }

      subtreeContext.visitChildren(visitChildrenRecursively);

      if (foundState != null) {
        return foundState;
      }
    }

    return foundState;
  }
}
