import './export.dart';

@RoutePage()
class ForgotNewPasswordScreen extends StatefulWidget {
  const ForgotNewPasswordScreen({super.key});

  @override
  State<ForgotNewPasswordScreen> createState() =>
      _ForgotNewPasswordScreenState();
}

class _ForgotNewPasswordScreenState extends State<ForgotNewPasswordScreen> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

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
                  Text("Email Verified",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: const Color(0xff131A29),
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          )),
                  const Vspace(8),
                  Text("Create a new password",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: const Color(0xff8E8E8E),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          )),
                  const Vspace(32),
                  const AppLabel(
                    label: "New Password",
                  ),
                  const Vspace(8),
                  AppInputField(
                    controller: newPassword,
                    hintText: "Enter New Password",
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
                    ),
                  ),
                  const Vspace(20),
                  const AppLabel(
                    label: "Confirm New Password",
                  ),
                  const Vspace(8),
                  AppInputField(
                    controller: confirmNewPassword,
                    isObsecure: isConfirmPasswordVisible,
                    hintText: "Confirm New Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                      icon: Image.asset(
                        AppImages.eyeOpen,
                        height: 18,
                        width: 14,
                      ),
                    ),
                  ),
                  const Vspace(32),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      onTap: () {},
                      text: "Confirm and Continue",
                      fontsize: 16,
                      fontWeight: FontWeight.w500,
                      borderRadius: 10,
                      padding: EdgeInsets.zero,
                    ),
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
