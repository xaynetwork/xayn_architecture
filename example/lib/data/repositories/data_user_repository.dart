import 'package:xayn_architecture_example/domain/entities/user.dart';
import 'package:xayn_architecture_example/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/annotations.dart';
import 'package:uuid/uuid.dart';

/// As a demo, we use [Environment] here.
/// You can actually make custom environments too.
/// For example, a specific client.
@GenerateMocks([DataUserRepository])
@Injectable(as: UserRepository)
class DataUserRepository implements UserRepository<String, User> {
  final Map<String, User> _fakeDatabase = <String, User>{};
  int _nextKey = 1;

  @override
  Future<User> create(User entity) async {
    final hash = 'u-${++_nextKey}';
    final key = const Uuid().v4();

    return _fakeDatabase[key] = entity.copyWith(uid: hash);
  }

  @override
  Future<void> delete(String key) async {
    _fakeDatabase.remove(key);
  }

  @override
  Future<User?> single(String key) async => _fakeDatabase[key];

  @override
  Future<User> update(String key, User entity) async =>
      _fakeDatabase[key] = entity;
}
