import 'dart:async';

import 'package:meta/meta.dart';
import 'package:test/test.dart' as test;
import 'package:xayn_architecture/xayn_architecture.dart';

/// Creates a new `useCase`-specific test case with the given [description].
/// [useCaseTest] will handle asserting that the `useCase` emits the [expect]ed
/// outputs (in order) from the presented [input].
///
/// [setUp] is optional and should be used to set up
/// any dependencies prior to initializing the `useCase` under test.
/// [setUp] should be used to set up state necessary for a particular test case.
/// For common set up code, prefer to use `setUp` from `package:test/test.dart`.
///
/// [build] should construct and return the `useCase` under test.
///
/// [input] is a `List` of input parameters which will be invoked
/// in sequence on the `useCase`.
///
/// [expect] is an optional `List` of `Matcher`s which the `useCase`
/// under test is expected to match after running all [input] entries.
///
/// [verify] is an optional callback which is invoked after [expect]
/// and can be used for additional verification/assertions.
/// [verify] is called with the `useCase` returned by [build].
///
/// [tearDown] is optional and can be used to
/// execute any code after the test has run.
/// [tearDown] should be used to clean up after a particular test case.
/// For common tear down code, prefer to use `tearDown` from `package:test/test.dart`.
///
/// For example, assume the following use case:
///
/// ```dart
/// class MultiOutputWithFailureUseCase extends UseCase<int, String> {
///   @override
///   Stream<String> transaction(int param) async* {
///     yield param.toString();
///     yield param.toString();
///     yield param.toString();
///     throw ArgumentError('bad data!');
///   }
/// }
/// ```
///
/// ...which can then be tested with [useCaseTest] as follows:
///
/// ```dart
/// // emits the input 3 times, but as a String, and then throws an ArgumentException
/// useCaseTest(
///   'Can mix results and errors',
///   build: () => MultiOutputWithFailureUseCase(),
///   input: [1],
///   expect: [
///     useCaseSuccess('1'),
///     useCaseSuccess('1'),
///     useCaseSuccess('1'),
///     useCaseFailure(throwsArgumentError),
///   ],
/// );
/// ```
@isTest
void useCaseTest<U extends UseCase<In, Out>, In, Out>(
  String description, {
  FutureOr<void> Function()? setUp,
  required U Function() build,
  required Iterable<In> input,
  void Function()? act,
  List<test.Matcher>? expect,
  Function(U useCase)? verify,
  FutureOr<void> Function()? tearDown,
  int? take,
}) {
  test.test(description, () async {
    await setUp?.call();

    final useCase = build();
    final output = <UseCaseResult<Out>>[];
    final Completer completer = Completer();
    final count = take ?? expect?.length;

    // ignore: INVALID_USE_OF_PROTECTED_MEMBER
    var stream = Stream.fromIterable(input).asyncExpand(useCase.transaction);

    if (count != null) {
      stream = stream.take(count);
    }

    stream.listen(
      (it) => output.add(UseCaseResult<Out>.success(it)),
      onError: (e, s) => output.add(UseCaseResult<Out>.failure(e, s)),
      onDone: completer.complete,
      cancelOnError: false,
    );

    await Future.delayed(const Duration(milliseconds: 10));

    act?.call();

    await completer.future;

    if (expect != null) {
      test.expect(output, expect);
    }

    await verify?.call(useCase);
    await tearDown?.call();
  });
}

/// A matcher for [useCaseTest].
///
/// It matches successful output.
test.Matcher useCaseSuccess<Out>(Out out) => _UseCaseSuccess<Out>(out);

/// A matcher for [useCaseTest] exceptions.
///
/// See [test.throwsA] for examples.
test.Matcher useCaseFailure(test.Matcher exceptionMatcher) =>
    _UseCaseFailure(exceptionMatcher);

class _UseCaseSuccess<Out> extends test.Matcher {
  final Out _expected;

  const _UseCaseSuccess(this._expected);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is UseCaseResult) {
      Out? expected;

      item.fold(
        defaultOnError: (e, s) => expected = null,
        onValue: (it) => expected = it,
      );

      return _expected == expected;
    }

    return false;
  }

  @override
  test.Description describe(test.Description description) =>
      description.add('matches ').addDescriptionOf(_expected);
}

class _UseCaseFailure extends test.Matcher {
  final test.Matcher _exception;

  const _UseCaseFailure(this._exception);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is UseCaseResult) {
      Object? exception;

      item.fold(defaultOnError: (e, s) => exception = e, onValue: (_) {});

      if (exception != null) {
        return _exception.matches(() => throw exception!, <dynamic, dynamic>{});
      }
    }

    return false;
  }

  @override
  test.Description describe(test.Description description) =>
      description.add('throws exception ').addDescriptionOf(_exception);
}
