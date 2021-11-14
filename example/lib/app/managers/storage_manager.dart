import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/use_cases/storage/hydrated_storage_init_use_case.dart';

@injectable
class StorageManager extends Cubit<StorageState>
    with UseCaseBlocHelper<StorageState> {
  final HydratedStorageInitUseCase _hydratedStorageInitUseCase;

  StorageManager(this._hydratedStorageInitUseCase)
      : super(const StorageState.notReady()) {
    _initHandlers();
  }

  Future<void> _initHandlers() async {
    await _hydratedStorageInitUseCase(null);

    emit(const StorageState.ready());
  }
}

class StorageState {
  final bool isReady;

  const StorageState.ready() : isReady = true;

  const StorageState.notReady() : isReady = false;
}
