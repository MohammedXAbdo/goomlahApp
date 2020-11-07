import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/product_page/product_detail.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:easy_localization/easy_localization.dart';

class Functions {
  static Future<bool> getNetworkStatus({Duration duration}) async {
    await Future.delayed(duration ?? Duration(milliseconds: 300));
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static List<Product> modifyProducts(
      {@required List<Product> wishListProducts,
      @required List<Product> products}) {
    final wishListIds = wishListProducts.map((e) => e.id).toList();
    final List<Product> modifiedProducts = [];
    if (wishListIds.length < 1) {
      for (var product in products) {
        final newProduct = product.copyWith(isliked: false);
        modifiedProducts.add(newProduct);
      }
      return modifiedProducts;
    }
    for (var product in products) {
      Product newProduct;
      if (wishListIds.contains(product.id)) {
        newProduct = product.copyWith(isliked: true);
      } else {
        newProduct = product.copyWith(isliked: false);
      }
      modifiedProducts.add(newProduct);
    }
    return modifiedProducts;
  }

  static bool isLiked(Product product , List<Product> wishListProducts){
    final wishListIds = wishListProducts.map((e) => e.id).toList();
    if(wishListIds.contains(product.id)){
      return true ;
    }
    return false;
  }
  static void goToProductPage(BuildContext context, Product product) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProductDetailPage(product: product),
    ));
  }

  static SnackBar getSnackBar({String message, Duration duration}) {
    return SnackBar(
      duration: duration ?? Duration(seconds: 1),
      content: Text(message ?? 'snack_bar_message'.tr() + " !"),
      backgroundColor: LightColor.subTitleTextColor,
      behavior: SnackBarBehavior.floating,
    );
  }

  static void goToSignInPage(context) {
    final lastAccountPage = BlocProvider.of<PageBloc>(context).lastAccountPage;
    BlocProvider.of<PageBloc>(context).add(PageTransition(lastAccountPage));
    Scaffold.of(context).showSnackBar(Functions.getSnackBar(
        message: "should_login_first".tr(), duration: Duration(seconds: 2)));
  }
}
