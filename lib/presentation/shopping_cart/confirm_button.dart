import 'package:flutter/material.dart';
import 'package:goomlah/presentation/widgets/common_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:goomlah/presentation/widgets/extentions.dart';
import 'package:goomlah/themes/theme.dart';

class ConfirmPaymentButton extends StatelessWidget {
  final int totalCount;
  final Map<String, int> itemsCount;
  final double totalPrice;
  final Function onPressed;

  const ConfirmPaymentButton(
      {Key key,
      @required this.itemsCount,
      @required this.totalPrice,
      @required this.totalCount,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonButton(
            label: setButtonLabel(totalCount),
            onPressed: () {
              if (onPressed != null) {
                onPressed();
              }
            })
        .addPadding(
            padding:
                EdgeInsets.only(bottom: AppTheme.fullHeight(context) * 0.025));
  }

  String setButtonLabel(int totalCount) {
    String itemWord = " $totalCount " + "item".tr();
    if (totalCount == 1) {
      itemWord = " $totalCount " + "item".tr();
    } else if (totalCount == 2) {
      itemWord = " " + "two_items".tr();
    } else if (totalCount <= 10) {
      itemWord = " $totalCount " + "items".tr();
    } else {
      itemWord = " $totalCount " + "more_than_ten_items".tr();
    }
    return "confirm_buying".tr() +
        itemWord +
        " " +
        "for".tr() +
        " $totalPrice " +
        "mony_sign".tr();
  }
}
