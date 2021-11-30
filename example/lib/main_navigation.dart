import 'package:flutter/material.dart';
import 'package:xayn_architecture/xayn_architecture_navigation.dart' as xayn;
import 'package:xayn_architecture_example/dependency_config.dart';
import 'package:xayn_architecture_example/navigation/app_navigator.dart';
import 'package:xayn_architecture_example/navigation/pages.dart';

void main() {
  configureDependencies();

  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final AppNavigatorManger _manger = di.get();
  final _parser =
      xayn.NavigatorRouteInformationParser(pageMap: PageRegistry.pageMap);

  @override
  Widget build(BuildContext context) {
    final navigatorDelegate = xayn.NavigatorDelegate(_manger);
    return MaterialApp.router(
      routeInformationParser: _parser,
      routerDelegate: navigatorDelegate,
      title: 'Navigator Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
