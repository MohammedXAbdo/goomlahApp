import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/presentation/widgets/extentions.dart';
import 'package:easy_localization/easy_localization.dart';

class ScrollableSheet extends StatefulWidget {
  final Product product;
  ScrollableSheet({Key key, this.product}) : super(key: key);

  @override
  _ScrollableSheetState createState() => _ScrollableSheetState();
}

class _ScrollableSheetState extends State<ScrollableSheet> {
  bool isArabic;
  String arabicName;
  String arabicDescription;
  @override
  void didChangeDependencies() {
    isArabic = EasyLocalization.of(context).locale.languageCode == 'ar';
    arabicName = widget.product.nameArabic;
    arabicDescription = widget.product.descriptionArabic;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return DraggableScrollableSheet(
      maxChildSize: 0.9,
      initialChildSize: 0.45,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          padding: AppTheme.getPadding(context).copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: AppTheme.fullHeight(context) * 0.006),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: AppTheme.fullWidth(context) * 0.15,
                    height: AppTheme.fullHeight(context) * 0.006,
                    decoration: BoxDecoration(
                        color: LightColor.orange,
                        borderRadius: BorderRadius.all(Radius.circular(
                            AppTheme.fullHeight(context) * 0.012))),
                  ),
                ),
                SizedBox(height: AppTheme.fullHeight(context) * 0.012),
                titleAndPrice(),
                SizedBox(height: AppTheme.fullHeight(context) * 0.025),
                _availableSize(),
                SizedBox(height: 20),
                _description(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget titleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
            flex: 2,
            child: AutoSizeText(
                !isArabic
                    ? widget.product.name
                    : arabicName != null && arabicName.isNotEmpty
                        ? arabicName
                        : widget.product.name,
                maxLines: 2,
                style: TextsStyle.productPageName(context))),
        Flexible(
          flex: 1,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: FittedBox(
                        child: Text(
                      widget.product.price.toString(),
                      style: TextsStyle.productPagePrice(context),
                    )),
                  ),
                  SizedBox(width: AppTheme.fullWidth(context) * 0.01),
                  Text("mony_sign".tr(),
                      style: TextsStyle.productPageDolar(context)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [getStars()],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _description(context) {
    return widget.product.description != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'description'.tr(),
                style: TextsStyle.productPageItem(context),
              ),
              SizedBox(height: AppTheme.fullHeight(context) * 0.026),
              AutoSizeText(
                !isArabic
                    ? widget.product.description
                    : arabicDescription != null && arabicDescription.isNotEmpty
                        ? arabicDescription
                        : widget.product.description,
                style: TextStyle(
                    fontSize: AppTheme.fullHeight(context) * 0.017,
                    color: LightColor.tiraryColor),
              ),
            ],
          )
        : SizedBox.shrink();
  }

  int selectedSizeIndex = 0;

  Widget _availableSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "available_size".tr(),
          style: TextsStyle.productPageItem(context),
        ),
        SizedBox(height: AppTheme.fullHeight(context) * 0.023),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _sizeWidget("6", index: 0),
            _sizeWidget("7", index: 1),
            _sizeWidget("8", index: 2),
            _sizeWidget("9", index: 3),
          ],
        )
      ],
    );
  }

  Widget _sizeWidget(String text,
      {Color color = LightColor.iconColor, int index}) {
    bool isSelected = index == selectedSizeIndex;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppTheme.fullHeight(context) * 0.02,
          vertical: AppTheme.fullHeight(context) * 0.015),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isSelected ? LightColor.orange : Theme.of(context).backgroundColor,
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: AppTheme.fullHeight(context) * 0.017,
            color:
                isSelected ? LightColor.background : LightColor.titleTextColor,
            fontWeight: FontWeight.w700),
      ),
    ).ripple(() {
      setState(() {
        selectedSizeIndex = index;
      });
    }, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget getStars() {
    return Row(
      children: <Widget>[
        Icon(Icons.star, color: LightColor.yellowColor, size: 17),
        Icon(Icons.star, color: LightColor.yellowColor, size: 17),
        Icon(Icons.star, color: LightColor.yellowColor, size: 17),
        Icon(Icons.star, color: LightColor.yellowColor, size: 17),
        Icon(Icons.star_border, size: 17),
      ],
    );
  }
}
