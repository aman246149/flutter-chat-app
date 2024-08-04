import '../../../features/auth/export.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget(
      {super.key, required this.child, required this.constraints});
  final Widget child;
  final BoxConstraints constraints;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: constraints,
      child: child,
    );
  }
}
