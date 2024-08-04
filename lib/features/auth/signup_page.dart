import 'package:brandzone/core/utils/common_methods.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/auth/auth_bloc.dart';
import '../../core/utils/responsive_util.dart';
import './export.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: ResponsiveWidget(
          constraints: CustomConstraints.getAuthConstraints(
              context: context, width: MediaQuery.of(context).size.width),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoadingState) {
                showOverlayLoader(context);
              } else if (state is RegistrationSuccessState) {
                hideOverlayLoader(context);
                context.router
                    .push(VerifyOtpRoute(email: emailController.text));
              } else if (state is AuthErrorState) {
                hideOverlayLoader(context);
                showErrorSnackbar(context, state.error);
              }
            },
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
                      const Vspace(20),
                      const AppLabel(
                        label: "Name",
                      ),
                      const Vspace(8),
                      AppInputField(
                        controller: nameController,
                        hintText: "Enter Name",
                      ),
                      const Vspace(32),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          onTap: () {
                            context.read<AuthBloc>().add(SignUpEvent(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                ));
                          },
                          text: "Sign Up",
                          fontsize: 16,
                          fontWeight: FontWeight.w500,
                          borderRadius: 10,
                          padding: EdgeInsets.zero,
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
