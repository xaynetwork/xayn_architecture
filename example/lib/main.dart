import 'package:flutter/material.dart';
import 'package:xayn_architecture_example/app/managers/screen_cubit.dart';
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
      home: const MainScreen(title: 'Xayn test app'),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ScreenCubit? screenCubit;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const NewsFeed(),
    );
  }
}
