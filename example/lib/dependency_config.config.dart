// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'app/managers/screen_cubit.dart' as _i12;
import 'data/repositories/data_user_repository.dart' as _i10;
import 'domain/entities/user.dart' as _i9;
import 'domain/repositories/user_repository.dart' as _i8;
import 'domain/use_cases/dicovery_results_use_case.dart' as _i4;
import 'domain/use_cases/result_combiner_use_case.dart' as _i5;
import 'domain/use_cases/scroll_update_use_case.dart' as _i6;
import 'domain/use_cases/search_use_case.dart' as _i7;
import 'domain/use_cases/user_update_use_case.dart' as _i11;
import 'infrastructure/discovery_api.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.DiscoveryApi>(_i3.DiscoveryApi());
  gh.factory<_i4.DiscoveryResultsUseCase>(
      () => _i4.DiscoveryResultsUseCase(get<_i3.DiscoveryApi>()));
  gh.factory<_i5.ResultCombinerUseCase>(() => _i5.ResultCombinerUseCase());
  gh.factory<_i6.ScrollUpdateUseCase>(() => _i6.ScrollUpdateUseCase());
  gh.factory<_i7.SearchUseCase>(() => _i7.SearchUseCase());
  gh.factory<_i8.UserRepository<String, _i9.User>>(
      () => _i10.DataUserRepository());
  gh.factory<_i11.UserUpdateUseCase>(() =>
      _i11.UserUpdateUseCase(get<_i8.UserRepository<String, _i9.User>>()));
  gh.factory<_i12.ScreenCubit>(() => _i12.ScreenCubit(
      get<_i4.DiscoveryResultsUseCase>(),
      get<_i5.ResultCombinerUseCase>(),
      get<_i6.ScrollUpdateUseCase>()));
  return get;
}
