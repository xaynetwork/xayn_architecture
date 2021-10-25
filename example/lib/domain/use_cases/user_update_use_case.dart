import 'package:xayn_architecture_example/domain/entities/user.dart';
import 'package:xayn_architecture_example/domain/repositories/user_repository.dart';
import 'package:xayn_architecture/concepts/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserUpdateUseCase extends UseCase<User, User> {
  final UserRepository<String, User> userRepository;

  UserUpdateUseCase(this.userRepository);

  @override
  Stream<User> transaction(User param) async* {
    yield await userRepository.update(param.uid, param);
  }
}
