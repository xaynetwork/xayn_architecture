import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xayn_architecture/concepts/navigation/navigator_delegate.dart';
import 'package:xayn_architecture/concepts/navigation/navigator_state.dart'
    as xayn;
import 'package:xayn_architecture/concepts/navigation/page_data.dart';

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

/// The [StackManipulation] is the rule set that can be applied on a stack of [PageData].
/// Like [StackManipulation.push], [StackManipulation.pop] etc. This helper class
/// guards the [NavigatorManager] from being illegally manipulated and allows to externalize
/// route navigation rules to sub classes, see the docs of [StackManipulationFunction].
///
/// The [StackManipulation] allows to call multiple methods and create even temporary 'illegal'
/// states (like replacing the initial page)
class StackManipulation {
  final List<UntypedPageData> _stack;
  final Map<PageData, Completer> _callbacks;
  var _disposed = false;

  StackManipulation._(this._stack, this._callbacks);

  /// The current page on the stack.
  UntypedPageData? get currentPage => length > 0 ? _stack.last : null;

  /// The length of the stack
  int get length => _stack.length;

  /// Removes the top page and delivers an optional [result] to the original caller of
  /// [pushForResult]. This methods should only be called within a [NavigatorManager.manipulateStack] call.
  void pop<A>([A? result]) {
    _checkDisposed();
    assert(_stack.isNotEmpty,
        "Stack needs to have at least one element for a pop operation");
    final last = _stack.removeLast();

    final pendingResult = _callbacks.remove(last);
    if (pendingResult != null && !pendingResult.isCompleted) {
      // Completing the result with null or a value.
      // Completing with null can happen when we don't provide a result because of a back navigation action;
      // FIXME result is returned before the state is updated, this could be potentially an issue
      pendingResult.complete(result);
    }
  }

  /// Adds a new Page on top of the current stack.
  ///
  /// @see [pushForResult] if you need a result from a page.
  void push(UntypedPageData page) {
    _checkDisposed();
    _stack.add(page);
  }

  /// Add a new page on top of the current stack and requests a new result from
  /// new page, which is returned as a Future<T?>. It can be null if the page
  /// was popped without a result (like when it was swiped back/ back pressed.)
  ///
  /// @see [push] for calls that don't expect a result.
  ///
  /// Note: Awaiting this does not provide any guarantees about a successful navigation, the
  /// stack and the [NavigatorManager] are solely creating the state of the app, that will
  /// be rendered by the [NavigatorDelegate].
  Future<T?> pushForResult<T>(UntypedPageData page) {
    _checkDisposed();
    final completer = Completer<T?>();
    _callbacks[page] = completer;
    _stack.add(page);
    return completer.future;
  }

  /// Removes the current page (delivers a [result]) and puts a new [page] on top.
  void replace<A>(UntypedPageData page, [A? result]) {
    _checkDisposed();
    pop<A>(result);
    push(page);
  }

  /// Removes the current page (delivers a [result]) and puts a new [page] on top,
  /// that can be awaited for result.
  ///
  /// @see [pushForResult]
  ///
  /// Note: Awaiting this does not provide any guarantees about a successful navigation, the
  /// stack and the [NavigatorManager] are solely creating the state of the app, that will
  /// be rendered by the [NavigatorDelegate].
  Future<T?> replaceForResult<T, A>(UntypedPageData page, [A? result]) {
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

class _InitialState extends xayn.NavigatorState {
  _InitialState() : super(pages: []);
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
    implements RouteRegistration {
  final List<UntypedPageData> _stack;
  final Map<UntypedPageData, Completer> _callbacks;
  final Set<UntypedPageData> _pages;
  final List<UntypedPageData>? _initialPagesConfiguration;

  /// Creates a new Navigation Manager with a list of initial pages.
  /// Note: that the stack can not be empty and the last page can only be
  /// replaced but not popped.
  NavigatorManager({
    required Set<UntypedPageData> pages,
    List<UntypedPageData>? initialPageConfiguration,
  })  : _callbacks = {},
        _stack = [],
        _pages = pages,
        _initialPagesConfiguration = initialPageConfiguration,
        super(_InitialState()) {
    _stack.clear();
    _stack.addAll(computeInitialPages());
    _updateState();
  }

  /// Allows to safely manipulate the stack without exposing internals of the manager
  @protected
  T manipulateStack<T>(T Function(StackManipulation stack) batch) {
    final manipulation = StackManipulation._(_stack, _callbacks);
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

  /// Called by the Navigator Widget when a restored state or an external
  /// path is pushed to the app
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

  /// Override this to return a different initial page configuration than
  /// just [initialPage]
  @protected
  List<UntypedPageData> computeInitialPages() =>
      _initialPagesConfiguration ?? [initialPage];

  @override
  UntypedPageData get initialPage {
    final initialPages = _pages.where((p) => p.isInitial);
    if (initialPages.isEmpty) {
      throw NavigatorException(
          "No initial pages registered. Known pages: $_pages."
          "\nDid you miss adding an initial page?");
    }

    if (initialPages.length > 1) {
      throw NavigatorException(
          "Too many initial pages registered, found $initialPages."
          "\nDid you made a copy+paste error?");
    }

    return initialPages.first;
  }

  @override
  UntypedPageData mapSegmentToPage({required String segment}) {
    final foundPages = _pages.where((p) => p.name == segment);
    if (foundPages.isEmpty) {
      throw NavigatorException(
          "No page registered for segment: '$segment', registered pages: $_pages."
          "\nDid you miss adding a page to the NavigatorManager?");
    }

    if (foundPages.length > 1) {
      throw NavigatorException(
          "Too many pages registered for: '$segment', found $foundPages."
          "\nDid you made a copy+paste error?");
    }

    return foundPages.first;
  }
}
