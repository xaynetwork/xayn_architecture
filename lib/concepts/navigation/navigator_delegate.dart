import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xayn_architecture/concepts/navigation/navigator_state.dart'
    as xayn;
import 'package:xayn_architecture/concepts/navigation/page_data.dart';

import 'navigator_manager.dart';

/// TODO will be changed soon to support a different pageMap declaration
///
class NavigatorRouteInformationParser
    extends RouteInformationParser<xayn.NavigatorState> {
  /// @nodoc
  final Map<String, PageData> pageMap;

  /// @nodoc
  NavigatorRouteInformationParser({required this.pageMap});

  @override
  RouteInformation restoreRouteInformation(configuration) {
    final path = configuration.pages.reversed
        .map((e) => e.name)
        .reduce((value, element) => "$value/$element");
    return RouteInformation(location: "/$path");
  }

  @override
  Future<xayn.NavigatorState> parseRouteInformation(
      RouteInformation routeInformation) async {
    var url = Uri.parse(routeInformation.location ?? "/");

    final initialPages = pageMap.values.where((element) => element.isInitial);
    if (initialPages.isEmpty) {
      throw "No inital page provided!";
    }

    if (initialPages.length > 1) {
      throw "More than one initial page defined: $initialPages";
    }

    final pages = <PageData>[initialPages.first] +
        url.pathSegments.map((e) {
          final page = pageMap[e];
          if (page == null) {
            throw "No page registered with path: $e";
          }
          return page;
        }).toList();
    return xayn.NavigatorState(pages: pages);
  }
}

/// {@template use_case}
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   final navigatorDelegate = NavigatorDelegate(navigatorManager);
///   return MaterialApp.router(
///     routeInformationParser: NavigatorDelegate.defaultParser(pageMap: pageMap),
///     routerDelegate: navigatorDelegate,
///
///   );
/// }
/// ```
/// {@endtemplate}
class NavigatorDelegate extends RouterDelegate<xayn.NavigatorState>
    with PopNavigatorRouterDelegateMixin, ChangeNotifier {
  /// The NavigationManager that manages all the routing rules
  @protected
  final NavigatorManager navigatorManager;

  /// The assumption is that a navigation can be swapped arount to other subtrees and keep its
  /// state. So this is why a Navigator uses a GlobalKey. There should be no issue with having two navigators
  /// in the same tree.
  final _navigation = GlobalKey<NavigatorState>();

  /// Creates a new NavigatorDelegate.
  ///
  /// In the NavigatorDelegate works in conjunction with the [NavigatorManager]. It implements the
  /// Navigator 2.0 behaviour and renders a set of pages. Those are presented 'declarative'
  /// with in the current context and can be manipulated by using the [NavigatorManager].
  NavigatorDelegate(this.navigatorManager);

  @override
  Future<bool> popRoute() {
    // ignore: INVALID_USE_OF_PROTECTED_MEMBER
    return navigatorManager.popRoute();
  }

  final _controller = MaterialApp.createMaterialHeroController();

  @override
  Widget build(BuildContext context) => BlocBuilder(
        builder: _buildNavigator,
        bloc: navigatorManager,
      );

  Navigator _buildNavigator(BuildContext context, xayn.NavigatorState state) {
    return Navigator(
      key: _navigation,
      observers: [_controller],
      pages: state.pages
          .map(_buildWidget)
          .map((e) => MaterialPage(child: e))
          .toList(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // ignore: INVALID_USE_OF_PROTECTED_MEMBER
        navigatorManager.pop();
        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigation;

  Widget _buildWidget(PageData data) => data.builder(data.arguments);

  @override
  Future<void> setNewRoutePath(xayn.NavigatorState configuration) {
    // ignore: INVALID_USE_OF_PROTECTED_MEMBER
    navigatorManager.restoreState(configuration);
    return SynchronousFuture(null);
  }
}
