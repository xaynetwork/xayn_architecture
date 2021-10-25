// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'app/managers/screen_cubit.dart' as _i9;
import 'data/repositories/data_user_repository.dart' as _i7;
import 'domain/entities/user.dart' as _i6;
import 'domain/repositories/user_repository.dart' as _i5;
import 'domain/use_cases/scroll_update_use_case.dart' as _i3;
import 'domain/use_cases/search_use_case.dart' as _i4;
import 'domain/use_cases/user_update_use_case.dart'
    as _i8; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.ScrollUpdateUseCase>(() => _i3.ScrollUpdateUseCase());
  gh.factory<_i4.SearchUseCase>(() => _i4.SearchUseCase());
  gh.factory<_i5.UserRepository<String, _i6.User>>(
      () => _i7.DataUserRepository());
  gh.factory<_i8.UserUpdateUseCase>(
      () => _i8.UserUpdateUseCase(get<_i5.UserRepository<String, _i6.User>>()));
  gh.factory<_i9.ScreenCubit>(() => _i9.ScreenCubit(
      get<_i8.UserUpdateUseCase>(), get<_i3.ScrollUpdateUseCase>()));
  return get;
}
