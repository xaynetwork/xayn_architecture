import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xayn_architecture_example/app/managers/screen_cubit.dart';
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
  late final ScreenCubit screenCubit;
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    discoveryApi = di.get();

    scrollController.addListener(() {
      screenCubit.onScrollUpdate(scrollController.offset.round());

      if (scrollController.position.atEdge && scrollController.offset != .0) {
        discoveryApi.onQuery(const DiscoveryQueryEvent(query: 'test'));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StorageReady(
        onReady: () => screenCubit = di.get(), builder: _buildFeed);
  }

  Widget _buildFeed(BuildContext context) {
    return BlocBuilder<ScreenCubit, ScreenState>(
        buildWhen: (a, b) => a.results != b.results,
        bloc: screenCubit,
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

        return Container(
          height: 320,
          color: Colors.red,
          child: Text(result.description),
        );
      };
}
