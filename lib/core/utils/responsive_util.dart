import '../../features/auth/export.dart';

class ResponsiveBrekPoints {
  static const double sm = 576;
  static const double md = 768;
  static const double lg = 992;
  static const double xl = 1200;
  static const double xxl = 1400;

  static bool isDesktop(double width) => width >= lg;
  static bool isTablet(double width) => width >= md && width < lg;
  static bool isMobile(double width) => width < md;
}

class CustomConstraints {
  static BoxConstraints getAuthConstraints(
      {required BuildContext context, required double width}) {
    return BoxConstraints(
      maxWidth: ResponsiveBrekPoints.isDesktop(width)
          ? MediaQuery.of(context).size.width / 3
          : width,
    );
  }
}
