import 'package:rxdart/rxdart.dart' show ErrorAndStackTrace;
import 'package:xayn_architecture/xayn_architecture.dart';

extension FoldExtension<State> on UseCaseBlocHelper<State> {
  _Fold1<A, T> fold<A, T>(
    Either<A> streamA,
  ) =>
      _Fold1(streamA);

  _Fold2<A, B, T> fold2<A, B, T>(
    Either<A> streamA,
    Either<B> streamB,
  ) =>
      _Fold2(streamA, streamB);

  _Fold3<A, B, C, T> fold3<A, B, C, T>(
    Either<A> streamA,
    Either<B> streamB,
    Either<C> streamC,
  ) =>
      _Fold3(streamA, streamB, streamC);

  _Fold4<A, B, C, D, T> fold4<A, B, C, D, T>(
    Either<A> streamA,
    Either<B> streamB,
    Either<C> streamC,
    Either<D> streamD,
  ) =>
      _Fold4(streamA, streamB, streamC, streamD);

  _Fold5<A, B, C, D, E, T> fold5<A, B, C, D, E, T>(
    Either<A> streamA,
    Either<B> streamB,
    Either<C> streamC,
    Either<D> streamD,
    Either<E> streamE,
  ) =>
      _Fold5(streamA, streamB, streamC, streamD, streamE);

  _Fold6<A, B, C, D, E, F, T> fold6<A, B, C, D, E, F, T>(
    Either<A> streamA,
    Either<B> streamB,
    Either<C> streamC,
    Either<D> streamD,
    Either<E> streamE,
    Either<F> streamF,
  ) =>
      _Fold6(streamA, streamB, streamC, streamD, streamE, streamF);

  _Fold7<A, B, C, D, E, F, G, T> fold7<A, B, C, D, E, F, G, T>(
    Either<A> streamA,
    Either<B> streamB,
    Either<C> streamC,
    Either<D> streamD,
    Either<E> streamE,
    Either<F> streamF,
    Either<G> streamG,
  ) =>
      _Fold7(streamA, streamB, streamC, streamD, streamE, streamF, streamG);

  _Fold8<A, B, C, D, E, F, G, H, T> fold8<A, B, C, D, E, F, G, H, T>(
    Either<A> streamA,
    Either<B> streamB,
    Either<C> streamC,
    Either<D> streamD,
    Either<E> streamE,
    Either<F> streamF,
    Either<G> streamG,
    Either<H> streamH,
  ) =>
      _Fold8(streamA, streamB, streamC, streamD, streamE, streamF, streamG,
          streamH);

  _Fold9<A, B, C, D, E, F, G, H, I, T> fold9<A, B, C, D, E, F, G, H, I, T>(
    Either<A> streamA,
    Either<B> streamB,
    Either<C> streamC,
    Either<D> streamD,
    Either<E> streamE,
    Either<F> streamF,
    Either<G> streamG,
    Either<H> streamH,
    Either<I> streamI,
  ) =>
      _Fold9(streamA, streamB, streamC, streamD, streamE, streamF, streamG,
          streamH, streamI);
}

class _Fold1<A, T> {
  final Either<A> _streamA;

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
    final errors = <Either, ErrorAndStackTrace>{};
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
  final Either<A> _streamA;
  final Either<B> _streamB;

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
    final errors = <Either, ErrorAndStackTrace>{};
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
  final Either<A> _streamA;
  final Either<B> _streamB;
  final Either<C> _streamC;

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
    final errors = <Either, ErrorAndStackTrace>{};
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

class _Fold4<A, B, C, D, T> {
  final Either<A> _streamA;
  final Either<B> _streamB;
  final Either<C> _streamC;
  final Either<D> _streamD;

  _Fold4(
    this._streamA,
    this._streamB,
    this._streamC,
    this._streamD,
  );

