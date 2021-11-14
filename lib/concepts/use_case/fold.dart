import 'package:rxdart/rxdart.dart';
import 'package:xayn_architecture/concepts/use_case.dart';

extension FoldExtension<State> on UseCaseBlocHelper<State> {
  _Fold1<A, T> fold<A, T>(
    UseCaseValueStream<A> streamA,
  ) =>
      _Fold1(streamA);

  _Fold2<A, B, T> fold2<A, B, T>(
    UseCaseValueStream<A> streamA,
    UseCaseValueStream<B> streamB,
  ) =>
      _Fold2(streamA, streamB);

  _Fold3<A, B, C, T> fold3<A, B, C, T>(
    UseCaseValueStream<A> streamA,
    UseCaseValueStream<B> streamB,
    UseCaseValueStream<C> streamC,
  ) =>
      _Fold3(streamA, streamB, streamC);
}

class _Fold1<A, T> {
  final UseCaseValueStream<A> _streamA;

  _Fold1(
    this._streamA,
  );

  T foldAll(
    T Function(
      A? a,
      ErrorReport errorReport,
    )
        handler,
  ) {
    final errors = <UseCaseValueStream, ErrorAndStackTrace>{};
    A? a;

    _streamA.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamA] = ErrorAndStackTrace(e, s),
      onValue: (it) => a = it,
    );

    return handler(a, ErrorReport(Map.unmodifiable(errors)));
  }
}

class _Fold2<A, B, T> {
  final UseCaseValueStream<A> _streamA;
  final UseCaseValueStream<B> _streamB;

  _Fold2(
    this._streamA,
    this._streamB,
  );

  T foldAll(
    T Function(
      A? a,
      B? b,
      ErrorReport errorReport,
    )
        handler,
  ) {
    final errors = <UseCaseValueStream, ErrorAndStackTrace>{};
    A? a;
    B? b;

    _streamA.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamA] = ErrorAndStackTrace(e, s),
      onValue: (it) => a = it,
    );

    _streamB.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamB] = ErrorAndStackTrace(e, s),
      onValue: (it) => b = it,
    );

    return handler(a, b, ErrorReport(Map.unmodifiable(errors)));
  }
}

class _Fold3<A, B, C, T> {
  final UseCaseValueStream<A> _streamA;
  final UseCaseValueStream<B> _streamB;
  final UseCaseValueStream<C> _streamC;

  _Fold3(
    this._streamA,
    this._streamB,
    this._streamC,
  );

  T foldAll(
    T Function(
      A? a,
      B? b,
      C? c,
      ErrorReport errorReport,
    )
        handler,
  ) {
    final errors = <UseCaseValueStream, ErrorAndStackTrace>{};
    A? a;
    B? b;
    C? c;

    _streamA.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamA] = ErrorAndStackTrace(e, s),
      onValue: (it) => a = it,
    );

    _streamB.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamB] = ErrorAndStackTrace(e, s),
      onValue: (it) => b = it,
    );

    _streamC.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamC] = ErrorAndStackTrace(e, s),
      onValue: (it) => c = it,
    );

    return handler(a, b, c, ErrorReport(Map.unmodifiable(errors)));
  }
}

class ErrorReport {
  final bool isEmpty, isNotEmpty;

  final Map<UseCaseValueStream, ErrorAndStackTrace> _errors;

  ErrorReport(this._errors)
      : isEmpty = _errors.isEmpty,
        isNotEmpty = _errors.isNotEmpty;

  bool exists(UseCaseValueStream useCaseValueStream) =>
      _errors.containsKey(useCaseValueStream);

  ErrorAndStackTrace? of(UseCaseValueStream useCaseValueStream) =>
      _errors[useCaseValueStream];
}
