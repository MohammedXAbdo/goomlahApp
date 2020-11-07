import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/orders_history/bloc/orders_bloc.dart';
import 'package:goomlah/presentation/profile/Auth_bloc/auth_bloc.dart';
import 'package:goomlah/presentation/widgets/icon_widget.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'bloc/page_bloc.dart';

class ApplicationTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppTheme.getPadding(context),
      child: BlocBuilder<PageBloc, PageState>(
        builder: (context, state) {
          if (state.pageType == PageType.categories ||
              state.pageType == PageType.subCategories ||
              state.pageType == PageType.profile) return SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              title(state.title.tr(), context),
              getTrailingIcon(context, state.pageType),
            ],
          );
        },
      ),
    );
  }

  Widget getTrailingIcon(context, PageType pageType) {
    if (pageType == PageType.cart &&
        BlocProvider.of<AuthBloc>(context).isAuthenticated == true) {
      return IconWidget(
        icon: Icons.history,
        color: LightColor.orange,
        onPressed: () {
          BlocProvider.of<OrdersBloc>(context).previousIsCart = true;
          BlocProvider.of<PageBloc>(context)
              .add(PageTransition(PageType.ordersHistory));
        },
      );
    } else if (pageType == PageType.ordersHistory) {
      return IconWidget(
        icon: Icons.shopping_cart,
        color: LightColor.orange,
        onPressed: () {
          BlocProvider.of<PageBloc>(context).add(PageTransition(PageType.cart));
        },
      );
    } else
      return SizedBox.shrink();
  }

  Widget title(String text, context) {
    bool isArabic = EasyLocalization.of(context).locale.languageCode == 'ar';
    return isArabic
        ? Text(text, style: TextsStyle.subTitle(context))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(getTitle(text), style: TextsStyle.pageTitle(context)),
              titleLength(text) <= 1
                  ? SizedBox.shrink()
                  : Text(getSubTitle(text),
                      style: TextsStyle.subTitle(context)),
            ],
          );
  }

  String getTitle(String text) {
    return text.split(' ')[0];
  }

  String getSubTitle(String text) {
    int firstWordlength = text.split(' ')[0].length;
    return text.substring(firstWordlength + 1);
  }

  int titleLength(String text) {
    return text.split(' ').length;
  }
}
