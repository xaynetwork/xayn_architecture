import 'package:xayn_architecture/xayn_architecture.dart';

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

class NoOutputUseCase extends UseCase<int, String> {
  @override
  Stream<String> transaction(int param) async* {}
}

class MultiOutputUseCase extends UseCase<int, String> {
  @override
  Stream<String> transaction(int param) async* {
    yield param.toString();
    yield param.toString();
    yield param.toString();
  }
}

class MixOutputAndErrorsUseCase extends UseCase<int, String> {
  @override
  Stream<String> transaction(int param) async* {
    yield param.toString();
    yield param.toString();
    yield param.toString();
    throw ArgumentError('bad data!');
  }
}

class NoInputUseCase extends UseCase<None, String> {
  @override
  Stream<String> transaction(None param) async* {
    yield 'ok!';
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
