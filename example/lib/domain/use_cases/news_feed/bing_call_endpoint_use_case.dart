import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture_example/domain/entities/result.dart';
import 'package:xayn_architecture_example/domain/env/env.dart';

import 'news_feed.dart';

@Injectable(as: CallEndpointUseCase)
class BingCallEndpointUseCase<T> extends CallEndpointUseCase {
  BingCallEndpointUseCase();

  @override
  Stream<ResultsContainer> transaction(Uri param) async* {
    yield const ResultsContainer.incomplete();

    final response = await http.get(param,
        headers: const {'Authorization': 'Bearer ${Env.searchApiSecretKey}'});

    if (response.statusCode != 200) {
      throw CallEndpointError(
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    final data = await compute(_decodeJson, response.body);

    yield ResultsContainer.complete(_deserialize(data));
  }

  List<Result> _deserialize(Map<String, dynamic> data) {
    final news = (data['news'] ?? {'value': const []})['value'] as List;

    return news.cast<Map>().map((it) {
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
    }).toList(growable: false);
  }
}

Map<String, dynamic> _decodeJson(String raw) =>
    const JsonDecoder().convert(raw);

class CallEndpointError extends Error {
  final int statusCode;
  final String body;

  CallEndpointError({
    required this.statusCode,
    required this.body,
  });
}

class ResultsContainer {
  final List<Result> results;
  final bool isComplete;

  const ResultsContainer.incomplete()
      : results = const [],
        isComplete = false;

  const ResultsContainer.complete(this.results) : isComplete = true;
}
