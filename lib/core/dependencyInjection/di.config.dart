// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:localstore/localstore.dart' as _i5;

import '../bloc/auth/auth_bloc.dart' as _i14;
import '../bloc/chat/chat_cubit.dart' as _i15;
import '../bloc/user/user_cubit.dart' as _i16;
import '../blocobserver/bloc_observer.dart' as _i3;
import '../data/db/db_client.dart' as _i6;
import '../data/network/api_client.dart' as _i9;
import '../data/repository/auth_repository.dart' as _i10;
import '../data/repository/chat_repository.dart' as _i12;
import '../data/repository/db_repository.dart' as _i7;
import '../data/repository/user_repository.dart' as _i13;
import '../domain/usecases/auth_usecase.dart' as _i11;
import '../modules/network_module.dart' as _i18;
import '../modules/preference_module.dart' as _i17;
import '../utils/loader.dart' as _i4;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final preferenceModule = _$PreferenceModule();
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i3.AppBlocObserver>(() => _i3.AppBlocObserver());
    gh.lazySingleton<_i4.Loader>(() => _i4.Loader());
    gh.lazySingleton<_i5.Localstore>(
        () => preferenceModule.provideSharedPreferences());
    gh.lazySingleton<_i6.DBClient>(() => _i6.DBClient(gh<_i5.Localstore>()));
    gh.lazySingleton<_i7.DatabaseRepository>(
        () => _i7.DatabaseRepository(gh<_i6.DBClient>()));
    gh.lazySingleton<_i8.Dio>(
        () => networkModule.provideDio(gh<_i5.Localstore>()));
    gh.lazySingleton<_i9.ApiClient>(() => _i9.ApiClient(gh<_i8.Dio>()));
    gh.lazySingleton<_i10.AuthRepository>(
        () => _i10.AuthRepository(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i11.AuthUseCase>(() => _i11.AuthUseCase(
          gh<_i10.AuthRepository>(),
          gh<_i7.DatabaseRepository>(),
        ));
    gh.lazySingleton<_i12.ChatRepository>(
        () => _i12.ChatRepository(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i13.UserRepository>(
        () => _i13.UserRepository(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i14.AuthBloc>(
        () => _i14.AuthBloc(authUseCase: gh<_i11.AuthUseCase>()));
    gh.lazySingleton<_i15.ChatCubit>(
        () => _i15.ChatCubit(gh<_i12.ChatRepository>()));
    gh.lazySingleton<_i16.UserCubit>(
        () => _i16.UserCubit(userRepository: gh<_i13.UserRepository>()));
    return this;
  }
}

class _$PreferenceModule extends _i17.PreferenceModule {}

class _$NetworkModule extends _i18.NetworkModule {}
