part of 'page_bloc.dart';

@immutable
abstract class PageState {
  final String title = '';
  final PageType pageType = PageType.home;
}

class PageLoading extends PageState {}

class HomePageState extends PageState {
  final String title = 'our_products';
  final PageType pageType = PageType.home;
}

class CartPageState extends PageState {
  final String title = 'shopping_cart';

  final PageType pageType = PageType.cart;
}

class OrdersHistoryState extends PageState {
  final String title = 'orders_history';

  final PageType pageType = PageType.ordersHistory;
}

class PaymentPageState extends PageState {
  final String title = 'choose_payment';
  final PageType pageType = PageType.payment;
  final Map<String, int> itemsCount;
  final double totalPrice;

  PaymentPageState({@required this.itemsCount, @required this.totalPrice});
}

class WishlistPageState extends PageState {
  final String title = 'your_wishlist';

  final PageType pageType = PageType.wishlist;
}

class SignInPageState extends PageState {
  final String title = 'welcome_back';
  final PageType pageType = PageType.signIn;
}

class SignUpPageState extends PageState {
  final String title = 'register_now';
  final PageType pageType = PageType.signUp;
}

class VerificationPageState extends PageState {
  final String title = 'enter_verification_code';

  final PageType pageType = PageType.verfication;
}

class ProductPageState extends PageState {
  final String title = 'our_products'.tr();

  final PageType pageType = PageType.product;
}

class ProfilePageState extends PageState {
  final String title = 'my_profile';

  final PageType pageType = PageType.profile;
}

class CategoriesPageState extends PageState {
  final String title = 'all_categories';

  final PageType pageType = PageType.categories;
}

class SubCategoriesPageState extends PageState {
  final Category category;
  final Category mainCategory;
  final String title = 'sub_categories';
  final PageType pageType = PageType.subCategories;
  final PageType previousPage;

  SubCategoriesPageState(
      {this.mainCategory, this.previousPage, @required this.category});
}
