import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/repositories/settings_repository.dart';

@injectable
class GetIsReadyUseCase extends UseCase<None, bool> {
  final SettingsRepository _repository;

  GetIsReadyUseCase(this._repository);

  @override
  Stream<bool> transaction(None param) async* {
    yield _repository.settings.isReady;
  }
}
