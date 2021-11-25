import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xayn_architecture/concepts/navigation/navigator_state.dart'
    as xayn;
import 'package:xayn_architecture/concepts/navigation/page_data.dart';
import 'package:xayn_architecture/concepts/use_case/use_case_bloc_helper.dart';

class NavigatorException implements Exception {
  final String message;

  NavigatorException(this.message);
  String toString() => "NavigatorException: $message";
}

class StackManipulation {
  final List<PageData<dynamic>> _stack;
  var _disposed = false;

  StackManipulation._(this._stack);

  void pop([result]) {
    assert(_stack.isNotEmpty,
        "Stack needs to have at leased one element for a pop operation");
    final last = _stack.removeLast();
    var pendingResult = last.pendingResult;
    if (pendingResult != null && !pendingResult.isCompleted) {
      // Completing the result with null or a value.
      // Completing with null can happen when we don't provide a result because of a back navigation action;
      // FIXME result is returned before the state is updated, this could be potentially an issue
      pendingResult.complete(result);
    }
  }

  void push(PageData page) {
    assert(!_disposed,
        "Tried to use stack manipulation after it was disposed. Are you running the manipulation outside of changeStack method?");
    _stack.add(page);
  }

  Future<T?> pushForResult<T>(PageData page) {
    assert(!_disposed,
        "Tried to use stack manipulation after it was disposed. Are you running the manipulation outside of changeStack method?");
    final completer = Completer<T?>();
    _stack.add(page.copyWith(pendingResult: completer));
    return completer.future;
  }

  void replace(PageData page, [dynamic result]) {
    assert(!_disposed,
        "Tried to use stack manipulation after it was disposed. Are you running the manipulation outside of changeStack method?");
    pop(result);
    push(page);
  }

  void dispose() {
    assert(!_disposed,
        "Tried to use stack manipulation after it was disposed. Are you running the manipulation outside of changeStack method?");
    _disposed = true;
  }
}

abstract class NavigatorManager extends Cubit<xayn.NavigatorState>
    with UseCaseBlocHelper<xayn.NavigatorState> {
  final List<PageData<dynamic>> _stack;

  NavigatorManager(List<PageData> initialPages)
      : _stack = initialPages.isNotEmpty
            ? initialPages
            : throw NavigatorException(
                "At least one initial pages needs to be provided"),
        super(xayn.NavigatorState(
            pages: UnmodifiableListView(initialPages.toList(growable: false))));

  @protected
  T changeStack<T>(T Function(StackManipulation stack) batch) {
    final manipulation = StackManipulation._(_stack);
    final lastResult = batch(manipulation);
    manipulation.dispose();
    _updateState();
    return lastResult;
  }

  @protected
  Future<T?> pushForResult<T>(PageData page) {
    return changeStack((stack) => stack.pushForResult(page));
  }

  @protected
  void push(PageData page) {
    changeStack((stack) => stack.push(page));
  }

  @protected
  void pop([dynamic result]) {
    changeStack((stack) => stack.pop(result));
  }

  @protected
  void replace(PageData page, [dynamic result]) {
    changeStack((stack) => stack.replace(page, result));
  }

  void _updateState() {
    assert(_stack.isNotEmpty,
        "The page stack always needs to contain at leased one page.");
    emit(xayn.NavigatorState(
        pages: UnmodifiableListView(_stack.toList(growable: false))));
  }

  /// Should return true when pop is handled
  /// Called by the Navigator widget
  @protected
  Future<bool> popRoute() {
    if (_stack.length <= 1) {
      return SynchronousFuture(false);
    }

    pop();
    return SynchronousFuture(true);
  }

  /// Called by the Navigator Widget
  @protected
  void restoreState(xayn.NavigatorState state) {
    if (state == this.state) {
      return;
    }
    _stack.clear();
    for (var element in state.pages) {
      _stack.add(element);
    }
    _updateState();
  }
}
