import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/widgets/cached_image.dart';
import 'package:goomlah/presentation/wishlist/bloc/wish_list_bloc.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/presentation/widgets/extentions.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/utils/functions/functions.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isArabic = EasyLocalization.of(context).locale.languageCode == 'ar';
    String arabicName = product.nameArabic;

    return Card(
      color: LightColor.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(AppTheme.fullWidth(context) * 0.048)),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400], width: 0.5),
          color: LightColor.background,
          borderRadius: BorderRadius.all(
              Radius.circular(AppTheme.fullWidth(context) * 0.048)),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: AppTheme.fullHeight(context) * 0.012,
                bottom: AppTheme.fullHeight(context) * 0.012,
                left: AppTheme.fullWidth(context) * 0.022,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  product.isliked ? Icons.favorite : Icons.favorite_border,
                  color: product.isliked ? Colors.red : LightColor.iconColor,
                ).ripple(
                  () {
                    if (product.isliked) {
                      BlocProvider.of<WishlistBloc>(context)
                          .add(RemoveFromWishlist(product: product));
                    } else {
                      BlocProvider.of<WishlistBloc>(context)
                          .add(AddToWishlist(product: product));
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: AppTheme.fullWidth(context) * 0.2,
                        child: CachedImage(url: product.image)),
                    FittedBox(
                      child: Text(
                        !isArabic
                            ? product.name
                            : arabicName != null && arabicName.isNotEmpty
                                ? arabicName
                                : product.name,
                        style: TextsStyle.productCardName(context),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: Text(product.price.toString(),
                              style: TextsStyle.productCardPrice(context)),
                        ),
                        SizedBox(width:AppTheme.fullWidth(context)*0.015),
                        FittedBox(
                          child: Text("mony_sign".tr(),
                              style: TextsStyle.productCardSign(context)),
                        ),
                      ],
                    ),
                    SizedBox(height: AppTheme.fullHeight(context) * 0.01),
                  ],
                ),
              ).ripple(() {
                Functions.goToProductPage(context, product);
              },
                  borderRadius: BorderRadius.all(
                      Radius.circular(AppTheme.fullWidth(context) * 0.048))),
            ),
          ],
        ),
      ),
    );
  }
}
