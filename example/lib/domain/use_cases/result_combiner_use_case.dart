import 'dart:collection';

import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/entities/result.dart';

@injectable
class ResultCombinerUseCase extends UseCase<List<Result>, List<Result>> {
  final List<Result>? _currentResults;

  ResultCombinerUseCase(this._currentResults);

  @override
  Stream<List<Result>> transaction(List<Result> param) async* {
    final queue =
        Queue<Result>.from([..._currentResults ?? const [], ...param]);

    // reduce to max 15 items
    while (queue.length > 15) {
      queue.removeFirst();
    }

    yield queue.toList(growable: false);
  }
}
