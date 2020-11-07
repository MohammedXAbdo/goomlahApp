import 'package:flutter/material.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {Key key, this.onPressed, this.label, this.isLoading = false})
      : super(key: key);
  final Function onPressed;
  final String label;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          if (onPressed != null && !isLoading) {
            onPressed();
          }
        },
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppTheme.fullWidth(context) * 0.037)),
        color: LightColor.secondryColor,
        child: Container(
          alignment: Alignment.center,
          height: AppTheme.fullHeight(context) * .05,
          width: AppTheme.fullWidth(context) * .7,
          child: !isLoading
              ? Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: LightColor.background,
                    fontWeight: FontWeight.w500,
                    fontSize: AppTheme.fullHeight(context) * 0.019,
                  ),
                )
              : Center(
                  child: Container(
                      height: AppTheme.fullHeight(context) * 0.03,
                      width: AppTheme.fullHeight(context) * 0.03,
                      child: CircularProgressIndicator()),
                ),
        ));
  }
}
