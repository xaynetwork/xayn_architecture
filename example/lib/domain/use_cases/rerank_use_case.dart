import 'package:xayn_architecture/concepts/use_case.dart';

class RerankUseCase extends UseCase<RerankResult, RerankResult> {
  @override
  Stream<RerankResult> transaction(param) async* {
    // demo for a use case which emits n-events during one transaction:

    // Starting...
    yield RerankResult(
      indices: const [],
      progress: .0,
    );

    // Wait a bit, then emit some progress...
    yield await Future.delayed(const Duration(seconds: 1))
        .then((_) => RerankResult(
              indices: const [],
              progress: 50.0,
            ));

    // Wait a bit, then Done!!!
    yield await Future.delayed(const Duration(seconds: 1))
        .then((_) => RerankResult(
              indices: const [5, 2, 3, 1, 0, 4],
              progress: 100.0,
            ));
  }
}

class RerankResult {
  final double progress;
  final List<int> indices;

  RerankResult({
    required this.progress,
    required this.indices,
  });
}
