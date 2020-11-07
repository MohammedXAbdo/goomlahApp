import 'package:flutter/material.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/widgets/cached_image.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:goomlah/presentation/widgets/extentions.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductRowItem extends StatefulWidget {
  const ProductRowItem({
    Key key,
    @required this.product,
    @required this.trailing,
    this.subTitle,
  }) : super(key: key);
  final Product product;
  final Widget Function(Product) trailing;
  final Widget subTitle;

  @override
  _ProductRowItemState createState() => _ProductRowItemState();
}

class _ProductRowItemState extends State<ProductRowItem> {
  @override
  Widget build(BuildContext context) {
    bool isArabic = EasyLocalization.of(context).locale.languageCode == 'ar';
    String arabicName = widget.product.nameArabic;

    return Column(
      children: [
        Row(
          children: <Widget>[
            Container(
              height: AppTheme.fullHeight(context) * 0.085,
              width: AppTheme.fullHeight(context) * 0.085,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(
                            AppTheme.fullWidth(context) * 0.03)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: AppTheme.fullWidth(context) * 0.12,
                        child: CachedImage(url: widget.product.image)),
                  ),
                ],
              ).ripple(() {
                Functions.goToProductPage(context, widget.product);
              },
                  borderRadius: BorderRadius.circular(
                      AppTheme.fullWidth(context) * 0.03)),
            ),
            Expanded(
                child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: Text(
                              !isArabic
                                  ? widget.product.name
                                  : arabicName != null && arabicName.isNotEmpty
                                      ? arabicName
                                      : widget.product.name,
                              style: TextsStyle.productWishlistName(context)),
                        ),
                        SizedBox(height: AppTheme.fullHeight(context) * 0.006),
                        widget.subTitle ??
                            Row(
                              children: <Widget>[
                                FittedBox(
                                  child: Text(
                                    widget.product.price.toString(),
                                    style: TextsStyle.productWishlistPrice(
                                        context),
                                  ),
                                ),
                                SizedBox(
                                    width: AppTheme.fullWidth(context) * 0.02),
                                FittedBox(
                                  child: Text(
                                    'mony_sign'.tr(),
                                    style:
                                        TextsStyle.productWishlistSign(context),
                                  ),
                                ),
                              ],
                            ),
                      ],
                    ).ripple(() {
                      Functions.goToProductPage(context, widget.product);
                    }),
                    trailing: widget.trailing(widget.product))),
          ],
        ),
        SizedBox(height: AppTheme.fullHeight(context) * 0.015),
      ],
    );
  }
}
