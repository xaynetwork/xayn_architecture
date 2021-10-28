// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:xayn_architecture/concepts/use_case.dart' as _i6;

import 'app/managers/news_feed_manager.dart' as _i11;
import 'app/managers/storage_manager.dart' as _i12;
import 'domain/entities/document.dart' as _i4;
import 'domain/use_cases/discovery_engine/dicovery_results_use_case.dart'
    as _i10;
import 'domain/use_cases/discovery_engine/result_combiner_use_case.dart' as _i3;
import 'domain/use_cases/news_feed/bing_call_endpoint_use_case.dart' as _i7;
import 'domain/use_cases/news_feed/bing_request_builder_use_case.dart' as _i8;
import 'domain/use_cases/storage/storage_prepper_use_case.dart' as _i5;
import 'infrastructure/discovery_api.dart'
    as _i9; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.ResultCombinerUseCase>(
      () => _i3.ResultCombinerUseCase(get<List<_i4.Document>>()));
  gh.factory<_i5.StoragePrepperUseCase>(() => _i5.StoragePrepperUseCase());
  gh.factory<_i6.UseCase<Uri, _i7.ResultsContainer>>(
      () => _i7.BingCallEndpointUseCase<dynamic>());
  gh.factory<_i6.UseCase<String, Uri>>(
      () => _i8.BingRequestBuilderUseCase<dynamic>());
  gh.singleton<_i9.DiscoveryApi>(_i9.DiscoveryApi(
      get<_i6.UseCase<String, Uri>>(),
      get<_i6.UseCase<Uri, _i7.ResultsContainer>>()));
  gh.factory<_i10.DiscoveryResultsUseCase>(
      () => _i10.DiscoveryResultsUseCase(get<_i9.DiscoveryApi>()));
  gh.factory<_i11.NewsFeedManager>(
      () => _i11.NewsFeedManager(get<_i10.DiscoveryResultsUseCase>()));
  gh.factory<_i12.StorageManager>(
      () => _i12.StorageManager(get<_i5.StoragePrepperUseCase>()));
  return get;
}
