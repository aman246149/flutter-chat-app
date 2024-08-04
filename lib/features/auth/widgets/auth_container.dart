import '../export.dart';

class CommonAuthContainerUI extends StatelessWidget {
  const CommonAuthContainerUI({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffD9D0C9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: child,
    );
  }
}
