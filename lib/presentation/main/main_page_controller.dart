import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/Register/bloc/account_bloc.dart';
import 'package:goomlah/presentation/home/bloc/home_bloc.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/main/main_widgets.dart';
import 'package:goomlah/presentation/profile/Auth_bloc/auth_bloc.dart';
import 'package:goomlah/presentation/wishlist/bloc/wish_list_bloc.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/presentation/widgets/extentions.dart';

import 'app_drawer.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    BlocProvider.of<WishlistBloc>(context).add(GetWishlistProducts());
    BlocProvider.of<HomeBloc>(context).add(FetchHomeData());
    BlocProvider.of<AuthBloc>(context).add(CheckAuthEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onPop(context);
      },
      child: Scaffold(
        drawer: AppDrawer(),
        body: Stack(
          children: [
            MainWidgets(key: GlobalKey()),
            showLoadingWidget(),
          ],
        ).addGradiant(),
      ),
    );
  }

  Widget showLoadingWidget() {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is Loading) {
          return Center(
              child: CircularProgressIndicator(
                  backgroundColor: LightColor.secondryColor));
        }
        return SizedBox.shrink();
      },
    );
  }

  bool onPop(BuildContext context) {
    final pageState = BlocProvider.of<PageBloc>(context).state;
    if (pageState.pageType == PageType.verfication) {
      context.bloc<PageBloc>().add(PageTransition(PageType.signUp));
      return false;
    } else if (pageState.pageType == PageType.payment) {
      context.bloc<PageBloc>().add(PageTransition(PageType.cart));
      return false;
    } else if (pageState is SubCategoriesPageState) {
      if (pageState.mainCategory == null) {
        context.bloc<PageBloc>().add(PageTransition(PageType.categories));
      } else {
        BlocProvider.of<PageBloc>(context).add(GoToSubCategory(
            previousPage: PageType.categories,
            category: pageState.mainCategory));
      }
      return false;
    } else if (pageState.pageType != PageType.home) {
      context.bloc<PageBloc>().add(PageTransition(PageType.home));
      return false;
    }

    return true;
  }
}
