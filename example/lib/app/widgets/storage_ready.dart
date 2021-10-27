import 'dart:io';

import 'package:flutter/widgets.dart';

typedef OnReady = Future<void> Function(Directory);
typedef BuildDirectory = Future<Directory> Function();

class StorageReady extends StatefulWidget {
  final WidgetBuilder builder;
  final OnReady? onReady;
  final BuildDirectory buildDirectory;

  const StorageReady({
    Key? key,
    required this.builder,
    required this.buildDirectory,
    this.onReady,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StorageReadyState();
}

class _StorageReadyState extends State<StorageReady> {
  bool _didCallOnReady = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onReady(Directory path) async {
      if (_didCallOnReady) {
        return path;
      }

      final handler = widget.onReady ?? (_) async {};

      await handler(path);

      _didCallOnReady = true;

      return path;
    }

    return FutureBuilder<Directory>(
        future: widget.buildDirectory().then(onReady),
        builder: (_, snapshot) {
          if (!_didCallOnReady) {
            return Container();
          }

          return widget.builder(context);
        });
  }
}
