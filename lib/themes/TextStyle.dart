import 'package:flutter/material.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';

class TextsStyle {
  static appTitle(context) {
    return TextStyle(
      fontFamily: 'Tajawal',
      fontSize: AppTheme.fullHeight(context) * 0.028,
      fontWeight: FontWeight.w500,
      color: LightColor.tiraryColor,
    );
  }

  static productCardName(context) {
    return TextStyle(
        color: LightColor.tiraryColor,
        fontWeight: FontWeight.w400,
        fontSize: AppTheme.fullHeight(context) * 0.017);
  }

  static productWishlistName(context) {
    return TextStyle(
        color: LightColor.tiraryColor,
        fontWeight: FontWeight.w600,
        fontSize: AppTheme.fullHeight(context) * 0.017);
  }

  static productWishlistPrice(context) {
    return TextStyle(
        color: LightColor.tiraryColor,
        fontWeight: FontWeight.w600,
        fontSize: AppTheme.fullHeight(context) * 0.018);
  }

  static orderCount(context) {
    return TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w600,
        fontSize: AppTheme.fullHeight(context) * 0.016);
  }

  static productWishlistSign(context) {
    return TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w600,
        fontSize: AppTheme.fullHeight(context) * 0.017);
  }

  static productCardPrice(context) {
    return TextStyle(
        color: LightColor.tiraryColor,
        fontWeight: FontWeight.w700,
        fontSize: AppTheme.fullHeight(context) * 0.018);
  }

  static productCardSign(context) {
    return TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w600,
        fontSize: AppTheme.fullHeight(context) * 0.018);
  }

  static pageTitle(context) {
    return TextStyle(
      color: LightColor.tiraryColor,
      fontSize: AppTheme.fullHeight(context) * 0.022,
      fontWeight: FontWeight.w400,
    );
  }

  static subTitle(context) {
    return TextStyle(
      fontSize: AppTheme.fullHeight(context) * 0.022,
      fontWeight: FontWeight.w700,
      color: LightColor.tiraryColor,
    );
  }

  static categoriesItem(context) {
    return TextStyle(
      color: LightColor.tiraryColor,
      fontSize: AppTheme.fullHeight(context) * 0.019,
      fontWeight: FontWeight.w400,
    );
  }

  static homeItem(context) {
    return TextStyle(
      color: LightColor.tiraryColor,
      fontSize: AppTheme.fullHeight(context) * 0.018,
      fontWeight: FontWeight.w600,
    );
  }

  static seeMore(context) {
    return TextStyle(
      color: LightColor.orange,
      fontSize: AppTheme.fullHeight(context) * 0.016,
      fontWeight: FontWeight.w600,
    );
  }

  static productPageName(context) {
    return TextStyle(
      fontSize: AppTheme.fullHeight(context) * 0.03,
      fontWeight: FontWeight.w900,
      color: LightColor.tiraryColor,
    );
  }

  static productPageItem(context) {
    return TextStyle(
        fontSize: AppTheme.fullHeight(context) * 0.018,
        fontWeight: FontWeight.w800,
        color: LightColor.tiraryColor);
  }

  static productPageDescription(context) {
    return TextStyle(
        fontSize: AppTheme.fullHeight(context) * 0.017,
        color: LightColor.tiraryColor);
  }

  static productPagePrice(context) {
    return TextStyle(
        color: LightColor.tiraryColor,
        fontWeight: FontWeight.w800,
        fontSize: AppTheme.fullHeight(context) * 0.025);
  }

  static productPageDolar(context) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: AppTheme.fullHeight(context) * 0.021,
      color: Colors.red,
    );
  }

  static categoryDescription(context) {
    return TextStyle(
        fontSize: AppTheme.fullHeight(context) * 0.017,
        fontWeight: FontWeight.w400,
        color: Colors.black.withOpacity(0.7));
  }

  static categoryIconName(context) {
    return TextStyle(
      color: LightColor.tiraryColor,
      fontWeight: FontWeight.w600,
      fontSize: AppTheme.fullHeight(context) * 0.016,
    );
  }

  static noDataMessage(context) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: AppTheme.fullHeight(context) * 0.016,
    );
  }

  static errorMessage(context) {
    return TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w500,
      fontSize: AppTheme.fullHeight(context) * 0.021,
    );
  }

  static selectedPaymentListItem(context) {
    return TextStyle(
        color: LightColor.orange,
        fontWeight: FontWeight.w600,
        fontSize: AppTheme.fullHeight(context) * 0.017);
  }

  static unSelectedPaymentListItem(context) {
    return TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w600,
        fontSize: AppTheme.fullHeight(context) * 0.017);
  }
}
