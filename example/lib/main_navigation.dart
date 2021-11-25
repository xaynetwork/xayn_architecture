import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture_navigation.dart' as xayn;
import 'package:xayn_architecture_example/dependency_config.dart';

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

class PageRegistry {
  static final pageIncrement = xayn.PageData(
    isInitial: true,
    name: "pageIncrement",
    builder: (args) => PageIncrement(
      argument: args,
    ),
    arguments: 1,
  );
  static final pageDialog = xayn.PageData(
    isInitial: true,
    name: "pageDialog",
    builder: (args) => PageDialog(
      argument: args,
    ),
    arguments: 1,
  );

  static final pages = [pageIncrement, pageDialog];
  static final pageMap =
      Map.fromEntries(pages.map((e) => MapEntry(e.isInitial ? "" : e.name, e)));
}

@singleton
class AppNavigatorManger extends xayn.NavigatorManager {
  AppNavigatorManger() : super([PageRegistry.pageIncrement]);
}

class PageIncrement extends StatelessWidget {
  final int? argument;

  const PageIncrement({Key? key, required this.argument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppNavigatorManger navigatorManger = di.get();
    final count = argument ?? 0;
    return Scaffold(
      body: Center(child: Text("page $count")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (count.isEven) {
            navigatorManger.push(
                PageRegistry.pageIncrement.copyWith(arguments: count + 1));
          } else {
            final res = await navigatorManger.pushForResult(
                PageRegistry.pageDialog.copyWith(arguments: count + 1));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Received $res"),
            ));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PageDialog extends StatelessWidget {
  final int? argument;

  const PageDialog({Key? key, required this.argument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppNavigatorManger navigatorManger = di.get();
    final count = argument ?? 0;
    return Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("page $argument"),
          TextButton(
              onPressed: () {
                navigatorManger.pop(count);
              },
              child: Text("Close and Send back $count")),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigatorManger.push(PageRegistry.pageIncrement
              .copyWith(arguments: (argument ?? 0) + 1));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
