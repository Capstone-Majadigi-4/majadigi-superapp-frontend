import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final Color? textColor;
  final Color? borderColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double height;
  final IconData? icon;

  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.gradientColors,
    this.textColor,
    this.borderColor,
    this.fontWeight,
    this.fontSize,
    this.height = 56,
    this.icon,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: ShapeDecoration(
        color: gradientColors == null ? (backgroundColor ?? const Color(0xFF0065FF)) : null,
        gradient: gradientColors != null
            ? LinearGradient(
                begin: const Alignment(0.00, 0.50),
                end: const Alignment(1.00, 0.50),
                colors: gradientColors!,
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 100),
          side: borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none,
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius ?? 100),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: textColor ?? Colors.white, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: fontSize ?? 16,
                      fontFamily: 'Inter',
                      fontWeight: fontWeight ?? FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
