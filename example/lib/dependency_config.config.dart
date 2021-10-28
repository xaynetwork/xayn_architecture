// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:xayn_architecture/concepts/use_case.dart' as _i7;

import 'app/managers/news_feed_manager.dart' as _i16;
import 'data/repositories/data_user_repository.dart' as _i12;
import 'domain/entities/result.dart' as _i4;
import 'domain/entities/user.dart' as _i11;
import 'domain/repositories/user_repository.dart' as _i10;
import 'domain/use_cases/dicovery_results_use_case.dart' as _i15;
import 'domain/use_cases/news_feed/bing_call_endpoint_use_case.dart' as _i8;
import 'domain/use_cases/news_feed/bing_request_builder_use_case.dart' as _i9;
import 'domain/use_cases/result_combiner_use_case.dart' as _i3;
import 'domain/use_cases/scroll_update_use_case.dart' as _i5;
import 'domain/use_cases/search_use_case.dart' as _i6;
import 'domain/use_cases/user_update_use_case.dart' as _i13;
import 'infrastructure/discovery_api.dart'
    as _i14; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.ResultCombinerUseCase>(
      () => _i3.ResultCombinerUseCase(get<List<_i4.Result>>()));
  gh.factory<_i5.ScrollUpdateUseCase>(() => _i5.ScrollUpdateUseCase());
  gh.factory<_i6.SearchUseCase>(() => _i6.SearchUseCase());
  gh.factory<_i7.UseCase<Uri, _i8.ResultsContainer>>(
      () => _i8.BingCallEndpointUseCase<dynamic>());
  gh.factory<_i7.UseCase<String, Uri>>(
      () => _i9.BingRequestBuilderUseCase<dynamic>());
  gh.factory<_i10.UserRepository<String, _i11.User>>(
      () => _i12.DataUserRepository());
  gh.factory<_i13.UserUpdateUseCase>(() =>
      _i13.UserUpdateUseCase(get<_i10.UserRepository<String, _i11.User>>()));
  gh.singleton<_i14.DiscoveryApi>(_i14.DiscoveryApi(
      get<_i7.UseCase<String, Uri>>(),
      get<_i7.UseCase<Uri, _i8.ResultsContainer>>()));
  gh.factory<_i15.DiscoveryResultsUseCase>(
      () => _i15.DiscoveryResultsUseCase(get<_i14.DiscoveryApi>()));
  gh.factory<_i16.NewsFeedManager>(
      () => _i16.NewsFeedManager(get<_i15.DiscoveryResultsUseCase>()));
  return get;
}
