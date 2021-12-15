import 'package:injectable/injectable.dart';
import 'package:xayn_architecture_example/domain/entities/settings.dart';
import 'package:xayn_architecture_example/domain/repositories/settings_repository.dart';

@Singleton(as: SettingsRepository)
class InMemorySettingsRepository implements SettingsRepository {
  Settings? _settings;

  @override
  Settings get settings => _settings ??= const Settings(isReady: false);

  @override
  set settings(Settings settings) => _settings = settings;
}
