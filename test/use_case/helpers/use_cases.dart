import 'package:xayn_architecture/concepts/use_case.dart';

class IntToDoubleUseCase extends UseCase<int, double> {
  @override
  Stream<double> transaction(int param) async* {
    yield param.toDouble();
  }
}

class IntToDoubleGeneratorUseCase extends UseCase<int, double> {
  @override
  Stream<double> transaction(int param) async* {
    yield* _transaction(param);
  }

  Stream<double> _transaction(int param) async* {
    yield param.toDouble();
  }
}

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
    if (param == 1) {
      throw ArgumentError('bad data!');
    }

    if (param == 2) {
      throw StateError('bad data!');
    }

    if (param == 3) {
      throw TypeError();
    }

    throw Exception();
  }
}
