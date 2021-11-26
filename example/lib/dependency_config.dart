import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture_example/dependency_config.config.dart';
import 'package:xayn_architecture_example/navigation/app_navigator.dart';
import 'package:xayn_architecture_example/navigation/pages.dart';

final di = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
void configureDependencies() {
  $initGetIt(di);
  di.registerFactory<PageDialogExitActions>(() {
    AppNavigatorManger appNavigatorManger = di.get();
    return appNavigatorManger.pageDialogExitActions;
  });

  di.registerFactory<PageIncrementExitActions>(() {
    AppNavigatorManger appNavigatorManger = di.get();
    return appNavigatorManger.pageIncrementExitActions;
  });
}
