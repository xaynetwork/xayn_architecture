import 'package:injectable/injectable.dart';
import 'package:xayn_architecture_example/domain/entities/result.dart';

import 'news_feed.dart';

@Injectable(as: DeserializeResultUseCase)
class BingDeserializeResponseUseCase<T> extends DeserializeResultUseCase {
  BingDeserializeResponseUseCase();

  @override
  Stream<ResultsContainer> transaction(RawApiResponse param) async* {
    if (param.isComplete) {
      final news = (param.data['news'] ?? {'value': const []})['value'] as List;

      yield ResultsContainer.complete(news.cast<Map>().map((it) {
        String? imageUrl;

        if (it.containsKey('image')) {
          final image = it['image'] as Map;

          if (image.containsKey('contentUrl')) {
            imageUrl = image['contentUrl'];
          }
        }

        return Result(
          Uri.parse(it['url'] ?? ''),
          imageUrl != null ? Uri.parse(imageUrl) : null,
          it['description'] ?? '',
        );
      }).toList(growable: false));
    } else {
      yield const ResultsContainer.incomplete();
    }
  }
}

class ResultsContainer {
  final List<Result> results;
  final bool isComplete;

  const ResultsContainer.incomplete()
      : results = const [],
        isComplete = false;

  const ResultsContainer.complete(this.results) : isComplete = true;
}
