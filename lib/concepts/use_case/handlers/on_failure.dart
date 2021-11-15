import 'package:flutter/foundation.dart';

/// Signature for error and stack trace handling.
typedef HandleOnFailure<Failure> = void Function(Object e, StackTrace? s);

/// A helper class, which is used internally, and allows for
/// matching towards specific error Types.
@protected
class HandleFailure {
  /// The default error handler.
  final HandleOnFailure onDefault;

  /// A `Set` of type-specific error handlers.
  Set<On>? matchers;

  /// Constructs a new error helper instance.
  HandleFailure(
    this.onDefault, {
    this.matchers,
  });

  /// Will handle the error and stack trace by finding the appropriate
  /// handler, which is either [onDefault], or a handler found in [matchers].
  void call(Object e, StackTrace? s) {
    final handlers = matchers ?? const {};
    final defaultHandler =
        On<dynamic>((Object e, StackTrace? s) => onDefault(e, s));
    final handler =
        handlers.firstWhere((it) => it._test(e), orElse: () => defaultHandler);

    handler._handle(e, s);
  }
}

/// Wraps an error handler with a specific error `Type`.
class On<Failure> {
  final HandleOnFailure<Failure> _handle;

  /// Constructs a new error and `Type` wrapper instance.
  const On(this._handle);

  bool _test(dynamic e) => e is Failure;
}
