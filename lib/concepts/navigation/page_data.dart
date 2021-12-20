import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The [WidgetBuilder] build a new Widget out of provided [arguments].
typedef WidgetBuilder<T extends Widget, A> = T Function(
    BuildContext context, A? arguments);

/// The [PageBuilder] build the [Page] and within the [PageRoute] that
/// allows to control transitions and custom page route behaviors.
typedef PageBuilder<T extends Widget> = Page Function(
    BuildContext context, T widget);

/// Signature of generic, untyped page data.
typedef UntypedPageData = PageData<Widget, Object>;

/// Signature of a generic, untyped page builder.
typedef UntypedPageBuilder = WidgetBuilder<Widget, Object>;

/// Describes the page that will be displayed in on the screen.
class PageData<T extends Widget, A> extends Equatable {
  /// [name] a unique name, that can be used as a uri fragment (use only uri conform chars)
  String get name => _name;
  final String _name;

  /// [isInitial] should be used when a page is the root page
  final bool isInitial;

  ///[builder] builds the page widget
  final WidgetBuilder<T, A> builder;

  /// [pageBuilder] build the [Page] and within the [PageRoute]
  final PageBuilder? pageBuilder;

  /// [arguments] are arbitrary arguments delivered to the builder
  final A? arguments;

  /// Creates a new PageData that describes how pages are build when navigating
  const PageData({
    required String name,
    required this.builder,
    this.isInitial = false,
    this.arguments,
    this.pageBuilder,
  })  : _name = name,
        assert(arguments is! List || arguments is UnmodifiableListView,
            "Page arguments needs to be unmodifiable! Provided: $arguments");

  /// Builds the page that will also handle the transition.
  /// The [MaterialPage] is the default Page.
  Page buildPage(BuildContext context) {
    final widget = builder(context, arguments);
    return pageBuilder == null
        ? MaterialPage(child: widget)
        : pageBuilder!(context, widget);
  }

  /// Creates a copy of the current PageData.
  /// The [pendingResult] is always recreated because it should not be copied to another page.
  PageData<T, A> copyWith({
    String? name,
    WidgetBuilder<T, A>? builder,
    bool? isInitial,
    A? arguments,
  }) =>
      PageData<T, A>(
        isInitial: isInitial ?? this.isInitial,
        name: name ?? this.name,
        builder: builder ?? this.builder,
        arguments: arguments ?? this.arguments,
      );

  /// Because [copyWith] can not reset values that are nullable declared but non-null set, this method allows to reset the two nullable values.
  PageData<T, A> clear({
    bool clearArguments = false,
    bool clearPendingResult = false,
  }) =>
      PageData<T, A>(
        isInitial: isInitial,
        name: name,
        builder: builder,
        arguments: clearArguments ? null : arguments,
      );

  @override
  List<Object?> get props => [
        _name,
        builder,
        isInitial,
        arguments,
        pageBuilder,
      ];
}
