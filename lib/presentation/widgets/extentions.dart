import 'package:flutter/material.dart';
import 'package:goomlah/themes/light_color.dart';

extension WidgetModifier on Widget {
  Widget ripple(Function onPressed,
          {BorderRadiusGeometry borderRadius =
              const BorderRadius.all(Radius.circular(5))}) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: FlatButton(
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                onPressed: () {
                  if (onPressed != null) {
                    onPressed();
                  }
                },
                child: Container()),
          )
        ],
      );

  Widget addPadding({EdgeInsetsGeometry padding = const EdgeInsets.all(10)}) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  Widget addGradiant() {
    return Container(
        decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          LightColor.firstGradiantColor,
          LightColor.secondGradiantColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: this,
    );
  }
}
