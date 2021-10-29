import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xayn_swipe_it/xayn_swipe_it.dart';

import 'package:xayn_architecture_example/app/managers/news_feed_manager.dart';
import 'package:xayn_architecture_example/app/managers/storage_manager.dart';
import 'package:xayn_architecture_example/dependency_config.dart';
import 'package:xayn_architecture_example/domain/entities/document.dart';
import 'package:xayn_architecture_example/domain/states/screen_state.dart';
import 'package:xayn_architecture_example/infrastructure/discovery_api.dart';

// ignore: implementation_imports
import 'package:xayn_discovery_engine/src/api/events/search_events.dart';
// ignore: implementation_imports
import 'package:xayn_discovery_engine/src/api/models/search_type.dart';

enum SwipeOption { like, share, dislike }

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
        discoveryApi.onClientEvent
            .add(const SearchRequested('', [SearchType.web]));
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

          final childBuilder = _buildResultCard(results);

          return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) => SizedBox(
              height: 320,
              child: Swipe(
                optionsLeft: const [SwipeOption.like, SwipeOption.share],
                optionsRight: const [SwipeOption.dislike],
                onFling: (options) => options.first,
                child: childBuilder(context, index),
                optionBuilder: (context, option, index, selected) {
                  return SwipeOptionContainer(
                    option: option,
                    color: option == SwipeOption.dislike
                        ? Colors.red
                        : option == SwipeOption.like
                            ? Colors.green
                            : Colors.white,
                    child: option == SwipeOption.dislike
                        ? const Icon(Icons.close)
                        : option == SwipeOption.like
                            ? const Icon(Icons.verified)
                            : const Icon(Icons.share),
                  );
                },
              ),
            ),
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
