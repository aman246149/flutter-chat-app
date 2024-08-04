import '../../../features/auth/export.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.isObsecure = false,
  });
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;
  final bool isObsecure;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      // padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffFAFAFA)),
      child: Row(
        children: [
          Expanded(
            child: BorderedTextFormField(
              controller: controller,
              hintText: hintText,
              obscureText: isObsecure,
              contentPadding: EdgeInsets.all(16),
              noBorder: true,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: const Color(0xff8E8E8E),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
            ),
          ),
          if (suffixIcon != null) ...[const Hspace(5), suffixIcon!],
        ],
      ),
    );
  }
}

class AppLabel extends StatelessWidget {
  const AppLabel({
    super.key,
    required this.label,
  });
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: const Color(0xff4B4B4B),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ));
  }
}
