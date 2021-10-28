import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xayn_architecture_example/app/managers/news_feed_manager.dart';
import 'package:xayn_architecture_example/app/managers/storage_manager.dart';
import 'package:xayn_architecture_example/dependency_config.dart';
import 'package:xayn_architecture_example/domain/entities/document.dart';
import 'package:xayn_architecture_example/domain/states/screen_state.dart';
import 'package:xayn_architecture_example/infrastructure/discovery_api.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  late final DiscoveryApi discoveryApi;
  late final StorageManager storageManager;
  late final ScrollController scrollController;
  NewsFeedManager? newsFeedManager;

  @override
  void initState() {
    scrollController = ScrollController();
    storageManager = di.get();
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
    return BlocBuilder<StorageManager, StorageState>(
      bloc: storageManager,
      builder: (context, state) {
        if (!state.isReady) {
          return Container();
        }

        newsFeedManager ??= di.get();

        return _buildFeed(context);
      },
    );
  }

  Widget _buildFeed(BuildContext context) {
    return BlocBuilder<NewsFeedManager, ScreenState>(
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

  Widget Function(BuildContext, int) _buildResultCard(List<Document> results) =>
      (BuildContext context, int index) {
        final result = results[index];
        final imageUri = result.webResource.displayUrl;

        return Stack(
          children: [
            if (imageUri.toString() != 'https://www.xayn.com')
              Image.network(
                result.webResource.displayUrl.toString(),
                errorBuilder: (context, e, s) => Container(),
              ),
            Container(
              color: const Color.fromARGB(128, 0, 0, 0),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.webResource.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    result.webResource.url.toString(),
                    style: const TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    result.webResource.snippet,
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
