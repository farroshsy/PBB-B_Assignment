import 'package:flutter/material.dart';
import '../utils/theme.dart';

class IslamicButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? outlineColor;
  final double? width;
  final double height;
  final double borderRadius;
  final IconData? iconData;
  final bool iconOnRight;

  const IslamicButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.outlineColor,
    this.width,
    this.height = 48,
    this.borderRadius = 8,
    this.iconData,
    this.iconOnRight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColor = backgroundColor ?? AppTheme.primaryColor;
    final buttonTextColor = textColor ?? (isOutlined ? buttonColor : Colors.white);
    final buttonOutlineColor = outlineColor ?? buttonColor;

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: buttonOutlineColor),
                foregroundColor: buttonTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: _buildButtonContent(),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                elevation: 1,
              ),
              child: _buildButtonContent(),
            ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? AppTheme.primaryColor : Colors.white,
          ),
        ),
      );
    }

    if (iconData == null) {
      return Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!iconOnRight) ...[
          Icon(iconData, size: 18),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        if (iconOnRight) ...[
          const SizedBox(width: 8),
          Icon(iconData, size: 18),
        ],
      ],
    );
  }
}
