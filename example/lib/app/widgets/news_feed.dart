import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xayn_architecture_example/app/constants/r.dart';
import 'package:xayn_architecture_example/app/managers/news_feed_manager.dart';
import 'package:xayn_architecture_example/app/managers/storage_manager.dart';
import 'package:xayn_architecture_example/app/widgets/custom_page_scroll_physics.dart';
import 'package:xayn_architecture_example/app/widgets/result_card.dart';
import 'package:xayn_architecture_example/dependency_config.dart';
import 'package:xayn_architecture_example/domain/entities/document.dart';
import 'package:xayn_architecture_example/domain/states/screen_state.dart';
import 'package:xayn_architecture_example/infrastructure/discovery_api.dart';
import 'package:xayn_swipe_it/xayn_swipe_it.dart';

// ignore: implementation_imports
import 'package:xayn_discovery_engine/src/api/events/search_events.dart';
// ignore: implementation_imports
import 'package:xayn_discovery_engine/src/domain/models/search_type.dart';

enum SwipeOption { like, share, dislike }

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  late final DiscoveryApi _discoveryApi;
  late final StorageManager _storageManager;
  late final ScrollController _scrollController;
  NewsFeedManager? _newsFeedManager;

  @override
  void initState() {
    _scrollController = ScrollController();
    _storageManager = di.get();
    _discoveryApi = di.get();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge && _scrollController.offset != .0) {
        _discoveryApi.onClientEvent
            .add(const SearchRequested('', [SearchType.web]));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageManager, StorageState>(
      bloc: _storageManager,
      builder: (context, state) {
        if (!state.isReady) {
          return Container();
        }

        _newsFeedManager ??= di.get();

        return _buildFeed(context);
      },
    );
  }

  Widget _buildFeed(BuildContext context) {
    return BlocBuilder<NewsFeedManager, ScreenState>(
      bloc: _newsFeedManager,
      builder: (context, state) {
        final results = state.results;

        if (results == null) {
          return const CircularProgressIndicator();
        }
        final padding = MediaQuery.of(context).padding;
        return Padding(
          padding: EdgeInsets.only(top: padding.top),
          child: LayoutBuilder(builder: (context, constraints) {
            final pageSize = constraints.maxHeight - padding.bottom;
            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemExtent: pageSize,
                physics: CustomPageScrollPhysics(pageSize: pageSize),
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                itemBuilder: _itemBuilder(results),
                itemCount: results.length,
              ),
            );
          }),
        );
      },
    );
  }

  Widget Function(BuildContext, int) _itemBuilder(List<Document> results) =>
      (BuildContext context, int index) {
        final document = results[index];
        return _buildResultCard(document);
      };

  Widget _buildSwipeWidget({required Widget child}) => Swipe(
        optionsLeft: const [SwipeOption.like, SwipeOption.share],
        optionsRight: const [SwipeOption.dislike],
        onFling: (options) => options.first,
        child: child,
        optionBuilder: (context, option, index, selected) {
          return SwipeOptionContainer(
            option: option,
            color: option == SwipeOption.dislike
                ? R.colors.swipeBackgroundDelete
                : option == SwipeOption.like
                    ? R.colors.swipeBackgroundRelevant
                    : R.colors.swipeBackgroundShare,
            child: option == SwipeOption.dislike
                ? const Icon(Icons.close)
                : option == SwipeOption.like
                    ? const Icon(Icons.verified)
                    : const Icon(Icons.share),
          );
        },
      );

  Widget _buildResultCard(Document document) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: R.dimen.unit,
          vertical: R.dimen.unit0_5,
        ),
        child: _buildSwipeWidget(
          child: ResultCard(
            title: document.webResource.title,
            snippet: document.webResource.snippet,
            imageUrl: document.webResource.displayUrl.toString(),
            url: document.webResource.url,
          ),
        ),
      );
}
