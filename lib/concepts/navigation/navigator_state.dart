import 'package:equatable/equatable.dart';
import 'package:xayn_architecture/concepts/navigation/navigator_manager.dart';
import 'package:xayn_architecture/concepts/navigation/page_data.dart';

/// A source that describes by what event the State was created.
enum Source {
  /// Unknown source. Mainly used until we can determine the source.
  unknown,

  /// Routes created internally by the [NavigatorManager] itself
  navigator,

  /// Route that is pushed from an external source (like the browser Nav bar or a deep-link)
  external,

  /// Route that is created during the state restoration
  restoration,

  /// Route that is pushed on the creation of the widget.
  /// The responsible routeName for the initial route is: [_WidgetsAppState._initialRouteName]
  initialization,
}

/// The [NavigatorState] describes which pages will be rendered in the [Navigator] Widget.
class NavigatorState extends Equatable {
  /// see [NavigatorState] constructor
  final List<UntypedPageData> pages;

  /// The source from where the state was pushed from
  final Source source;

  /// - [pages] represent the pages that are currently available in the Navigator backstack.
  NavigatorState({
    required List<UntypedPageData> pages,
    this.source = Source.unknown,
  }) : pages = List.unmodifiable(pages);

  @override
  List<Object?> get props => [pages, source];
}
