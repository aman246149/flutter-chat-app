import './export.dart';

@RoutePage()
class ForgotVerifyOtpScreen extends StatefulWidget {
  const ForgotVerifyOtpScreen({super.key, required this.email});
  final String email;
  @override
  State<ForgotVerifyOtpScreen> createState() => _ForgotVerifyOtpScreenState();
}

class _ForgotVerifyOtpScreenState extends State<ForgotVerifyOtpScreen> {
  TextEditingController otpController = TextEditingController();

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
                  Text("Verify OTP",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                        context.router.push(const ForgotNewPasswordRoute());
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
