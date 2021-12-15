import 'package:flutter/material.dart';
import 'package:xayn_architecture/xayn_architecture_navigation.dart' as xayn;
import 'package:xayn_architecture_example/dependency_config.dart';
import 'package:xayn_architecture_example/navigation/app_navigator.dart';

void main() {
  configureDependencies();

  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final AppNavigatorManger _manager = di.get();

  @override
  Widget build(BuildContext context) {
    final parser = xayn.NavigatorRouteInformationParser(_manager);
    final navigatorDelegate = xayn.NavigatorDelegate(_manager);
    return MaterialApp.router(
      routeInformationParser: parser,
      routerDelegate: navigatorDelegate,
      title: 'Navigator Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
