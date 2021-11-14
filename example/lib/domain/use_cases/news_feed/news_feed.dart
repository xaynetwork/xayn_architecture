import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_architecture_example/domain/use_cases/news_feed/bing_call_endpoint_use_case.dart';

typedef RequestBuilderUseCase = UseCase<String, Uri>;
typedef CallEndpointUseCase = UseCase<Uri, ResultsContainer>;
