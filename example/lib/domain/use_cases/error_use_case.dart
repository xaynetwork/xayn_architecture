import 'package:xayn_architecture/xayn_architecture.dart';

class ErrorUseCase<T> extends UseCase<T, T> {
  ErrorUseCase();

  @override
  Stream<T> transaction(T param) async* {
    throw Exception('kaput!');
  }
}
