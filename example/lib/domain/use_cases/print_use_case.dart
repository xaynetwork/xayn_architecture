import 'dart:developer';

import 'package:xayn_architecture/xayn_architecture.dart';

class PrintUseCase<T> extends UseCase<T, T> {
  PrintUseCase();

  @override
  Stream<T> transaction(T param) async* {
    log('print! $param');
    yield param;
  }
}
