import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:goomlah/model/category.dart';
import 'package:meta/meta.dart';

part 'page_event.dart';
part 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc() : super(HomePageState());

  PageType _lastAccountPage = PageType.signIn;

  PageType get lastAccountPage => _lastAccountPage;

  void setLastAccountPage(PageType pageType) {
    _lastAccountPage = pageType;
  }

  PageState _lastCartPage = CartPageState();

  PageState get lastCartPage => _lastCartPage;

  void setLastCartPage(PageState pageState) {
    _lastCartPage = pageState;
  }

  List<PageType> previousSubCategoryPages = [];
  @override
  Stream<PageState> mapEventToState(
    PageEvent event,
  ) async* {
    if (event is PageTransition) {
      yield* handleTransitionEvent(event);
    } else if (event is GoToPayment) {
      yield PageLoading();
      final paymentPage = PaymentPageState(
        itemsCount: event.itemsCount,
        totalPrice: event.totalPrice,
      );
      yield paymentPage;
      _lastCartPage = paymentPage;
    } else if (event is GoToSubCategory) {
      yield PageLoading();
      yield SubCategoriesPageState(
          category: event.category,
          mainCategory: event.mainCategory,
          previousPage: event.previousPage);
    }
  }

  Stream<PageState> handleTransitionEvent(PageTransition event) async* {
    yield PageLoading();
    switch (event.pageType) {
      case PageType.home:
        yield HomePageState();
        break;
      case PageType.cart:
        yield CartPageState();
        _lastCartPage = CartPageState();
        break;
      case PageType.ordersHistory:
        yield OrdersHistoryState();
        break;
      case PageType.signIn:
        yield SignInPageState();
        _lastAccountPage = event.pageType;
        break;
      case PageType.signUp:
        _lastAccountPage = event.pageType;

        yield SignUpPageState();
        break;
      case PageType.profile:
        _lastAccountPage = event.pageType;

        yield ProfilePageState();
        break;
      case PageType.wishlist:
        yield WishlistPageState();
        break;
      case PageType.product:
        yield ProductPageState();
        break;
      case PageType.verfication:
        _lastAccountPage = event.pageType;
        yield VerificationPageState();
        break;
      case PageType.categories:
        yield CategoriesPageState();
        break;
      case PageType.subCategories:
        // yield SubCategoriesPageState(
        //     category: event.category, mainCategory: event.mainCategory);
        break;
      default:
    }
  }
}

enum PageType {
  home,
  cart,
  payment,
  wishlist,
  profile,
  signIn,
  signUp,
  product,
  verfication,
  categories,
  subCategories,
  ordersHistory,
}
