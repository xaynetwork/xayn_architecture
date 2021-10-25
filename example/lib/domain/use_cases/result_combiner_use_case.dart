import 'dart:collection';

import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/entities/result.dart';

@injectable
class ResultCombinerUseCase
    extends UseCase<Iterable<List<Result>>, List<Result>> {
  ResultCombinerUseCase();

  @override
  Stream<List<Result>> transaction(Iterable<List<Result>> param) async* {
    final oldResults = param.first, incomingResults = param.last;
    final queue = Queue<Result>.from([...oldResults, ...incomingResults]);

    while (queue.length > 5) {
      queue.removeFirst();
    }

    yield queue.toList(growable: false);
  }
}
