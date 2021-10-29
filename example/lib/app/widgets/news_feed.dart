import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xayn_architecture_example/app/constants/r.dart';
import 'package:xayn_architecture_example/app/managers/news_feed_manager.dart';
import 'package:xayn_architecture_example/app/managers/storage_manager.dart';
import 'package:xayn_architecture_example/app/widgets/result_card.dart';
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
  late final DiscoveryApi _discoveryApi;
  late final StorageManager _storageManager;
  late final PageController _pageController;
  NewsFeedManager? _newsFeedManager;

  @override
  void initState() {
    _pageController = PageController();
    _storageManager = di.get();
    _discoveryApi = di.get();

    _pageController.addListener(() {
      if (_pageController.position.atEdge && _pageController.offset != .0) {
        _discoveryApi.handleQuery('');
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

        return SafeArea(
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemBuilder: _buildResultCard(results),
            itemCount: results.length,
          ),
        );
      },
    );
  }

  Widget Function(BuildContext, int) _buildResultCard(List<Document> results) =>
      (BuildContext context, int index) {
        final document = results[index];
        return Padding(
          padding: EdgeInsets.all(R.dimen.unit),
          child: ResultCard(document: document),
        );
      };
}
