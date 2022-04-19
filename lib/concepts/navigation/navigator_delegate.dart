import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:xayn_architecture/concepts/navigation/navigator_observer.dart';
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

    var pages = url.pathSegments
        .map((e) => _routeRegistration.mapSegmentToPage(segment: e))
        .toList();
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

  final List<NavigatorDelegateObserver> _observers;

  /// Creates a new NavigatorDelegate.
  ///
  /// In the NavigatorDelegate works in conjunction with the [NavigatorManager]. It implements the
  /// Navigator 2.0 behaviour and renders a set of pages. Those are presented 'declarative'
  /// with in the current context and can be manipulated by using the [NavigatorManager].
  NavigatorDelegate(this.navigatorManager,
      {List<NavigatorDelegateObserver>? observers})
      : _observers = observers ?? [];

  final _heroController = MaterialApp.createMaterialHeroController();
  final _history = NavigationHistoryObserver();
  xayn.NavigatorState? _lastState;

  @override
  Widget build(BuildContext context) => buildNavigator();

  /// Builds a navigator widget that reacts to changes of the Navigation Manager.
  /// Can be customized by passing
  /// - [observers] : NavigatorObservers that can react on popping a route
  Widget buildNavigator({
    List<NavigatorDelegateObserver> observers = const [],
    Function(BuildContext)? didUpdatedPages,
  }) =>
      BlocBuilder(
        builder: (context, xayn.NavigatorState state) => _buildNavigator(
          context: context,
          state: state,
          observers: observers,
        ),
        bloc: navigatorManager,
      );

  Navigator _buildNavigator({
    required BuildContext context,
    required xayn.NavigatorState state,
    List<NavigatorDelegateObserver> observers = const [],
  }) {
    if (state.pages.isEmpty) {
      throw "Pushed invalid state to Navigator, needs to have at least one page: $state";
    }

    // this should run after build when not awaited
    _notifyObserversAfterBuild(observers + _observers, context, state);

    return Navigator(
      key: _navigation,
      observers: [
        _heroController,
        _history,
      ],
      pages: state.pages.map((p) => p.buildPage(context)).toList(),
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

  // based on this comment https://stackoverflow.com/a/51273797/495800
  // this function will be executed after the build if it runs unawaited.
  Future<void> _notifyObserversAfterBuild(
    List<NavigatorDelegateObserver> observers,
    BuildContext context,
    xayn.NavigatorState currentState,
  ) async {
    final lastState = _lastState;
    _lastState = currentState;
    for (var element in observers) {
      element.didChangeState(context, lastState, currentState);
    }
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigation;

  @override
  Future<void> setInitialRoutePath(xayn.NavigatorState configuration) {
    return super.setInitialRoutePath(xayn.NavigatorState(
        pages: configuration.pages, source: xayn.Source.initialization));
  }

  @override
  Future<void> setRestoredRoutePath(xayn.NavigatorState configuration) {
    return super.setRestoredRoutePath(xayn.NavigatorState(
        pages: configuration.pages, source: xayn.Source.restoration));
  }

  @override
  Future<void> setNewRoutePath(xayn.NavigatorState configuration) {
    if (configuration.source == xayn.Source.unknown) {
      configuration = xayn.NavigatorState(
          pages: configuration.pages, source: xayn.Source.external);
    }
    // ignore: INVALID_USE_OF_PROTECTED_MEMBER
    navigatorManager.restoreState(configuration);
    return SynchronousFuture(null);
  }
}
