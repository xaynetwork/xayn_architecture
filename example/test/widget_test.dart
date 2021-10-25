import 'package:bloc_test/bloc_test.dart';
import 'package:xayn_architecture_example/app/managers/news_feed_manager.dart';
import 'package:xayn_architecture_example/data/repositories/data_user_repository.mocks.dart';
import 'package:xayn_architecture_example/domain/entities/user.dart';
import 'package:xayn_architecture_example/domain/states/screen_state.dart';
import 'package:xayn_architecture_example/domain/use_cases/dicovery_results_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/result_combiner_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/scroll_update_use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/user_update_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:xayn_architecture_example/infrastructure/discovery_api.dart';

void main() {
  late UserUpdateUseCase userUpdateUseCase;
  late ScrollUpdateUseCase scrollUpdateUseCase;
  late DiscoveryResultsUseCase discoveryResultsUseCase;
  late ResultCombinerUseCase resultCombinerUseCase;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    HydratedBloc.storage = MockHydratedStorage();

    final userRepository = MockDataUserRepository();

    userUpdateUseCase = UserUpdateUseCase(userRepository);
    scrollUpdateUseCase = ScrollUpdateUseCase();
    discoveryResultsUseCase = DiscoveryResultsUseCase(DiscoveryApi());
    resultCombinerUseCase = ResultCombinerUseCase();

    when(userRepository.update(any, any)).thenAnswer((invocation) {
      final user = invocation.positionalArguments.last as User;

      return Future.value(user);
    });

    userUpdateUseCase;
  });

  group('Back Pressure tests: ', () {
    blocTest(
      'Can update Scroll Position: ',
      wait: kScrollUpdateUseCaseDebounceTime * 3,
      build: () => NewsFeedManager(
        discoveryResultsUseCase,
        resultCombinerUseCase,
        scrollUpdateUseCase,
      ),
      act: (NewsFeedManager bloc) => List.generate(1000, bloc.onScrollUpdate),
      expect: () => [
        ScreenState.empty().copyWith(position: 999),
      ],
    );
  });
}

class MockHydratedStorage implements Storage {
  @override
  dynamic read(String key) {}

  @override
  Future<void> write(String key, dynamic value) async {}

  @override
  Future<void> delete(String key) async {}

  @override
  Future<void> clear() async {}
}
