// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:xayn_architecture/concepts/use_case.dart' as _i9;

import 'app/managers/news_feed_manager.dart' as _i14;
import 'app/managers/readability_manager.dart' as _i7;
import 'app/managers/storage_manager.dart' as _i8;
import 'domain/use_cases/discovery_engine/dicovery_results_use_case.dart'
    as _i13;
import 'domain/use_cases/news_feed/bing_call_endpoint_use_case.dart' as _i10;
import 'domain/use_cases/news_feed/bing_request_builder_use_case.dart' as _i11;
import 'domain/use_cases/readability/html_fetcher_use_case.dart' as _i3;
import 'domain/use_cases/readability/make_readable_use_case.dart' as _i5;
import 'domain/use_cases/readability/process_html_use_case.dart' as _i6;
import 'domain/use_cases/storage/hydrated_storage_init_use_case.dart' as _i4;
import 'infrastructure/discovery_api.dart'
    as _i12; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.HtmlFetcherUseCase<dynamic>>(
      () => _i3.HtmlFetcherUseCase<dynamic>());
  gh.factory<_i4.HydratedStorageInitUseCase>(
      () => _i4.HydratedStorageInitUseCase());
  gh.factory<_i5.MakeReadableUseCase<dynamic>>(
      () => _i5.MakeReadableUseCase<dynamic>());
  gh.factory<_i6.ProcessHtmlUseCase<dynamic>>(
      () => _i6.ProcessHtmlUseCase<dynamic>());
  gh.factory<_i7.ReadabilityManager>(() => _i7.ReadabilityManager(
      get<_i3.HtmlFetcherUseCase<dynamic>>(),
      get<_i5.MakeReadableUseCase<dynamic>>(),
      get<_i6.ProcessHtmlUseCase<dynamic>>()));
  gh.factory<_i8.StorageManager>(
      () => _i8.StorageManager(get<_i4.HydratedStorageInitUseCase>()));
  gh.factory<_i9.UseCase<Uri, _i10.ResultsContainer>>(
      () => _i10.BingCallEndpointUseCase<dynamic>());
  gh.factory<_i9.UseCase<String, Uri>>(
      () => _i11.BingRequestBuilderUseCase<dynamic>());
  gh.singleton<_i12.DiscoveryApi>(_i12.DiscoveryApi(
      get<_i9.UseCase<String, Uri>>(),
      get<_i9.UseCase<Uri, _i10.ResultsContainer>>()));
  gh.factory<_i13.DiscoveryResultsUseCase>(
      () => _i13.DiscoveryResultsUseCase(get<_i12.DiscoveryApi>()));
  gh.factory<_i14.NewsFeedManager>(
      () => _i14.NewsFeedManager(get<_i13.DiscoveryResultsUseCase>()));
  return get;
}
