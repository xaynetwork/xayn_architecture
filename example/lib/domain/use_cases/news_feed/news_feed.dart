import 'package:xayn_architecture/concepts/use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/news_feed/bind_deserialize_response_use_case.dart';

typedef RequestBuilderUseCase = UseCase<String, Uri>;
typedef CallEndpointUseCase = UseCase<Uri, RawApiResponse>;
typedef DeserializeResultUseCase = UseCase<RawApiResponse, ResultsContainer>;

class RawApiResponse {
  final Map<String, dynamic> data;
  final bool isComplete;

  const RawApiResponse.incomplete()
      : data = const {},
        isComplete = false;

  RawApiResponse.complete(this.data) : isComplete = true;
}
