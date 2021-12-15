import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/use_cases/settings/get_is_ready_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/settings/save_is_ready_use_case.dart';

@injectable
class StorageManager extends Cubit<StorageState>
    with UseCaseBlocHelper<StorageState> {
  final GetIsReadyUseCase _getIsReadyUseCase;
  final SaveIsReadyUseCase _saveIsReadyUseCase;

  StorageManager(
    this._getIsReadyUseCase,
    this._saveIsReadyUseCase,
  ) : super(const StorageState.notReady()) {
    _initHandlers();
  }

  Future<void> _initHandlers() async {
    await _saveIsReadyUseCase.call(true);
    final isReady = await _getIsReadyUseCase.singleOutput(none);
    emit(StorageState(isReady));
  }
}

class StorageState {
  final bool isReady;

  StorageState(this.isReady);

  const StorageState.notReady() : isReady = false;
}
