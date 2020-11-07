import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/Register/verification/Verification.dart';
import 'package:goomlah/presentation/Register/login.dart';
import 'package:goomlah/presentation/Register/register.dart';
import 'package:goomlah/presentation/categories/main_categories/main_categories_settings.dart';
import 'package:goomlah/presentation/categories/sub_categories/sub_categories_settings.dart';
import 'package:goomlah/presentation/home/home_page.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/orders_history/orders_history_page.dart';
import 'package:goomlah/presentation/profile/Auth_bloc/auth_bloc.dart';
import 'package:goomlah/presentation/profile/profile.dart';
import 'package:goomlah/presentation/profile/profilePage.dart';
import 'package:goomlah/presentation/shopping_cart/payment_page.dart';
import 'package:goomlah/presentation/shopping_cart/shopping_cart_page.dart';
import 'package:goomlah/presentation/wishlist/wishlist_page.dart';

class MainPageBody extends StatefulWidget {
  const MainPageBody({Key key}) : super(key: key);

  @override
  _MainPageBodyState createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<MainPageBody> {
  List<Widget> stackChildren = [
    MyHomePage(),
    ShoppingCartPage(),
    WishlistPage(),
    Login(),
    Register(),
  ];
  int subCategoryid;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) => handleAuthState(state),
      child: BlocConsumer<PageBloc, PageState>(
        listener: (context, state) => handlePageListener(state),
        builder: (context, state) {
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              switchInCurve: Curves.easeInToLinear,
              switchOutCurve: Curves.easeOutBack,
              child: getWidget(state));
        },
      ),
    );
  }

  void handlePageListener(PageState state) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void handleAuthState(AuthState state) {
    if (state is IsAuthenticatedState) {
      context.bloc<PageBloc>().setLastAccountPage(PageType.profile);
    } else if (state is NotAuthenticatedState) {
      int profileIndex = presentInStack<ProfilePage>();
      int loginPageIndex = presentInStack<Login>();
      if (profileIndex != -1) {
        stackChildren.removeAt(profileIndex);
      }
      if (loginPageIndex != -1) {
        stackChildren.removeAt(loginPageIndex);
      }
      stackChildren.add(Login(key: GlobalKey()));

      context.bloc<PageBloc>().setLastAccountPage(PageType.signIn);
    }
  }

  Widget getWidget(PageState pageType) {
    int index = 0;
    if (pageType is HomePageState) {
      index = presentInStack<MyHomePage>();
    } else if (pageType is CartPageState) {
      removePaymentPage();
      index = presentInStack<ShoppingCartPage>();
    } else if (pageType is OrdersHistoryState) {
      int ordersPageindex = presentInStack<OrdersHistoryPage>();
      if (ordersPageindex != -1) {
        stackChildren.removeAt(ordersPageindex);
      }
      stackChildren.add(OrdersHistoryPage(key: GlobalKey()));
      index = stackChildren.length - 1;
    } else if (pageType is PaymentPageState) {
      removePaymentPage();
      stackChildren.add(PaymentPage(
        key: GlobalKey(),
        itemsCount: pageType.itemsCount,
        totalPrice: pageType.totalPrice,
      ));
      index = stackChildren.length - 1;
    } else if (pageType is WishlistPageState) {
      index = presentInStack<WishlistPage>();
    } else if (pageType is SignInPageState) {
      index = presentInStack<Login>();
    } else if (pageType is SignUpPageState) {
      index = presentInStack<Register>();
    } else if (pageType is VerificationPageState) {
      print("go to  VerificationPageState");
      removeVerificationPage();
      stackChildren.add(Verification(key: GlobalKey()));
      index = stackChildren.length - 1;
    } else if (pageType is ProfilePageState) {
      index = presentInStack<ProfilePage>();
      if (index == -1) {
        stackChildren.add(ProfilePage(key: GlobalKey()));
        index = stackChildren.length - 1;
      }
    } else if (pageType is CategoriesPageState) {
      index = presentInStack<MainCategoriesSettings>();
      if (index == -1) {
        stackChildren.add(MainCategoriesSettings(key: GlobalKey()));
        index = stackChildren.length - 1;
      }
    } else if (pageType is SubCategoriesPageState) {
      index = setSubCategoryPage(pageType);
    }
    if (index == -1) {
      index = 0;
    }
    return IndexedStack(index: index, children: stackChildren);
  }

  int presentInStack<T>() {
    for (int i = 0; i < stackChildren.length; i++) {
      if (stackChildren[i] is T) {
        return i;
      }
    }
    return -1;
  }

  void removeVerificationPage() {
    int verifyPageIndex = presentInStack<Verification>();
    if (verifyPageIndex != -1) {
      stackChildren.removeAt(verifyPageIndex);
    }
  }

  void removePaymentPage() {
    int paymentPageIndex = presentInStack<PaymentPage>();
    if (paymentPageIndex != -1) {
      stackChildren.removeAt(paymentPageIndex);
    }
  }

  int setSubCategoryPage(SubCategoriesPageState pageType) {
    int index = presentInStack<SubCategoriesSettings>();
    if (index == -1) {
      subCategoryid = pageType.category.id;
      stackChildren.add(
          SubCategoriesSettings(key: GlobalKey(), category: pageType.category));
      return stackChildren.length - 1;
    } else {
      if (subCategoryid != pageType.category.id) {
        stackChildren.removeAt(index);
        stackChildren.add(SubCategoriesSettings(
            key: GlobalKey(), category: pageType.category));
        subCategoryid = pageType.category.id;
        return stackChildren.length - 1;
      }
    }
    return index;
  }
}
