abstract class UserRepository<Key, User> {
  Future<User?> single(Key key);

  Future<User> create(User entity);

  Future<User> update(Key key, User entity);

  Future<void> delete(Key key);
}
