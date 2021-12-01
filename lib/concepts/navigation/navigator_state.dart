import 'package:equatable/equatable.dart';
import 'package:xayn_architecture/concepts/navigation/page_data.dart';

/// The [NavigatorState] describes which pages will be rendered in the [Navigator] Widget.
class NavigatorState extends Equatable {
  /// see [NavigatorState] constructor
  final List<PageData> pages;

  /// - [pages] represent the pages that are currently available in the Navigator backstack.
  NavigatorState({required List<PageData> pages})
      : pages = List.unmodifiable(pages);

  @override
  List<Object?> get props => [pages];
}