  T foldAll(
    T Function(
      A? a,
      B? b,
      C? c,
      D? d,
      ErrorReport errorReport,
    )
        handler,
  ) {
    final errors = <Either, ErrorAndStackTrace>{};
    A? a;
    B? b;
    C? c;
    D? d;

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

    _streamD.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamD] = ErrorAndStackTrace(e, s),
      onValue: (it) => d = it,
    );

    return handler(a, b, c, d, ErrorReport(Map.unmodifiable(errors)));
  }
}

class _Fold5<A, B, C, D, E, T> {
  final Either<A> _streamA;
  final Either<B> _streamB;
  final Either<C> _streamC;
  final Either<D> _streamD;
  final Either<E> _streamE;

  _Fold5(
    this._streamA,
    this._streamB,
    this._streamC,
    this._streamD,
    this._streamE,
  );

  T foldAll(
    T Function(
      A? a,
      B? b,
      C? c,
      D? d,
      E? e,
      ErrorReport errorReport,
    )
        handler,
  ) {
    final errors = <Either, ErrorAndStackTrace>{};
    A? a;
    B? b;
    C? c;
    D? d;
    E? e;

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

    _streamD.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamD] = ErrorAndStackTrace(e, s),
      onValue: (it) => d = it,
    );

    _streamE.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamE] = ErrorAndStackTrace(e, s),
      onValue: (it) => e = it,
    );

    return handler(a, b, c, d, e, ErrorReport(Map.unmodifiable(errors)));
  }
}

class _Fold6<A, B, C, D, E, F, T> {
  final Either<A> _streamA;
  final Either<B> _streamB;
  final Either<C> _streamC;
  final Either<D> _streamD;
  final Either<E> _streamE;
  final Either<F> _streamF;

  _Fold6(
    this._streamA,
    this._streamB,
    this._streamC,
    this._streamD,
    this._streamE,
    this._streamF,
  );

  T foldAll(
    T Function(
      A? a,
      B? b,
      C? c,
      D? d,
      E? e,
      F? f,
      ErrorReport errorReport,
    )
        handler,
  ) {
    final errors = <Either, ErrorAndStackTrace>{};
    A? a;
    B? b;
    C? c;
    D? d;
    E? e;
    F? f;

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

    _streamD.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamD] = ErrorAndStackTrace(e, s),
      onValue: (it) => d = it,
    );

    _streamE.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamE] = ErrorAndStackTrace(e, s),
      onValue: (it) => e = it,
    );

    _streamF.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamF] = ErrorAndStackTrace(e, s),
      onValue: (it) => f = it,
    );

    return handler(a, b, c, d, e, f, ErrorReport(Map.unmodifiable(errors)));
  }
}

class _Fold7<A, B, C, D, E, F, G, T> {
  final Either<A> _streamA;
  final Either<B> _streamB;
  final Either<C> _streamC;
  final Either<D> _streamD;
  final Either<E> _streamE;
  final Either<F> _streamF;
  final Either<G> _streamG;

  _Fold7(
    this._streamA,
    this._streamB,
    this._streamC,
    this._streamD,
    this._streamE,
    this._streamF,
    this._streamG,
  );

  T foldAll(
    T Function(
      A? a,
      B? b,
      C? c,
      D? d,
      E? e,
      F? f,
      G? g,
      ErrorReport errorReport,
    )
        handler,
  ) {
    final errors = <Either, ErrorAndStackTrace>{};
    A? a;
    B? b;
    C? c;
    D? d;
    E? e;
    F? f;
    G? g;

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

    _streamD.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamD] = ErrorAndStackTrace(e, s),
      onValue: (it) => d = it,
    );

    _streamE.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamE] = ErrorAndStackTrace(e, s),
      onValue: (it) => e = it,
    );

    _streamF.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamF] = ErrorAndStackTrace(e, s),
      onValue: (it) => f = it,
    );

    _streamG.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamG] = ErrorAndStackTrace(e, s),
      onValue: (it) => g = it,
    );

    return handler(a, b, c, d, e, f, g, ErrorReport(Map.unmodifiable(errors)));
  }
}

