import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xayn_architecture/concepts/navigation/navigator_delegate.dart';
import 'package:xayn_architecture/concepts/navigation/navigator_state.dart'
    as xayn;
import 'package:xayn_architecture/concepts/navigation/page_data.dart';
import 'package:xayn_architecture/concepts/use_case/use_case_bloc_helper.dart';

/// A function to simplify an injected manipulator setup like this.
/// @see [NavigatorManager]
typedef StackManipulationFunction = T Function<T>(
    T Function(StackManipulation stack) batch);

/// The [NavigatorException] thrown on all general validation errors.
class NavigatorException implements Exception {
  /// @nodoc
  final String message;

  /// @nodoc
  NavigatorException(this.message);

  @override
  String toString() => "NavigatorException: $message";
}

/// The [StackManipulation] is the ruleset that can be applied on a stack of [PageData].
/// Like [StackManipulation.push], [StackManipulation.pop] etc. This helper class
/// guards the [NavigatorManager] from being illegally manipulated and allows to externalize
/// route navigation rules to sub classes, see the docs of [StackManipulationFunction].
///
/// The [StackManipulation] allows to call multiple methods and create even temporary 'illegal'
/// states (like replacing the initial page)
class StackManipulation {
  final List<PageData> _stack;
  var _disposed = false;

  StackManipulation._(this._stack);

  /// Removes the top page and delivers an optional [result] to the original caller of
  /// [pushForResult]. This methods should only be called within a [NavigatorManager.manipulateStack] call.
  void pop<A>([A? result]) {
    _checkDisposed();
    assert(_stack.isNotEmpty,
        "Stack needs to have at least one element for a pop operation");
    final last = _stack.removeLast();

    // ignore: INVALID_USE_OF_PROTECTED_MEMBER
    final pendingResult = last.pendingResult;
    if (pendingResult != null && !pendingResult.isCompleted) {
      // Completing the result with null or a value.
      // Completing with null can happen when we don't provide a result because of a back navigation action;
      // FIXME result is returned before the state is updated, this could be potentially an issue
      pendingResult.complete(result);
    }
  }

  /// Adds a new Page on top of the current stack.
  void push(PageData page) {
    _checkDisposed();
    _stack.add(page);
  }

  /// Add a new page on top of the current stack and requests a new result from
  /// new page, which is returned as a Future<T?>. It can be null if the page
  /// was popped without a result (like when it was swiped back/ back pressed.)
  Future<T?> pushForResult<T>(PageData page) {
    _checkDisposed();
    final completer = Completer<T?>();
    _stack.add(page.copyWith(pendingResult: completer));
    return completer.future;
  }

  /// Removes the current page (delivers a [result]) and puts a new [page] on top.
  void replace<A>(PageData page, [A? result]) {
    _checkDisposed();
    pop<A>(result);
    push(page);
  }

  /// Removes the current page (delivers a [result]) and puts a new [page] on top,
  /// that can be awaited for result.
  Future<T?> replaceForResult<T, A>(PageData page, [A? result]) {
    _checkDisposed();
    pop<A>(result);
    return pushForResult<T>(page);
  }

  @protected
  void _dispose() {
    _checkDisposed();
    _disposed = true;
  }

  void _checkDisposed() {
    assert(!_disposed,
        "Tried to use stack manipulation after it was disposed. Are you running the manipulation outside of changeStack method?");
  }
}

/// Base class that manages routing. It emits a [NavigatorState] that
/// contains a stack of [PageData] which should be rendered by the [NavigatorDelegate]
/// Extend the [NavigatorManager] like that to provide routing actions:
///
/// {@template navigator_manager}
/// ```dart
/// class AppNavigatorManger extends NavigatorManager {
///   AppNavigatorManger() : super([initialPage]);
///
///   SomePageExitActions get somePageExitActions =>
///       _SomePageExitActions(changeStack);
/// }
///
/// abstract class SomePageExitActions {
///   @override
///   void onPlusButtonClicked();
/// }
///
/// class _SomePageExitActions extends SomePageExitActions {
///   _SomePageExitActions(this.changeStack);
///
///   final StackManipulationFunction changeStack;
///
///   @override
///   void onPlusButtonClicked() {
///     changeStack((stack) => stack.pop());
///   }
/// }
/// ```
/// {@endtemplate}
abstract class NavigatorManager extends Cubit<xayn.NavigatorState>
    with UseCaseBlocHelper<xayn.NavigatorState> {
  final List<PageData> _stack;

  /// Creates a new Navigation Manager with a list of initial pages.
  /// Note: that the stack can not be empty and the last page can only be
  /// replaced but not popped.
  NavigatorManager(List<PageData> initialPages)
      : _stack = initialPages.isNotEmpty
            ? initialPages
            : throw NavigatorException(
                "At least one initial pages needs to be provided"),
        super(xayn.NavigatorState(
            pages: UnmodifiableListView(initialPages.toList(growable: false))));

  /// Allows to safely manipulate the stack without exposing internals of the manager
  @protected
  T manipulateStack<T>(T Function(StackManipulation stack) batch) {
    final manipulation = StackManipulation._(_stack);
    final lastResult = batch(manipulation);
    manipulation._dispose();
    _updateState();
    return lastResult;
  }

  /// Called by the Navigator Delegate
  @protected
  void pop([dynamic result]) {
    manipulateStack((stack) => stack.pop(result));
  }

  void _updateState() {
    assert(_stack.isNotEmpty,
        "The page stack always needs to contain at least one page.");
    emit(xayn.NavigatorState(
        pages: UnmodifiableListView(_stack.toList(growable: false))));
  }

  /// Should return true when pop is handled
  /// Called by the Navigator Delegate
  @protected
  Future<bool> popRoute() {
    if (_stack.length <= 1) {
      return Future.value(false);
    }

    pop();
    return Future.value(true);
  }

  /// Called by the Navigator Widget
  @protected
  bool restoreState(xayn.NavigatorState state) {
    if (state == this.state) {
      return false;
    }
    _stack.clear();
    for (var element in state.pages) {
      _stack.add(element);
    }
    _updateState();
    return true;
  }
}
