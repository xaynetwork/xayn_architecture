import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xayn_architecture_example/domain/env/env.dart';

import 'news_feed.dart';

@visibleForTesting
const Duration kScrollUpdateUseCaseDebounceTime = Duration(milliseconds: 600);

@Injectable(as: RequestBuilderUseCase)
class BingRequestBuilderUseCase<T> extends RequestBuilderUseCase {
  BingRequestBuilderUseCase();

  @override
  Stream<Uri> transaction(String param) async* {
    yield Uri.https(Env.searchApiBaseUrl, '_d/search', {
      'q': param.trim(),
      'count': '5',
      'mkt': 'en-US',
      'responseFilter': 'News',
    });
  }

  @override
  Stream<String> transform(Stream<String> incoming) =>
      incoming.debounceTime(kScrollUpdateUseCaseDebounceTime);
}
