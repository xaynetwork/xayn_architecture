import 'package:xayn_architecture/concepts/use_case.dart';
import 'package:xayn_architecture_example/domain/use_cases/search_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SearchUseCase searchUseCase;

  setUp(() async {
    searchUseCase = SearchUseCase();
  });

  group('Call use case emits all intermittent events: ', () {
    test(
      'Call as a future: ',
      () {
        expect(
            searchUseCase('xayn'),
            completion(const [
              UseCaseResult.success(SearchResult(progress: .0)),
              UseCaseResult.success(SearchResult(progress: 20.0)),
              UseCaseResult.success(SearchResult(progress: 40.0)),
              UseCaseResult.success(SearchResult(progress: 60.0)),
              UseCaseResult.success(SearchResult(progress: 80.0)),
              UseCaseResult.success(SearchResult(
                progress: 100.0,
                json: {'result': 'yay!'},
              )),
            ]));
      },
    );
  });
}
