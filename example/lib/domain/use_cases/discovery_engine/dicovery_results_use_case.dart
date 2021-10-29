import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/infrastructure/discovery_api.dart';

// ignore: implementation_imports
import 'package:xayn_discovery_engine/src/api/events/search_events.dart';
// ignore: implementation_imports
import 'package:xayn_discovery_engine/src/api/models/search_type.dart';

@injectable
class DiscoveryResultsUseCase extends UseCase<int, DiscoveryApiState> {
  final DiscoveryApi _discoveryApi;

  DiscoveryResultsUseCase(this._discoveryApi);

  @override
  Stream<DiscoveryApiState> transaction(int param) async* {
    _discoveryApi.onClientEvent
        .add(const SearchRequested('', [SearchType.web]));

    yield* _discoveryApi.stream;
  }
}
