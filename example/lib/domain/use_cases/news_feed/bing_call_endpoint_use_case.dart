import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture_example/domain/env/env.dart';

import 'news_feed.dart';

@Injectable(as: CallEndpointUseCase)
class BingCallEndpointUseCase<T> extends CallEndpointUseCase {
  BingCallEndpointUseCase();

  @override
  Stream<RawApiResponse> transaction(Uri param) async* {
    yield const RawApiResponse.incomplete();

    final response = await http.get(param,
        headers: const {'Authorization': 'Bearer ${Env.searchApiSecretKey}'});

    yield RawApiResponse.complete(await compute(_decodeJson, response.body));
  }
}

Map<String, dynamic> _decodeJson(String raw) =>
    const JsonDecoder().convert(raw);
