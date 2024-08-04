// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:brandzone/core/presentation/widgets/inappwebview.dart' as _i6;
import 'package:brandzone/features/auth/export.dart' as _i12;
import 'package:brandzone/features/auth/forgot_new_password.dart' as _i2;
import 'package:brandzone/features/auth/forgot_password.dart' as _i3;
import 'package:brandzone/features/auth/forgot_verify_otp.dart' as _i4;
import 'package:brandzone/features/auth/login.dart' as _i7;
import 'package:brandzone/features/auth/signup_page.dart' as _i8;
import 'package:brandzone/features/auth/verify_otp.dart' as _i10;
import 'package:brandzone/features/home/chat_screen.dart' as _i1;
import 'package:brandzone/features/home/homepage.dart' as _i5;
import 'package:brandzone/features/splashScreen/splash_screen.dart' as _i9;
import 'package:flutter/material.dart' as _i13;

abstract class $AppRouter extends _i11.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i11.PageFactory> pagesMap = {
    ChatPage.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ChatPage(),
      );
    },
    ForgotNewPasswordRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ForgotNewPasswordScreen(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ForgotPasswordScreen(),
      );
    },
    ForgotVerifyOtpRoute.name: (routeData) {
      final args = routeData.argsAs<ForgotVerifyOtpRouteArgs>();
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.ForgotVerifyOtpScreen(
          key: args.key,
          email: args.email,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.HomeScreen(),
      );
    },
    InAppWeb.name: (routeData) {
      final args = routeData.argsAs<InAppWebArgs>();
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.InAppWeb(
          key: args.key,
          url: args.url,
          isAppBarNeeded: args.isAppBarNeeded,
          text: args.text,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoginScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.SignUpScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SplashScreen(),
      );
    },
    VerifyOtpRoute.name: (routeData) {
      final args = routeData.argsAs<VerifyOtpRouteArgs>();
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.VerifyOtpScreen(
          key: args.key,
          email: args.email,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.ChatPage]
class ChatPage extends _i11.PageRouteInfo<void> {
  const ChatPage({List<_i11.PageRouteInfo>? children})
      : super(
          ChatPage.name,
          initialChildren: children,
        );

  static const String name = 'ChatPage';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ForgotNewPasswordScreen]
class ForgotNewPasswordRoute extends _i11.PageRouteInfo<void> {
  const ForgotNewPasswordRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ForgotNewPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotNewPasswordRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i11.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ForgotVerifyOtpScreen]
class ForgotVerifyOtpRoute
    extends _i11.PageRouteInfo<ForgotVerifyOtpRouteArgs> {
  ForgotVerifyOtpRoute({
    _i12.Key? key,
    required String email,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          ForgotVerifyOtpRoute.name,
          args: ForgotVerifyOtpRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'ForgotVerifyOtpRoute';

  static const _i11.PageInfo<ForgotVerifyOtpRouteArgs> page =
      _i11.PageInfo<ForgotVerifyOtpRouteArgs>(name);
}

class ForgotVerifyOtpRouteArgs {
  const ForgotVerifyOtpRouteArgs({
    this.key,
    required this.email,
  });

  final _i12.Key? key;

  final String email;

  @override
  String toString() {
    return 'ForgotVerifyOtpRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i5.HomeScreen]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute({List<_i11.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i6.InAppWeb]
class InAppWeb extends _i11.PageRouteInfo<InAppWebArgs> {
  InAppWeb({
    _i13.Key? key,
    required String url,
    bool isAppBarNeeded = true,
    String? text,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          InAppWeb.name,
          args: InAppWebArgs(
            key: key,
            url: url,
            isAppBarNeeded: isAppBarNeeded,
            text: text,
          ),
          initialChildren: children,
        );

  static const String name = 'InAppWeb';

  static const _i11.PageInfo<InAppWebArgs> page =
      _i11.PageInfo<InAppWebArgs>(name);
}

class InAppWebArgs {
  const InAppWebArgs({
    this.key,
    required this.url,
    this.isAppBarNeeded = true,
    this.text,
  });

  final _i13.Key? key;

  final String url;

  final bool isAppBarNeeded;

  final String? text;

  @override
  String toString() {
    return 'InAppWebArgs{key: $key, url: $url, isAppBarNeeded: $isAppBarNeeded, text: $text}';
  }
}

/// generated route for
/// [_i7.LoginScreen]
class LoginRoute extends _i11.PageRouteInfo<void> {
  const LoginRoute({List<_i11.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i8.SignUpScreen]
class SignUpRoute extends _i11.PageRouteInfo<void> {
  const SignUpRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i9.SplashScreen]
class SplashRoute extends _i11.PageRouteInfo<void> {
  const SplashRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i10.VerifyOtpScreen]
class VerifyOtpRoute extends _i11.PageRouteInfo<VerifyOtpRouteArgs> {
  VerifyOtpRoute({
    _i12.Key? key,
    required String email,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          VerifyOtpRoute.name,
          args: VerifyOtpRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'VerifyOtpRoute';

  static const _i11.PageInfo<VerifyOtpRouteArgs> page =
      _i11.PageInfo<VerifyOtpRouteArgs>(name);
}

class VerifyOtpRouteArgs {
  const VerifyOtpRouteArgs({
    this.key,
    required this.email,
  });

  final _i12.Key? key;

  final String email;

  @override
  String toString() {
    return 'VerifyOtpRouteArgs{key: $key, email: $email}';
  }
}
