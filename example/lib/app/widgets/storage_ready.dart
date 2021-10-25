import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

typedef OnReady = void Function();

class StorageReady extends StatefulWidget {
  final WidgetBuilder builder;
  final OnReady? onReady;

  const StorageReady({
    Key? key,
    required this.builder,
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
    return FutureBuilder<HydratedStorage>(
        future: getTemporaryDirectory()
            .then((path) => HydratedStorage.build(storageDirectory: path)),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final onReady = widget.onReady;

          HydratedBloc.storage = snapshot.data!;

          if (!_didCallOnReady && onReady != null) {
            _didCallOnReady = true;
            onReady();
          }

          return widget.builder(context);
        });
  }
}
