/// Use this value in combination with `UseCase`s which have no input,
/// i.e.
/// ```dart
/// class NoInputUseCase extends UseCase<None, int> {
///
/// }
///
/// final useCase = NoInputUseCase();
///
/// useCase(none);
/// ```
const None none = None._();

/// A class representing that no value should be passed.
/// like `void` but more explicit.
class None {
  const None._();
}
