import 'package:flutter/material.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'extentions.dart';

class IconWidget extends StatelessWidget {
  const IconWidget({
    this.icon,
    this.color = LightColor.iconColor,
    Key key,
    this.onPressed,
    this.isOutline = false,
    this.size,
    this.nonIconWidget,
    this.hasShadow = true ,
  }) : super(key: key);
  final IconData icon;
  final Widget nonIconWidget;
  final Color color;
  final Function onPressed;
  final bool isOutline;
  final double size;
  final bool hasShadow;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.fullHeight(context) * 0.012),
      decoration: BoxDecoration(
          border: Border.all(
              color: LightColor.iconColor,
              style: isOutline ? BorderStyle.solid : BorderStyle.none),
          borderRadius: AppTheme.getIconBorderRadius(context),
          color: Theme.of(context).backgroundColor,
          boxShadow: hasShadow ? AppTheme.shadow : null),
      child: nonIconWidget ??
          Icon(
            icon ?? Icons.home,
            color: color,
            size: size ?? AppTheme.fullWidth(context) * 0.06,
          ),
    ).ripple(onPressed, borderRadius: AppTheme.getIconBorderRadius(context));
  }
}
