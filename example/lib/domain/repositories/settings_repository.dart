import 'package:xayn_architecture_example/domain/entities/settings.dart';

abstract class SettingsRepository {
  Settings get settings;
  set settings(Settings appSettings);
}
