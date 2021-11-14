import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/transformers.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xayn_architecture/concepts/use_case/transformers/emit_on_transformer.dart';
import 'package:xayn_architecture/concepts/use_case/transformers/use_case_transformer.dart';

/// {@template use_case}
/// ```dart
/// class MyUseCase extends UseCase<In, Out> {
///   MyUseCase();
///
///   @override
///   Stream<Out> transaction(In data) async* {
///     yield data;
///   }
/// }
/// ```
/// {@endtemplate}
abstract class UseCase<In, Out> {
  /// the transaction, which should be implemented in a sub-class.
  @protected
  Stream<Out> transaction(In param);

  /// Returns the [call] as a [Future] instead.
  ///
  /// Every individual output event is wrapped in either a [UseCaseResult]
  /// for any successful outputs, and [UseCaseException] when an exception
  /// occurred.
  ///
  /// The order of outputs is guaranteed to be in the same order as they
  /// were emitted by the `useCase`.
  @nonVirtual
  Future<List<UseCaseResult<Out>>> call(In param) => transaction(param)
      .map((result) => UseCaseResult.success(result))
      .onErrorReturnWith((e, s) => UseCaseResult<Out>.failure(
          UseCaseException(error: e, stackTrace: StackTrace.current)))
      .toList();

  /// If you want to apply any transformations on incoming params in [transaction],
  /// then override this method.
  ///
  /// Example for debouncing:
  /// ```dart
  /// @override
  ///   Stream<Out> transform(Stream<Out> incoming) =>
  ///       incoming.debounceTime(const Duration(milliseconds: 60));
  /// ```
  ///
  /// Note that [transform] only is used when consuming the `useCase` as a `Stream`.
  ///
  /// When calling it as a `Future` (see: [call]), then input is always directly
  /// passing the `useCase` via [transaction].
  Stream<In> transform(Stream<In> incoming) => incoming;
}

/// The return value for a [UseCase], either [data] or [exception] will be filled.
class UseCaseResult<Out> {
  /// If successful, then data will be filled
  final Out? data;

  /// If unsuccessful, then exception will be filled
  final UseCaseException? exception;

  /// returns true when the call succeeded.
  bool get hasData => data != null;

  /// returns true when the call threw an error.
  bool get hasError => exception != null;

  const UseCaseResult.success(this.data)
      : exception = null,
        assert(data != null);

  const UseCaseResult.failure(this.exception)
      : data = null,
        assert(exception != null);
}

/// A wrapper for exceptions that may be thrown during the call phase of a [UseCase].
class UseCaseException {
  /// A reference to the wrapped error.
  final Object error;

  /// A reference to the wrapped stack trace.
  final StackTrace stackTrace;

  /// The wrapper's constructor.
  const UseCaseException({required this.error, required this.stackTrace});

  @override
  String toString() => 'UseCaseException: ${Error.safeToString(error)}';
}

/// An extension on `Stream` which allows easily chaining multiple
/// `useCase`s in sequence.
///
/// ```dart
/// pipe(initialUseCase)
///   .transform(
///     (out) => out
///       .followedBy(myFirstUseCase)
///       .followedBy(mySecondUseCase)
///       .followedBy(myThirdUseCase),
///   )
///   .fold(
///     onSuccess: (results, state) => state.copyWith(results: results),
///     onFailure: (e, s, state) => const ScreenState.errorFetchingResults(),
///   );
/// ```
extension UseCaseExtension<In> on Stream<In> {
  Stream<Out> followedBy<Out>(UseCase<In, Out> useCase) => useCase
      .transform(this)
      .transform(UseCaseStreamTransformer<In, Out>(useCase.transaction));

  Stream<In> scheduleComputeState({
    required Test<In> consumeEvent,
    required Runner<In> run,
  }) =>
      transform(EmitOnTransformer<In>(
        consumeEvent: consumeEvent,
        run: run,
      ));
}
