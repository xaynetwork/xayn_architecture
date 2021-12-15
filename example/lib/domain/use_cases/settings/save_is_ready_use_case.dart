import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/repositories/settings_repository.dart';

@injectable
class SaveIsReadyUseCase extends UseCase<bool, None> {
  final SettingsRepository _repository;

  SaveIsReadyUseCase(this._repository);

  @override
  Stream<None> transaction(bool param) async* {
    final settings = _repository.settings;
    final updatedSettings = settings.copyWith(isReady: param);
    _repository.settings = updatedSettings;
    yield none;
  }
}
