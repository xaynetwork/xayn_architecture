import 'package:flutter/material.dart';
import 'package:xayn_architecture_example/app/widgets/news_feed.dart';
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
    return MaterialApp(
      title: 'Xayn test app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NewsFeed(),
    );
  }
}
