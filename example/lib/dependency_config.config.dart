// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:xayn_architecture/xayn_architecture.dart' as _i11;

import 'app/managers/news_feed_manager.dart' as _i17;
import 'app/managers/result_card_manager.dart' as _i8;
import 'app/managers/storage_manager.dart' as _i19;
import 'domain/repositories/settings_repository.dart' as _i9;
import 'domain/use_cases/cards/palette_use_case.dart' as _i6;
import 'domain/use_cases/discovery_engine/dicovery_results_use_case.dart'
    as _i15;
import 'domain/use_cases/news_feed/bing_call_endpoint_use_case.dart' as _i13;
import 'domain/use_cases/news_feed/bing_request_builder_use_case.dart' as _i12;
import 'domain/use_cases/readability/html_fetcher_use_case.dart' as _i4;
import 'domain/use_cases/readability/make_readable_use_case.dart' as _i5;
import 'domain/use_cases/readability/process_html_use_case.dart' as _i7;
import 'domain/use_cases/settings/get_is_ready_use_case.dart' as _i16;
import 'domain/use_cases/settings/save_is_ready_use_case.dart' as _i18;
import 'infrastructure/discovery_api.dart' as _i14;
import 'infrastructure/in_memory_settings_repository.dart' as _i10;
import 'navigation/app_navigator.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.AppNavigatorManger>(_i3.AppNavigatorManger());
  gh.factory<_i4.HtmlFetcherUseCase<dynamic>>(
      () => _i4.HtmlFetcherUseCase<dynamic>());
  gh.factory<_i5.MakeReadableUseCase<dynamic>>(
      () => _i5.MakeReadableUseCase<dynamic>());
  gh.factory<_i6.PaletteUseCase<dynamic>>(() => _i6.PaletteUseCase<dynamic>());
  gh.factory<_i7.ProcessHtmlUseCase<dynamic>>(
      () => _i7.ProcessHtmlUseCase<dynamic>());
  gh.factory<_i8.ResultCardManager>(() => _i8.ResultCardManager(
      get<_i4.HtmlFetcherUseCase<dynamic>>(),
      get<_i5.MakeReadableUseCase<dynamic>>(),
      get<_i7.ProcessHtmlUseCase<dynamic>>(),
      get<_i6.PaletteUseCase<dynamic>>()));
  gh.singleton<_i9.SettingsRepository>(_i10.InMemorySettingsRepository());
  gh.factory<_i11.UseCase<String, Uri>>(
      () => _i12.BingRequestBuilderUseCase<dynamic>());
  gh.factory<_i11.UseCase<Uri, _i13.ResultsContainer>>(
      () => _i13.BingCallEndpointUseCase<dynamic>());
  gh.singleton<_i14.DiscoveryApi>(_i14.DiscoveryApi(
      get<_i11.UseCase<String, Uri>>(),
      get<_i11.UseCase<Uri, _i13.ResultsContainer>>()));
  gh.factory<_i15.DiscoveryResultsUseCase>(
      () => _i15.DiscoveryResultsUseCase(get<_i14.DiscoveryApi>()));
  gh.factory<_i16.GetIsReadyUseCase>(
      () => _i16.GetIsReadyUseCase(get<_i9.SettingsRepository>()));
  gh.factory<_i17.NewsFeedManager>(
      () => _i17.NewsFeedManager(get<_i15.DiscoveryResultsUseCase>()));
  gh.factory<_i18.SaveIsReadyUseCase>(
      () => _i18.SaveIsReadyUseCase(get<_i9.SettingsRepository>()));
  gh.factory<_i19.StorageManager>(() => _i19.StorageManager(
      get<_i16.GetIsReadyUseCase>(), get<_i18.SaveIsReadyUseCase>()));
  return get;
}
