// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../theme/app_color.dart';
import '../../theme/apptheme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      required this.text,
      this.onTap,
      this.icon,
      this.padding,
      this.color,
      this.textColor,
      this.fontsize,
      this.fontWeight,
      this.innerPadding,
      this.frontIcon,
      this.borderColor,
      this.frontIconWidth,
      this.borderRadius});
  final String text;
  final Function()? onTap;
  final Widget? icon;
  final EdgeInsets? padding;
  final Color? color;
  final Color? textColor;
  final double? fontsize;
  final FontWeight? fontWeight;
  final MaterialStateProperty<EdgeInsetsGeometry?>? innerPadding;
  final Widget? frontIcon;
  final Color? borderColor;
  final double? frontIconWidth;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
          style: ButtonStyle(
            padding: innerPadding,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 4.0),
                side: BorderSide(
                    color: onTap != null
                        ? borderColor ?? AppColors.primary
                        : Colors.grey.withOpacity(0.71)),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {}
                return onTap != null
                    ? color ?? AppColors.primary
                    : Colors.grey.withOpacity(0.71);
              },
            ),
          ),
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (frontIcon != null) ...[
                frontIcon!,
                SizedBox(
                  width: frontIconWidth ?? 16,
                ),
              ],
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyText2.copyWith(
                      color: textColor ?? Colors.white,
                      fontSize: fontsize ?? 15,
                      fontWeight: fontWeight ?? FontWeight.w500),
                ),
              ),
              if (icon != null) ...[
                const SizedBox(
                  width: 10,
                ),
                icon!
              ]
            ],
          )),
    );
  }
}

class PrimaryOutlineButton extends StatelessWidget {
  const PrimaryOutlineButton({
    super.key,
    required this.text,
    this.onTap,
    this.icon,
    this.padding,
    this.outlineColor,
    this.textColor,
    this.fontsize,
    this.fontWeight,
    this.innerPadding,
    this.borderRadius,
  });
  final String text;
  final Function()? onTap;
  final Widget? icon;
  final EdgeInsets? padding;
  final MaterialStateProperty<EdgeInsetsGeometry?>? innerPadding;
  final Color? outlineColor;
  final Color? textColor;
  final double? fontsize;
  final FontWeight? fontWeight;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton(
        style: ButtonStyle(
          side: MaterialStateProperty.all(const BorderSide(
              color: AppColors.primary, width: 1.0, style: BorderStyle.solid)),
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
          padding: innerPadding,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 4.0),
            ),
          ),
        ),
        onPressed: () {
          if (onTap != null) onTap!();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(
                  width: 10,
                ),
              ],
              Text(
                text,
                style: AppTheme.bodyText2.copyWith(
                  color: textColor ?? AppColors.white,
                  fontSize: fontsize ?? 15,
                  fontWeight: fontWeight ?? FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = AppColors.primary,
    this.fontsize = 16,
  });
  final String text;
  final Function() onTap;
  final Color color;
  final double fontsize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Text(text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: color,
                fontWeight: FontWeight.w400,
                fontSize: fontsize,
              )),
    );
  }
}
