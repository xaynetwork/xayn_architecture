import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/infrastructure/discovery_api.dart';

@injectable
class DiscoveryResultsUseCase extends UseCase<int, DiscoveryApiState> {
  final DiscoveryApi _discoveryApi;

  DiscoveryResultsUseCase(this._discoveryApi);

  @override
  Stream<DiscoveryApiState> transaction(int param) async* {
    _discoveryApi.handleQuery('');

    yield* _discoveryApi.stream;
  }
}
