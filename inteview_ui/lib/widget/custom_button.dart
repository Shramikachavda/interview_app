import 'package:flutter/material.dart';
import '../core/constant/app_constant.dart';

enum ButtonType { primary, secondary, outline, text, gradient }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget child = _buildButtonContent();

    switch (type) {
      case ButtonType.gradient:
        return GestureDetector(
          onTap: isLoading ? null : onPressed,
          child: Container(
            width: width ?? double.infinity,
            height: height ?? AppConstants.buttonHeight,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: gradientColors ??
                    [theme.primaryColor, theme.colorScheme.secondary],
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Center(child: child),
          ),
        );

      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(width ?? double.infinity, height ?? AppConstants.buttonHeight),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          child: child,
        );

      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            minimumSize: Size(width ?? double.infinity, height ?? AppConstants.buttonHeight),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          child: child,
        );

      case ButtonType.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(width ?? double.infinity, height ?? AppConstants.buttonHeight),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          child: child,
        );

      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize: Size(width ?? double.infinity, height ?? AppConstants.buttonHeight),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          child: child,
        );
    }
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500 , fontSize: 16),
          ),
        ],
      );
    }

    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500  , fontSize: 16),
    );
  }
}
