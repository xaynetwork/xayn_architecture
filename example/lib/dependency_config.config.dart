// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'app/managers/screen_cubit.dart' as _i11;
import 'data/repositories/data_user_repository.dart' as _i9;
import 'domain/entities/user.dart' as _i8;
import 'domain/repositories/user_repository.dart' as _i7;
import 'domain/use_cases/dicovery_results_use_case.dart' as _i4;
import 'domain/use_cases/scroll_update_use_case.dart' as _i5;
import 'domain/use_cases/search_use_case.dart' as _i6;
import 'domain/use_cases/user_update_use_case.dart' as _i10;
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
  gh.factory<_i5.ScrollUpdateUseCase>(() => _i5.ScrollUpdateUseCase());
  gh.factory<_i6.SearchUseCase>(() => _i6.SearchUseCase());
  gh.factory<_i7.UserRepository<String, _i8.User>>(
      () => _i9.DataUserRepository());
  gh.factory<_i10.UserUpdateUseCase>(() =>
      _i10.UserUpdateUseCase(get<_i7.UserRepository<String, _i8.User>>()));
  gh.factory<_i11.ScreenCubit>(() => _i11.ScreenCubit(
      get<_i4.DiscoveryResultsUseCase>(),
      get<_i10.UserUpdateUseCase>(),
      get<_i5.ScrollUpdateUseCase>()));
  return get;
}
