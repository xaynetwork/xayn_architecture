import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      newsFeedManager.onScrollUpdate(scrollController.offset.round());

      if (scrollController.position.atEdge && scrollController.offset != .0) {
        discoveryApi.onQuery(const DiscoveryQueryEvent(query: 'test'));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StorageReady(
        onReady: () => newsFeedManager = di.get(), builder: _buildFeed);
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

          if (scrollController.hasClients) {
            final offset = scrollController.offset - 640;

            if (offset > .0) {
              scrollController.jumpTo(offset);
            }
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

        return Container(
          height: 320,
          padding: const EdgeInsets.all(32.0),
          margin: const EdgeInsets.all(32.0),
          color: Colors.black,
          child: Text(
            '${result.description}\n${result.uri}',
            style: const TextStyle(color: Colors.white),
          ),
        );
      };
}
