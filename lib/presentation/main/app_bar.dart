import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/orders_history/bloc/orders_bloc.dart';
import 'package:goomlah/presentation/widgets/icon_widget.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class UpperAppBar extends StatefulWidget {
  UpperAppBar({
    Key key,
  }) : super(key: key);

  @override
  _UpperAppBarState createState() => _UpperAppBarState();
}

class _UpperAppBarState extends State<UpperAppBar> {
  bool isArabic = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    isArabic = EasyLocalization.of(context).locale.languageCode == 'ar';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.getPadding(context).copyWith(bottom: 0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<PageBloc, PageState>(
              builder: (context, state) {
                return RotatedBox(
                  quarterTurns: 4,
                  child: IconWidget(
                      icon: settingsIcon(state),
                      color: Colors.black54,
                      onPressed: () {
                        handleMenuButton(state);
                      }),
                );
              },
            ),
            appLogo(),
            RotatedBox(
              quarterTurns: 4,
              child: IconWidget(
                  icon: Icons.account_box,
                  color: LightColor.orange,
                  onPressed: () => handleProfileButton()),
            ),
          ],
        ),
      ),
    );
  }

  IconData settingsIcon(PageState state) {
    if (state is SubCategoriesPageState || state is PaymentPageState) {
      return Icons.arrow_back_ios;
    } else if (state is OrdersHistoryState &&
        BlocProvider.of<OrdersBloc>(context).previousIsCart) {
      return Icons.arrow_back_ios;
    }
    return Icons.sort;
  }

  Widget appLogo() {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: AppTheme.fullHeight(context) * 0.004),
        width: AppTheme.fullWidth(context) * 0.16,
        height: AppTheme.fullWidth(context) * 0.16,
        child: ClipRRect(
            borderRadius: AppTheme.getIconBorderRadius(context),
            child: Image.asset('assets/logo.jpg')));
  }

  void handleProfileButton() {
    if (!inAccountPage(context)) {
      final lastAccountPage =
          BlocProvider.of<PageBloc>(context).lastAccountPage;
      BlocProvider.of<PageBloc>(context).add(PageTransition(lastAccountPage));
    }
  }

  void handleMenuButton(PageState state) {
    if (state is SubCategoriesPageState) {
      if (context.bloc<PageBloc>().previousSubCategoryPages.isNotEmpty) {
        PageType previousPage =
            context.bloc<PageBloc>().previousSubCategoryPages.last;
        if (previousPage == PageType.home) {
          context.bloc<PageBloc>().add(PageTransition(PageType.home));
        } else {
          if (state.mainCategory != null) {
            BlocProvider.of<PageBloc>(context).add(GoToSubCategory(
                previousPage: previousPage, category: state.mainCategory));
          } else {
            BlocProvider.of<PageBloc>(context)
                .add(PageTransition(PageType.categories));
          }
        }
        context.bloc<PageBloc>().previousSubCategoryPages.removeLast();
      }
    } else if (state is PaymentPageState) {
      context.bloc<PageBloc>().add(PageTransition(PageType.cart));
    } else if (state is OrdersHistoryState &&
        BlocProvider.of<OrdersBloc>(context).previousIsCart) {
      context.bloc<PageBloc>().add(PageTransition(PageType.cart));
    } else {
      Scaffold.of(context).openDrawer();
    }
  }

  bool inAccountPage(BuildContext context) {
    final type = BlocProvider.of<PageBloc>(context).state.pageType;
    final accountPages = [
      PageType.profile,
      PageType.verfication,
      PageType.signUp,
      PageType.signIn
    ];
    for (var pageType in accountPages) {
      if (type == pageType) {
        return true;
      }
    }
    return false;
  }
}
