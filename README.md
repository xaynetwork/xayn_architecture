# Xayn UseCase

## What

`UseCase`s are a common design pattern, mostly popular within the [Android world](https://yoelglus.medium.com/android-and-clean-architecture-the-use-case-interface-8716512f29a1).

They are typically lightweight, and have an `async` interface.

## Classic example

Let's create a standard `UseCase` for a common problem: updating a `User` through a repository:

```dart
class UserUpdateUseCase extends UseCase<User, User> {
  final UserRepository userRepository;

  UserUpdateUseCase(this.userRepository);

  @override
  Stream<User> transaction(User user) async* {
    yield await userRepository.update(SingleIdRepositoryKey(user.uid), user);
  }
}
```

`UserUpdateUseCase` extends `UseCase`, and the actual operation is handled within the `transaction` override.

This method is actually a `Stream` `Function`, as opposed to a normal `Future` operation, more on that later, but
the above should already look familiar.

A `UseCase` should however not be used standalone, instead, we want to invoke them solely via a `Bloc`, or a `Cubit`,
and instead offer simple `onX` handlers as an interface.

Taking this `UseCase` into account, we could create a `Bloc` as following:

```dart
class UserBloc extends Cubit<UserState> {
  final UserUpdateUseCase _userUpdateUseCase;

  UserBloc(
      this._userUpdateUseCase,
      ) : super(UserState.empty());

  Future<void> onUserUpdate(User user) async {
    final result = await _userUpdateUseCase(user);
    final updatedUser = result.data!;

    emit(state.copyWith(
      name: updatedUser.name,
      age: updatedUser.age,
    ));
  }
}
```

...this should also look very familiar, we `call` the UseCase via `onUserUpdate` and emit a new `State`
once we obtain its result.

## Advanced example

Because a Bloc's state is basically the `build` source for a `Widget`, or a `Screen` if you will, we would like to
avoid unnecessary builds obviously.

Inside a `build` handler, we would setup a `BlocBuilder` for example, and build child `Widget`s from the `state`.

However, we don't always _want_ to follow `state` updates right away. Ideally we need to keep the amount of `Widget` `build` calls
limited, so let's observe another type of `UseCase`:

```dart
class ScrollUpdateUseCase extends UseCase<int, int> {
  ScrollUpdateUseCase();

  @override
  Stream<int> transaction(int position) async* {
    // do something with that position, maybe store it in memory for example
    // finally, we yield it again:
    yield position;
  }
}
```

This particular `UseCase` can be invoked in rapid sequence, basically every time the user effectively scrolls.
So, this makes the `Bloc` a bit problematic. As in the above example, we would have a different `Bloc` handler, called
`onScrollUpdate`, imagine we have the same code body, i.e. invoking the `ScrollUpdateUseCase` on each call, and thus
emitting a new `state` 1-to-1 accordingly.

Our `BlocBuilder` from before would trigger way too often and cause unnecessary behavior. Of course `Bloc`s are just `Stream`s
when being consumed, so we could for example use a simple `debounce` here, but again this is not very ideal.

A `debounce` causes a redraw delay, and we only really need it to happen whenever the scroll position updates, _not_ when the `User` was updated.

To accommodate, it would be nice to consume the `ScrollUpdateUseCase` in a different way, i.e. we apply back pressure on its input and we
are only really interested in its _latest_ value.

To then consume this particular `UseCase` in a better way, we simply need to add the following to the above `Bloc`:

```dart
class UserBloc extends Cubit<UserState> with UseCaseBlocHelper
```

This _helper_ exposes new methods, which allow us to consume the `UseCase` in a way that only the _latest_ value will be added to the `state`:

```dart
void onScrollUpdate(int position) {
  // specify that we only care for the latest value
  emitWithLatest(
    using: _scrollUpdateUseCase,
    runWith: position,
    then: (int it, state) => state.copyWith(
      position: it,
    ),
  );
}
```