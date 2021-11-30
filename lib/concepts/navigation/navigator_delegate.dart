import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xayn_architecture/concepts/navigation/navigator_state.dart'
    as xayn;
import 'package:xayn_architecture/concepts/navigation/page_data.dart';

import 'navigator_manager.dart';

class NavigatorRouteInformationParser
    extends RouteInformationParser<xayn.NavigatorState> {
  final Map<String, PageData> pageMap;

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

class NavigatorDelegate extends RouterDelegate<xayn.NavigatorState>
    with PopNavigatorRouterDelegateMixin, ChangeNotifier {
  static RouteInformationParser defaultParser(
          {required Map<String, PageData> pageMap}) =>
      NavigatorRouteInformationParser(pageMap: pageMap);

  final NavigatorManager _navigationManager;
  final _navigation = GlobalKey<NavigatorState>();

  NavigatorDelegate(this._navigationManager);

  @override
  Future<bool> popRoute() {
    // ignore: INVALID_USE_OF_PROTECTED_MEMBER
    return _navigationManager.popRoute();
  }

  final _controller = MaterialApp.createMaterialHeroController();

  @override
  Widget build(BuildContext context) => BlocBuilder(
        builder: _buildNavigator,
        bloc: _navigationManager,
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
        _navigationManager.pop();
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
    _navigationManager.restoreState(configuration);
    return SynchronousFuture(null);
  }
}
