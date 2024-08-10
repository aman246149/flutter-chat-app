import './export.dart';

@RoutePage()
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
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
                  Text("Recover your account",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: const Color(0xff131A29),
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          )),
                  const Vspace(8),
                  Text(
                      "Enter the email associated with your account, and we'll send you one time password (OTP)",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: const Color(0xff8E8E8E),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
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
                  const Vspace(32),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      onTap: () {
                        context.router.push(ForgotVerifyOtpRoute(
                          email: emailController.text,
                        ));
                      },
                      text: "Continue",
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
                        text: "Go back to Login",
                        color: const Color(0xff131A29),
                        onTap: () {
                          context.router.pop();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom + 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
