import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xayn_architecture_example/app/managers/news_feed_manager.dart';
import 'package:xayn_architecture_example/app/widgets/storage_ready.dart';
import 'package:xayn_architecture_example/dependency_config.dart';
import 'package:xayn_architecture_example/domain/entities/result.dart';
import 'package:xayn_architecture_example/domain/states/screen_state.dart';
import 'package:xayn_architecture_example/infrastructure/discovery_api.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  late final DiscoveryApi discoveryApi;
  late final NewsFeedManager newsFeedManager;
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    discoveryApi = di.get();

    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.offset != .0) {
        discoveryApi.handleQuery('');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StorageReady(
      buildDirectory: getTemporaryDirectory,
      onReady: (path) async {
        HydratedBloc.storage =
            await HydratedStorage.build(storageDirectory: path);

        newsFeedManager = di.get();
      },
      builder: _buildFeed,
    );
  }

  Widget _buildFeed(BuildContext context) {
    return BlocBuilder<NewsFeedManager, ScreenState>(
        buildWhen: (a, b) => a.results != b.results,
        bloc: newsFeedManager,
        builder: (context, state) {
          final results = state.results;

          if (results == null) {
            return Container();
          }

          return ListView.builder(
            controller: scrollController,
            itemBuilder: _buildResultCard(results),
            itemCount: results.length,
          );
        });
  }

  Widget Function(BuildContext, int) _buildResultCard(List<Result> results) =>
      (BuildContext context, int index) {
        final result = results[index];
        final imageUri = result.imageUri;

        return Stack(
          children: [
            if (imageUri != null) Image.network(result.imageUri.toString()),
            Container(
              color: const Color.fromARGB(128, 0, 0, 0),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.uri.toString(),
                    style: const TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    result.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      };
}
