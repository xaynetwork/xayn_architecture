import 'package:xayn_architecture_example/dependency_config.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final di = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
void configureDependencies() => $initGetIt(di);
