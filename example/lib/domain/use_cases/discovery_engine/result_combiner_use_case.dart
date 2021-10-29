import 'dart:collection';

import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/entities/document.dart';
import 'package:xayn_architecture_example/infrastructure/discovery_api.dart';

class ResultCombinerUseCase
    extends UseCase<DiscoveryApiState, ResultCombinerJob> {
  final List<Document>? _currentResults;

  ResultCombinerUseCase(this._currentResults);

  @override
  Stream<ResultCombinerJob> transaction(DiscoveryApiState param) async* {
    if (param.isComplete) {
      final queue = Queue<Document>.from(
          [..._currentResults ?? const [], ...param.results]);
      var removals = 0;

      // reduce to max 15 items
      while (queue.length > 15) {
        queue.removeFirst();
        removals++;
      }

      yield ResultCombinerJob(
        queue.toList(growable: false),
        added: param.results.length,
        removed: removals,
        apiState: param,
      );
    } else {
      yield ResultCombinerJob(
        _currentResults ?? const [],
        added: 0,
        removed: 0,
        apiState: param,
      );
    }
  }
}

class ResultCombinerJob {
  final int added, removed;
  final List<Document> documents;
  final DiscoveryApiState apiState;

  const ResultCombinerJob(
    this.documents, {
    required this.added,
    required this.removed,
    required this.apiState,
  });
}
