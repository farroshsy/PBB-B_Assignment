import 'package:flutter/material.dart';
import '../utils/theme.dart';

class IslamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool showPattern;

  const IslamicAppBar({
    Key? key,
    required this.title,
    this.centerTitle = true,
    this.actions,
    this.showBackButton = true,
    this.leading,
    this.bottom,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.showPattern = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: foregroundColor ?? Colors.white,
        ),
      ),
      centerTitle: centerTitle,
      actions: actions,
      automaticallyImplyLeading: showBackButton,
      leading: leading,
      backgroundColor: backgroundColor ?? AppTheme.primaryColor,
      elevation: elevation,
      bottom: bottom,
      flexibleSpace: showPattern
          ? Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? AppTheme.primaryColor,
                image: DecorationImage(
                  image: const AssetImage(
                    'assets/patterns/app_bar_pattern.png',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
