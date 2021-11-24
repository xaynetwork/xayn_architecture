// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:xayn_architecture/xayn_architecture.dart' as _i10;

import 'app/managers/news_feed_manager.dart' as _i15;
import 'app/managers/result_card_manager.dart' as _i8;
import 'app/managers/storage_manager.dart' as _i9;
import 'domain/use_cases/cards/palette_use_case.dart' as _i6;
import 'domain/use_cases/discovery_engine/dicovery_results_use_case.dart'
    as _i14;
import 'domain/use_cases/news_feed/bing_call_endpoint_use_case.dart' as _i12;
import 'domain/use_cases/news_feed/bing_request_builder_use_case.dart' as _i11;
import 'domain/use_cases/readability/html_fetcher_use_case.dart' as _i3;
import 'domain/use_cases/readability/make_readable_use_case.dart' as _i5;
import 'domain/use_cases/readability/process_html_use_case.dart' as _i7;
import 'domain/use_cases/storage/hydrated_storage_init_use_case.dart' as _i4;
import 'infrastructure/discovery_api.dart'
    as _i13; // ignore_for_file: unnecessary_lambdas

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
  gh.factory<_i6.PaletteUseCase<dynamic>>(() => _i6.PaletteUseCase<dynamic>());
  gh.factory<_i7.ProcessHtmlUseCase<dynamic>>(
      () => _i7.ProcessHtmlUseCase<dynamic>());
  gh.factory<_i8.ResultCardManager>(() => _i8.ResultCardManager(
      get<_i3.HtmlFetcherUseCase<dynamic>>(),
      get<_i5.MakeReadableUseCase<dynamic>>(),
      get<_i7.ProcessHtmlUseCase<dynamic>>(),
      get<_i6.PaletteUseCase<dynamic>>()));
  gh.factory<_i9.StorageManager>(
      () => _i9.StorageManager(get<_i4.HydratedStorageInitUseCase>()));
  gh.factory<_i10.UseCase<String, Uri>>(
      () => _i11.BingRequestBuilderUseCase<dynamic>());
  gh.factory<_i10.UseCase<Uri, _i12.ResultsContainer>>(
      () => _i12.BingCallEndpointUseCase<dynamic>());
  gh.singleton<_i13.DiscoveryApi>(_i13.DiscoveryApi(
      get<_i10.UseCase<String, Uri>>(),
      get<_i10.UseCase<Uri, _i12.ResultsContainer>>()));
  gh.factory<_i14.DiscoveryResultsUseCase>(
      () => _i14.DiscoveryResultsUseCase(get<_i13.DiscoveryApi>()));
  gh.factory<_i15.NewsFeedManager>(
      () => _i15.NewsFeedManager(get<_i14.DiscoveryResultsUseCase>()));
  return get;
}
