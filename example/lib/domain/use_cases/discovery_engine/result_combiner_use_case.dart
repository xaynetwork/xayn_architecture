import 'dart:collection';

import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/entities/document.dart';

@injectable
class ResultCombinerUseCase extends UseCase<List<Document>, List<Document>> {
  final List<Document>? _currentResults;

  ResultCombinerUseCase(this._currentResults);

  @override
  Stream<List<Document>> transaction(List<Document> param) async* {
    final queue =
        Queue<Document>.from([..._currentResults ?? const [], ...param]);

    // reduce to max 15 items
    while (queue.length > 15) {
      queue.removeFirst();
    }

    yield queue.toList(growable: false);
  }
}
