import 'package:cyber_buddy/screens/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onDetailPressed;

  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;
  final Widget? titleWidget;
  final Widget? searchBar;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final PreferredSizeWidget? bottom;
  final bool isTransparent;
  final EdgeInsetsGeometry? titlePadding;

  const AppHeader({
    super.key,
    this.title = '',
    this.onBackPressed,
    this.onMenuPressed,
    this.onDetailPressed,
    this.actions,
    this.centerTitle = true,
    this.elevation = 0,
    this.titleWidget,
    this.searchBar,
    this.backgroundColor,
    this.foregroundColor,
    this.height = kToolbarHeight,
    this.bottom,
    this.isTransparent = false,
    this.titlePadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? leadingWidget;
    if (onBackPressed != null) {
      leadingWidget = IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: foregroundColor ?? black.withValues(alpha: .8),
        ),
        onPressed: onBackPressed,
      );
    } else if (onMenuPressed != null) {
      leadingWidget = IconButton(
        icon: Icon(
          LucideIcons.menu,
          color: foregroundColor ?? black.withValues(alpha: .8),
        ),
        onPressed: onMenuPressed,
      );
    } else if (onDetailPressed != null) {
      leadingWidget = IconButton(
        icon: Icon(
          LucideIcons.userSquare,
          size: 20,
          color: foregroundColor ?? black.withValues(alpha: .8),
        ),
        onPressed: onDetailPressed,
      );
    }

    Widget titleContent;
    if (searchBar != null) {
      titleContent = Padding(
        padding: titlePadding ?? const EdgeInsets.symmetric(horizontal: 8.0),
        child: searchBar!,
      );
    } else if (titleWidget != null) {
      titleContent = titleWidget!;
    } else {
      titleContent = Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? theme.colorScheme.onSurface,
        ),
      );
    }

    return AppBar(
      elevation: elevation,
      centerTitle: searchBar != null ? false : centerTitle,
      backgroundColor: backgroundColor ?? transparent,
      foregroundColor: foregroundColor ?? theme.colorScheme.primary,
      leadingWidth: leadingWidget != null ? 48 : 16,
      leading: leadingWidget ?? const SizedBox(width: 16),
      title: titleContent,
      actions: actions,
      toolbarHeight: height,
      automaticallyImplyLeading:
          false, // We're manually handling the leading widget
      shape:
          elevation > 0
              ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              )
              : null,
      titleSpacing: 0.0,
      titleTextStyle: TextStyle(
        color: foregroundColor ?? const Color(0xFF1A1A1A),
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isTransparent ? Brightness.light : Brightness.dark,
        statusBarBrightness: isTransparent ? Brightness.dark : Brightness.light,
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(height + bottomHeight);
  }
}
