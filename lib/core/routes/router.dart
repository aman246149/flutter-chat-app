import 'package:auto_route/auto_route.dart';
import 'package:brandzone/core/routes/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: ForgotVerifyOtpRoute.page),
    AutoRoute(page: ForgotNewPasswordRoute.page),
    AutoRoute(page: VerifyOtpRoute.page),
    AutoRoute(page: SignUpRoute.page),

    //!HOME
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: ChatPage.page),
  ];
}
