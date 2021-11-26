import 'package:flutter/material.dart';
import 'package:xayn_architecture/xayn_architecture_navigation.dart' as xayn;
import 'package:xayn_architecture_example/dependency_config.dart';
import 'package:xayn_architecture_example/navigation/app_navigator.dart';
import 'package:xayn_architecture_example/navigation/pages.dart';

void main() {
  configureDependencies();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    AppNavigatorManger manger = di.get();
    return MaterialApp.router(
      routeInformationParser:
          xayn.NavigatorRouteInformationParser(pageMap: PageRegistry.pageMap),
      routerDelegate: xayn.NavigatorWidget(manger),
      title: 'Navigator Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
