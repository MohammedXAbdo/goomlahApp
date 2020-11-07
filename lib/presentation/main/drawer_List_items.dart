import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/Register/bloc/account_bloc.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/orders_history/bloc/orders_bloc.dart';
import 'package:goomlah/presentation/profile/Auth_bloc/auth_bloc.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/presentation/widgets/extentions.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerListItems extends StatelessWidget {
  const DrawerListItems({
    Key key,
    @required this.pageType,
  }) : super(key: key);

  final PageType pageType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      final bool isAuthenticated = state is IsAuthenticatedState;
      return ListView(
        children: [
          Center(
            child: Text('app_title'.tr(), style: TextsStyle.appTitle(context)),
          ).addPadding(
            padding: EdgeInsets.only(
                top: AppTheme.fullHeight(context) * 0.1,
                bottom: AppTheme.fullHeight(context) * 0.025),
          ),
          Divider(),
          CustomListTile(
            itemTitle: "home".tr(),
            icon: Icons.home,
            currentPage: pageType,
            iconPage: PageType.home,
            onPressed: () {
              Navigator.pop(context);
              if (!(pageType == PageType.home))
                BlocProvider.of<PageBloc>(context)
                    .add(PageTransition(PageType.home));
            },
          ),
          Divider(),
          CustomListTile(
            itemTitle: "categories".tr(),
            icon: Icons.apps,
            currentPage: pageType,
            iconPage: PageType.categories,
            onPressed: () {
              Navigator.pop(context);
              if (!(pageType == PageType.categories))
                BlocProvider.of<PageBloc>(context)
                    .add(PageTransition(PageType.categories));
            },
          ),
          Divider(),
          CustomListTile(
            itemTitle: "shopping_cart".tr(),
            icon: Icons.shopping_cart,
            currentPage: pageType,
            iconPage: PageType.cart,
            onPressed: () {
              Navigator.pop(context);
              if (!(pageType == PageType.cart))
                BlocProvider.of<PageBloc>(context)
                    .add(PageTransition(PageType.cart));
            },
          ),
          Divider(),
          if (isAuthenticated) ...[
            CustomListTile(
              itemTitle: "my_profile".tr(),
              icon: Icons.account_circle,
              currentPage: pageType,
              iconPage: PageType.profile,
              onPressed: () {
                Navigator.pop(context);
                if (!(pageType == PageType.profile))
                  BlocProvider.of<PageBloc>(context)
                      .add(PageTransition(PageType.profile));
              },
            ),
            Divider(),
            CustomListTile(
              itemTitle: "orders_history".tr(),
              icon: Icons.history,
              currentPage: pageType,
              iconPage: PageType.ordersHistory,
              onPressed: () {
                Navigator.pop(context);
                if (!(pageType == PageType.ordersHistory)) {
                  BlocProvider.of<OrdersBloc>(context).previousIsCart = false;
                  BlocProvider.of<PageBloc>(context)
                      .add(PageTransition(PageType.ordersHistory));
                }
              },
            ),
            Divider(),
            CustomListTile(
              itemTitle: "log_out".tr(),
              icon: Icons.exit_to_app,
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<AccountBloc>(context).add(LogoutEvent());
              },
            )
          ],
          if (!isAuthenticated) ...[
            CustomListTile(
              itemTitle: "login".tr(),
              currentPage: pageType,
              iconPage: PageType.signIn,
              icon: Icons.account_box,
              onPressed: () {
                Navigator.pop(context);
                if (!(pageType == PageType.signIn))
                  BlocProvider.of<PageBloc>(context)
                      .add(PageTransition(PageType.signIn));
              },
            )
          ]
        ],
      );
    });
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String itemTitle;
  final double fontSize;
  final Color fontColor;
  final Function onPressed;
  final PageType iconPage;
  final PageType currentPage;
  const CustomListTile(
      {Key key,
      this.icon,
      this.iconColor,
      this.itemTitle,
      this.fontSize,
      this.fontColor,
      this.onPressed,
      this.iconPage,
      this.currentPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon ?? Icons.ac_unit,
        color: iconPage == null
            ? Colors.black54
            : iconPage == currentPage
                ? LightColor.orange
                : Colors.black54,
      ),
      title: Text(
        itemTitle,
        style: TextStyle(
          fontSize: fontSize ?? AppTheme.fullHeight(context) * 0.019,
          color: iconPage == null
              ? LightColor.menuTextColor
              : iconPage == currentPage
                  ? LightColor.orange
                  : LightColor.menuTextColor,
        ),
      ),
    ).ripple(() {
      if (onPressed != null) {
        onPressed();
      }
    });
  }
}
