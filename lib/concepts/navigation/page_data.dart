import 'dart:async';
import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// The [PageBuilder] build a new Widget out of provided [arguments].
typedef PageBuilder<T extends Widget,A> = T Function(A? arguments);

/// Describes the page that will be displayed in on the screen.
class PageData<T extends Widget> extends Equatable {
  /// [name] a unique name, that can be used as a uri fragment (use only uri conform chars)
  String get name => isInitial ? "" : _name;
  final String _name;

  /// [isInitial] should be used when a page is the root page
  final bool isInitial;

  ///[builder] builds the page widget
  final PageBuilder<T, dynamic> builder;

  /// [arguments] are arbitary arguments delivered to the builder
  final dynamic arguments;

  /// Creates a new PageData that describes how pages are build when navigating
  const PageData({
    required String name,
    required this.builder,
    this.isInitial = false,
    this.arguments,
  })  : _name = name,
        assert(arguments is! List || arguments is UnmodifiableListView,
            "Page arguments needs to be unmodifiable! Provided: $arguments");

  /// Creates a copy of the current PageData.
  /// The [pendingResult] is always recreated because it should not be copied to another page.
  PageData copyWith({
    String? name,
    PageBuilder<T, dynamic>? builder,
    bool? isInitial,
    dynamic arguments,
  }) =>
      PageData<T>(
        isInitial: isInitial ?? this.isInitial,
        name: name ?? this.name,
        builder: builder ?? this.builder,
        arguments: arguments ?? this.arguments,
      );

  /// Because [copyWith] can not reset values that are nullable declared but non-null set, this method allows to reset the two nullable values.
  PageData clear({
    bool clearArguments = false,
    bool clearPendingResult = false,
  }) =>
      PageData<T>(
        isInitial: isInitial,
        name: name,
        builder: builder,
        arguments: clearArguments ? null : arguments,
      );

  @override
  List<Object?> get props =>
      [_name, builder, isInitial, arguments];
}
