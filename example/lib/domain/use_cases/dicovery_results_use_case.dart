import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/entities/result.dart';
import 'package:xayn_architecture_example/infrastructure/discovery_api.dart';

@injectable
class DiscoveryResultsUseCase extends UseCase<int, List<Result>> {
  final DiscoveryApi _discoveryApi;

  DiscoveryResultsUseCase(this._discoveryApi);

  @override
  Stream<List<Result>> transaction(int param) async* {
    yield* _discoveryApi.results;

    _discoveryApi.requestNextResults(param);
  }
}
