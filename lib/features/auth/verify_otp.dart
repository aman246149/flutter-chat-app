import 'package:brandzone/core/utils/common_methods.dart';
import 'package:brandzone/core/utils/responsive_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/auth/auth_bloc.dart';
import './export.dart';

@RoutePage()
class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.email});
  final String email;
  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            showOverlayLoader(context);
          } else if (state is OtpSuccessState) {
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
                Text(
                  "CHAT APP",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                ),
                const Vspace(32),
                CommonAuthContainerUI(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Verify OTP",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: const Color(0xff131A29),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                  )),
                      const Vspace(8),
                      RichText(
                          text: TextSpan(
                        text: "We’ve sent an OTP to ",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: const Color(0xff8E8E8E),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                        children: [
                          TextSpan(
                            text: widget.email,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                          ),
                        ],
                      )),
                      const Vspace(32),
                      const AppLabel(
                        label: "Enter OTP",
                      ),
                      const Vspace(8),
                      AppInputField(
                        controller: otpController,
                        hintText: "Enter OTP",
                      ),
                      const Vspace(32),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          onTap: () {
                            context
                                .read<AuthBloc>()
                                .add(VerifyOtpEvent(otp: otpController.text));
                          },
                          text: "Verify OTP",
                          fontsize: 16,
                          fontWeight: FontWeight.w500,
                          borderRadius: 10,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const Vspace(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_back_ios_rounded,
                              color: Color(0xff131A29), size: 16),
                          const Hspace(8),
                          CustomTextButton(
                            text: "Edit Email ID",
                            color: const Color(0xff131A29),
                            onTap: () {
                              context.router.pop();
                            },
                          ),
                        ],
                      ),
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
