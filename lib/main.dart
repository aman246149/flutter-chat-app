import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:brandzone/amplifyconfiguration.dart';
import 'package:brandzone/core/bloc/chat/chat_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'core/bloc/auth/auth_bloc.dart';
import 'core/bloc/user/user_cubit.dart';
import 'core/blocobserver/bloc_observer.dart';
import 'core/dependencyInjection/di.dart';
import 'core/routes/router.dart';
import 'core/theme/apptheme.dart';

var logger = Logger();

Future<void> main() async {
  runZonedGuarded(() async {
    EquatableConfig.stringify = true;
    BindingBase.debugZoneErrorsAreFatal = true;
    WidgetsFlutterBinding.ensureInitialized();

    final authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);

    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      safePrint(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
    await AppContainer.init();
    Bloc.observer = GetIt.I<AppBlocObserver>();
    runApp(const MyApp());
  }, (e, s) {
    debugPrint('catches error of first error-zone.$e');
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    GetIt.I.registerSingleton<AppRouter>(_appRouter);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(
              value: GetIt.I<AuthBloc>()..add(CheckUserAuthEvent())),
          BlocProvider.value(value: GetIt.I<UserCubit>()),
          BlocProvider.value(value: GetIt.I<ChatCubit>()),
        ],
        child: MaterialApp.router(
          title: 'Brandzone ',
          routerConfig: _appRouter.config(),
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
        ));
  }
}
