import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xayn_architecture/xayn_architecture.dart';

@injectable
class SearchUseCase extends UseCase<String, SearchResult> {
  SearchUseCase();

  /// mimics the fetch progress
  @override
  Stream<SearchResult> transaction(String param) async* {
    // init
    yield const SearchResult(progress: .0);

    // loading...
    const interval = Duration(seconds: 1);

    await Future.delayed(interval);
    yield const SearchResult(progress: 20.0);

    await Future.delayed(interval);
    yield const SearchResult(progress: 40.0);

    await Future.delayed(interval);
    yield const SearchResult(progress: 60.0);

    await Future.delayed(interval);
    yield const SearchResult(progress: 80.0);

    await Future.delayed(interval);
    yield const SearchResult(progress: 100.0, json: {'result': 'yay!'});
  }

  /// debounce any user input here
  @override
  Stream<String> transform(Stream<String> incoming) =>
      incoming.debounceTime(const Duration(milliseconds: 60));
}

class SearchResult {
  final double progress;
  final Map<String, dynamic>? json;

  const SearchResult({
    required this.progress,
    this.json,
  });

  @override
  bool operator ==(Object other) {
    if (other is SearchResult) {
      return other.hashCode == hashCode;
    }

    return false;
  }

  @override
  int get hashCode => '$json|$progress'.hashCode;
}
