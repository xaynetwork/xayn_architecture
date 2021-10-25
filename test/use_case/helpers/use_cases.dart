import 'package:xayn_architecture/concepts/use_case.dart';

class IntToStringUseCase extends UseCase<int, String> {
  @override
  Stream<String> transaction(int param) async* {
    yield '$param';
  }

  @override
  Stream<int> transform(Stream<int> incoming) => incoming.distinct();
}

class IntToStringErrorUseCase extends UseCase<int, String> {
  @override
  Stream<String> transaction(int param) =>
      Stream.error(Exception('something went wrong!'));
}

class MultiOutputUseCase extends UseCase<int, String> {
  @override
  Stream<String> transaction(int param) async* {
    yield param.toString();
    yield param.toString();
    yield param.toString();
  }
}

class MultiOutputWithFailureUseCase extends UseCase<int, String> {
  @override
  Stream<String> transaction(int param) async* {
    yield param.toString();
    yield param.toString();
    yield param.toString();
    throw ArgumentError('bad data!');
  }
}
