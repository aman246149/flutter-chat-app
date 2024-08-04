import 'package:auto_route/auto_route.dart';
import 'package:brandzone/core/bloc/auth/auth_bloc.dart';
import 'package:brandzone/core/routes/router.gr.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(seconds: 2), () {
      if (context.read<AuthBloc>().state is AuthSuccessState) {
        // context.read<AuthBloc>().add(CheckUserAuthEvent());

        context.router.replace(const HomeRoute());
      } else {
        context.router.replace(const LoginRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text("CHECKING AUTH STATUS"),
    ));
  }
}
