typedef OnFailureDefault = void Function(Object e, StackTrace? s);
typedef HandleOnFailure<Failure> = void Function(Object e, StackTrace? s);

class HandleFailure {
  final OnFailureDefault onDefault;
  Set<On>? matchers;

  HandleFailure(
    this.onDefault, {
    this.matchers,
  });

  void call(Object e, StackTrace? s) {
    final handlers = matchers ?? const {};
    final defaultHandler =
        On<dynamic>((Object e, StackTrace? s) => onDefault(e, s));
    final handler =
        handlers.firstWhere((it) => it._test(e), orElse: () => defaultHandler);

    handler._handle(e, s);
  }
}

class On<Failure> {
  final HandleOnFailure<Failure> _handle;

  const On(this._handle);

  bool _test(dynamic e) => e is Failure;
}
