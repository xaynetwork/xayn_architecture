import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xayn_architecture_example/domain/entities/result.dart';

@singleton
class DiscoveryApi {
  final Subject<List<Result>> _onResults = BehaviorSubject<List<Result>>();
  static int _globalCount = 0;

  Stream<List<Result>> get results => _onResults;

  void onQuery(DiscoveryQueryEvent event) {
    requestNextResults(3);
  }

  void requestNextResults(int count) {
    if (count < 0 || count > 5) {
      throw RangeError('The request count must be in the range [1, 5]');
    } else {
      _onResults.add(List.generate(count, (i) {
        final globalUrlIndex = _globalCount++;

        return Result(Uri.parse('https://www.xayn.com/$globalUrlIndex'),
            'url number $globalUrlIndex');
      }));
    }
  }
}

class DiscoveryQueryEvent {
  final String query;

  const DiscoveryQueryEvent({required this.query});
}
