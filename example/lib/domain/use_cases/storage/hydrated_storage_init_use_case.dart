import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xayn_architecture/xayn_architecture.dart';

@injectable
class HydratedStorageInitUseCase extends UseCase<void, bool> {
  HydratedStorageInitUseCase();

  @override
  Stream<bool> transaction(void param) async* {
    final path = await getTemporaryDirectory();

    HydratedBloc.storage = await HydratedStorage.build(storageDirectory: path);

    yield true;
  }
}
