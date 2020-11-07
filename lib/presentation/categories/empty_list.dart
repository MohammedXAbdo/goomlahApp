import 'package:flutter/material.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class EmptyList extends StatelessWidget {
  final String message ;
  const EmptyList({
    Key key, this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppTheme.fullHeight(context) * .07),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
         message ?? 'empty_products'.tr() + ".",
          style: TextsStyle.noDataMessage(context),
        ),
      ),
    );
  }
}
