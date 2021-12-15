import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xayn_architecture/concepts/navigation/navigator_state.dart'
    as xayn;
import 'package:xayn_architecture/concepts/navigation/page_data.dart';

import 'navigator_manager.dart';

/// @nodoc
abstract class RouteRegistration {
  /// The page that usually would be translated from '/'
  UntypedPageData get initialPage;

  /// Maps segments of a url (i.e. user, details, ... from /user/details) to
  /// a page.
  UntypedPageData mapSegmentToPage({required String segment});
}

/// The default route parser that simply splits a url in segments and
/// translates those with the help of the [RouteRegistration], that should be
/// implemented in conjunction with the [NavigatorManager] for internal consistency.
class NavigatorRouteInformationParser
    extends RouteInformationParser<xayn.NavigatorState> {
  final RouteRegistration _routeRegistration;

  /// @nodoc
  NavigatorRouteInformationParser(this._routeRegistration);

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

    var pages = url.pathSegments.map((e) {
      return _routeRegistration.mapSegmentToPage(segment: e);
    }).toList();
    if (pages.isEmpty || !pages.first.isInitial) {
      pages = <UntypedPageData>[_routeRegistration.initialPage] + pages;
    }

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

  /// The assumption is that a navigation can be swapped around to other subtrees and keep its
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
  Widget build(BuildContext context) => buildNavigator();

  /// Builds a navigator widget that reacts to changes of the Navigation Manager.
  /// Can be customized by passing
  /// - [observers] : NavigatorObservers that can react on popping a route
  Widget buildNavigator({
    List<NavigatorObserver> observers = const [],
  }) =>
      BlocBuilder(
        builder: (context, xayn.NavigatorState state) => _buildNavigator(
            context: context, state: state, observers: observers),
        bloc: navigatorManager,
      );

  Navigator _buildNavigator({
    required BuildContext context,
    required xayn.NavigatorState state,
    List<NavigatorObserver> observers = const [],
  }) {
    if (state.pages.isEmpty) {
      throw "Pushed invalid state to Navigator, needs to have at least one page: $state";
    }

    return Navigator(
      key: _navigation,
      observers: observers + [_controller],
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

  T _buildWidget<T extends Widget>(PageData<T, Object> data) {
    return data.builder(data.arguments);
  }

  @override
  Future<void> setNewRoutePath(xayn.NavigatorState configuration) {
    // ignore: INVALID_USE_OF_PROTECTED_MEMBER
    navigatorManager.restoreState(configuration);
    return SynchronousFuture(null);
  }
}
