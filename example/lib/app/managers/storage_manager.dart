import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/concepts/on_failure.dart';
import 'package:xayn_architecture/concepts/use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/logger_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/storage/storage_prepper_use_case.dart';

@injectable
class StorageManager extends Cubit<StorageState>
    with UseCaseBlocHelper<StorageState> {
  final StoragePrepperUseCase _storagePrepperUseCase;

  StorageManager(this._storagePrepperUseCase)
      : super(const StorageState.notReady());

  @override
  void initHandlers() {
    consume(
      _storagePrepperUseCase,
      initialData: null,
    )
        .transform(
          (out) => out.followedBy(
            LoggerUseCase((it) => 'storage is ready'),
          ),
        )
        .fold(
          onSuccess: (it) => const StorageState
              .ready(), // todo: instead of null, a loading state
          onFailure: HandleFailure((e, s) => const StorageState.notReady()),
        );
  }
}

class StorageState {
  final bool isReady;

  const StorageState.ready() : isReady = true;

  const StorageState.notReady() : isReady = false;
}
