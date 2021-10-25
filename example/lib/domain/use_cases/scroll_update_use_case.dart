import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xayn_architecture/xayn_architecture.dart';

@visibleForTesting
const Duration kScrollUpdateUseCaseDebounceTime = Duration(milliseconds: 600);

@injectable
class ScrollUpdateUseCase extends UseCase<int, int> {
  ScrollUpdateUseCase();

  @override
  Stream<int> transaction(int param) async* {
    yield param;
  }

  @override
  Stream<int> transform(Stream<int> incoming) =>
      incoming.debounceTime(kScrollUpdateUseCaseDebounceTime);
}
