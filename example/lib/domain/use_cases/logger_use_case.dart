import 'dart:developer';

import 'package:xayn_architecture/xayn_architecture.dart';

typedef LoggerBuilder<T> = String Function(T data);
typedef LoggerWhen<T> = bool Function(T data);

class LoggerUseCase<T> extends UseCase<T, T> {
  final LoggerBuilder<T> builder;
  final LoggerWhen<T>? when;

  LoggerUseCase(this.builder, {this.when});

  @override
  Stream<T> transaction(T param) async* {
    final predicate = when ?? (_) => true;

    if (predicate(param)) {
      log(builder(param));
    }

    yield param;
  }
}
