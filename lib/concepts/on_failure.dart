typedef OnFailureDefault<T> = T Function(dynamic e, StackTrace s);
typedef HandleOnFailure<Failure, T> = T Function(dynamic e, StackTrace s);

class HandleFailure<T> {
  final OnFailureDefault<T> onDefault;
  Set<On>? matchers;

  HandleFailure(
    this.onDefault, {
    this.matchers,
  });

  T call(dynamic e, StackTrace s) {
    final handlers = matchers ?? const {};
    final defaultHandler = On((e, s) => onDefault(e, s));
    final handler =
        handlers.firstWhere((it) => it._test(e), orElse: () => defaultHandler);

    return handler._handle(e, s);
  }
}

class On<Failure> {
  final HandleOnFailure<Failure, dynamic> _handle;

  const On(this._handle);

  bool _test(dynamic e) => e is Failure;
}