class _Fold8<A, B, C, D, E, F, G, H, T> {
  final Either<A> _streamA;
  final Either<B> _streamB;
  final Either<C> _streamC;
  final Either<D> _streamD;
  final Either<E> _streamE;
  final Either<F> _streamF;
  final Either<G> _streamG;
  final Either<H> _streamH;

  _Fold8(
    this._streamA,
    this._streamB,
    this._streamC,
    this._streamD,
    this._streamE,
    this._streamF,
    this._streamG,
    this._streamH,
  );

  T foldAll(
    T Function(
      A? a,
      B? b,
      C? c,
      D? d,
      E? e,
      F? f,
      G? g,
      H? h,
      ErrorReport errorReport,
    )
        handler,
  ) {
    final errors = <Either, ErrorAndStackTrace>{};
    A? a;
    B? b;
    C? c;
    D? d;
    E? e;
    F? f;
    G? g;
    H? h;

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

    _streamD.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamD] = ErrorAndStackTrace(e, s),
      onValue: (it) => d = it,
    );

    _streamE.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamE] = ErrorAndStackTrace(e, s),
      onValue: (it) => e = it,
    );

    _streamF.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamF] = ErrorAndStackTrace(e, s),
      onValue: (it) => f = it,
    );

    _streamG.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamG] = ErrorAndStackTrace(e, s),
      onValue: (it) => g = it,
    );

    _streamH.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamH] = ErrorAndStackTrace(e, s),
      onValue: (it) => h = it,
    );

    return handler(
        a, b, c, d, e, f, g, h, ErrorReport(Map.unmodifiable(errors)));
  }
}

class _Fold9<A, B, C, D, E, F, G, H, I, T> {
  final Either<A> _streamA;
  final Either<B> _streamB;
  final Either<C> _streamC;
  final Either<D> _streamD;
  final Either<E> _streamE;
  final Either<F> _streamF;
  final Either<G> _streamG;
  final Either<H> _streamH;
  final Either<I> _streamI;

  _Fold9(
    this._streamA,
    this._streamB,
    this._streamC,
    this._streamD,
    this._streamE,
    this._streamF,
    this._streamG,
    this._streamH,
    this._streamI,
  );

  T foldAll(
    T Function(
      A? a,
      B? b,
      C? c,
      D? d,
      E? e,
      F? f,
      G? g,
      H? h,
      I? i,
      ErrorReport errorReport,
    )
        handler,
  ) {
    final errors = <Either, ErrorAndStackTrace>{};
    A? a;
    B? b;
    C? c;
    D? d;
    E? e;
    F? f;
    G? g;
    H? h;
    I? i;

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

    _streamD.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamD] = ErrorAndStackTrace(e, s),
      onValue: (it) => d = it,
    );

    _streamE.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamE] = ErrorAndStackTrace(e, s),
      onValue: (it) => e = it,
    );

    _streamF.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamF] = ErrorAndStackTrace(e, s),
      onValue: (it) => f = it,
    );

    _streamG.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamG] = ErrorAndStackTrace(e, s),
      onValue: (it) => g = it,
    );

    _streamH.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamH] = ErrorAndStackTrace(e, s),
      onValue: (it) => h = it,
    );

    _streamI.fold(
      defaultOnError: (Object e, StackTrace? s) =>
          errors[_streamI] = ErrorAndStackTrace(e, s),
      onValue: (it) => i = it,
    );

    return handler(
        a, b, c, d, e, f, g, h, i, ErrorReport(Map.unmodifiable(errors)));
  }
}

class ErrorReport {
  final bool isEmpty, isNotEmpty;

  final Map<Either, ErrorAndStackTrace> _errors;

  ErrorReport(this._errors)
      : isEmpty = _errors.isEmpty,
        isNotEmpty = _errors.isNotEmpty;

  bool exists(Either either) => _errors.containsKey(either);

  ErrorAndStackTrace? of(Either either) => _errors[either];
}
