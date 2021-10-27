import 'package:xayn_architecture_example/data/repositories/data_user_repository.mocks.dart';
import 'package:xayn_architecture_example/domain/entities/user.dart';
import 'package:xayn_architecture_example/domain/use_cases/user_update_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mockito/mockito.dart';

void main() {
  late UserUpdateUseCase userUpdateUseCase;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    HydratedBloc.storage = MockHydratedStorage();

    final userRepository = MockDataUserRepository();

    userUpdateUseCase = UserUpdateUseCase(userRepository);

    when(userRepository.update(any, any)).thenAnswer((invocation) {
      final user = invocation.positionalArguments.last as User;

      return Future.value(user);
    });

    userUpdateUseCase;
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
