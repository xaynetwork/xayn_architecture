// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:xayn_architecture/concepts/use_case.dart' as _i5;

import 'app/managers/news_feed_manager.dart' as _i10;
import 'app/managers/storage_manager.dart' as _i4;
import 'domain/use_cases/discovery_engine/dicovery_results_use_case.dart'
    as _i9;
import 'domain/use_cases/news_feed/bing_call_endpoint_use_case.dart' as _i6;
import 'domain/use_cases/news_feed/bing_request_builder_use_case.dart' as _i7;
import 'domain/use_cases/storage/hydrated_storage_init_use_case.dart' as _i3;
import 'infrastructure/discovery_api.dart'
    as _i8; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.HydratedStorageInitUseCase>(
      () => _i3.HydratedStorageInitUseCase());
  gh.factory<_i4.StorageManager>(
      () => _i4.StorageManager(get<_i3.HydratedStorageInitUseCase>()));
  gh.factory<_i5.UseCase<Uri, _i6.ResultsContainer>>(
      () => _i6.BingCallEndpointUseCase<dynamic>());
  gh.factory<_i5.UseCase<String, Uri>>(
      () => _i7.BingRequestBuilderUseCase<dynamic>());
  gh.singleton<_i8.DiscoveryApi>(_i8.DiscoveryApi(
      get<_i5.UseCase<String, Uri>>(),
      get<_i5.UseCase<Uri, _i6.ResultsContainer>>()));
  gh.factory<_i9.DiscoveryResultsUseCase>(
      () => _i9.DiscoveryResultsUseCase(get<_i8.DiscoveryApi>()));
  gh.factory<_i10.NewsFeedManager>(
      () => _i10.NewsFeedManager(get<_i9.DiscoveryResultsUseCase>()));
  return get;
}
