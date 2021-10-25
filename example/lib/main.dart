import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xayn_architecture_example/app/managers/screen_cubit.dart';
import 'package:xayn_architecture_example/dependency_config.dart';
import 'package:xayn_architecture_example/domain/entities/user.dart';
import 'package:xayn_architecture_example/domain/states/screen_state.dart';

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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<HydratedStorage>(
        future: getTemporaryDirectory()
            .then((path) => HydratedStorage.build(storageDirectory: path)),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          HydratedBloc.storage = snapshot.data!;

          screenCubit ??= di.get();

          return BlocBuilder<ScreenCubit, ScreenState>(
              bloc: screenCubit,
              builder: (context, state) {
                const names = [
                  'Carmine',
                  'Pawel',
                  'Peter',
                  'Michael',
                  'Andrii',
                  'Christopher',
                  'Frank',
                ];

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onVerticalDragUpdate: (details) => screenCubit!
                            .onScrollUpdate(details.localPosition.dy.toInt()),
                        child: const Text(
                          'Click-drag on the text to update the position\nUses a debounce on input\n',
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () => screenCubit!.onUserUpdate(User(
                              DateTime.now().hashCode.toString(),
                              names[Random().nextInt(names.length)],
                              age: Random().nextInt(20) + 20)),
                          child: const Text('update a random User')),
                      Text('state: ${state.toJson()}'),
                    ],
                  ),
                );
              });
        });
  }
}
