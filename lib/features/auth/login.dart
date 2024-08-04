import 'package:brandzone/core/utils/common_methods.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/auth/auth_bloc.dart';
import '../../core/utils/responsive_util.dart';
import './export.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            showOverlayLoader(context);
          } else if (state is AuthSuccessState) {
            hideOverlayLoader(context);
            context.router.popUntilRoot();
            context.router.replaceAll([const HomeRoute()]);
          } else if (state is AuthErrorState) {
            hideOverlayLoader(context);
            showErrorSnackbar(context, state.error);
          }
        },
        child: Center(
          child: ResponsiveWidget(
            constraints: CustomConstraints.getAuthConstraints(
                context: context, width: MediaQuery.of(context).size.width),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonAuthContainerUI(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome to Chat",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: const Color(0xff131A29),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                  )),
                      const Vspace(32),
                      const AppLabel(
                        label: "Email Address",
                      ),
                      const Vspace(8),
                      AppInputField(
                        controller: emailController,
                        hintText: "Enter email address",
                      ),
                      const Vspace(20),
                      const AppLabel(
                        label: "Password",
                      ),
                      const Vspace(8),
                      AppInputField(
                          controller: passwordController,
                          hintText: "Enter Password",
                          isObsecure: isPasswordVisible,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            icon: Image.asset(
                              AppImages.eyeOpen,
                              height: 18,
                              width: 14,
                            ),
                          )),
                      const Vspace(32),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          onTap: () {
                            context.read<AuthBloc>().add(SignInEvent(
                                email: emailController.text,
                                password: passwordController.text));
                          },
                          text: "Continue",
                          fontsize: 16,
                          fontWeight: FontWeight.w500,
                          borderRadius: 10,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const Vspace(20),
                      Align(
                        alignment: Alignment.center,
                        child: CustomTextButton(
                          text: "Don't have an account? Sign Up",
                          color: AppColors.black,
                          onTap: () {
                            context.router.push(const SignUpRoute());
                          },
                        ),
                      ),
                      const Vspace(20),
                      SizedBox(
                          height:
                              MediaQuery.of(context).viewInsets.bottom + 20),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
