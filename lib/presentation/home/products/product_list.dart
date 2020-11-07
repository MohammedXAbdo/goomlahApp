import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/home/bloc/home_bloc.dart';
import 'package:goomlah/presentation/home/products/home_products_bloc/products_bloc.dart';
import 'package:goomlah/presentation/widgets/products_grid_view.dart';
import 'package:goomlah/presentation/widgets/try_again.dart';
import 'package:goomlah/presentation/wishlist/bloc/wish_list_bloc.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:easy_localization/easy_localization.dart';

import '../loading_porducts.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({
    Key key,
  }) : super(key: key);
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  int selectedIndex = 0;
  List<Product> products;
  int savedCategoryId = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppTheme.fullHeight(context) * 0.013,
        ),
        child: Container(
          height: AppTheme.fullHeight(context) * .26,
          child: BlocConsumer<HomeBloc, HomeblocState>(
              listener: (context, homeState) =>
                  hanldleCategoryBlocListener(homeState),
              builder: (context, homeState) =>
                  hanldleCategoryBlocBuilder(homeState)),
        ));
  }

  void hanldleCategoryBlocListener(HomeblocState state) {
    if (state is HomeDataFailed) {
      Scaffold.of(context)
          .showSnackBar(Functions.getSnackBar(message: state.failure.code));
    }
  }

  Widget hanldleCategoryBlocBuilder(HomeblocState homeState) {
    return BlocConsumer<HomeProductsBloc, HomeProductsState>(
      listener: (context, state) => handleProductBlocListener(state),
      builder: (context, state) => hanldeProductBlocBuilder(state, homeState),
    );
  }

  Widget hanldeProductBlocBuilder(
      HomeProductsState state, HomeblocState homeState) {
    if (homeState is HomeDataFailed) {
      return TryAgainButton(onPressed: () => loadHomeData());
    }
    if (homeState is HomeblocInitial ||
        homeState is HomeDataLoading ||
        state is CategoryProductsLoading) {
      selectedIndex = 0;
      return LoadingProducts();
    } else if (state is CategoryProductsSucceed) {
      products = state.products;
      return BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, wishlistState) {
          if (wishlistState is WishlistSucceed) {
            final wishListProducts = wishlistState.products;
            products = Functions.modifyProducts(
                wishListProducts: wishListProducts, products: products);
            if (products.length < 1) {
              return showNoProductMessage();
            }
            return ProductsGridView(products: products);
          }
          return LoadingProducts();
        },
      );
    } else if (state is CategoryProductsFailed) {
      return TryAgainButton(onPressed: () => loadCategoryProducts());
    } else if (homeState is HomeDataSucceed) {
      if (homeState.subCategories.length < 1) {
        return showNoProductMessage();
      }
    }
    return SizedBox.shrink();
  }

  void handleProductBlocListener(HomeProductsState state) {
    if (state is CategoryProductsLoading) {
      savedCategoryId = state.categoryId;
    }
    if (state is CategoryProductsFailed) {
      Scaffold.of(context)
          .showSnackBar(Functions.getSnackBar(message: state.failure.code));
    }
  }

  Widget showNoProductMessage() {
    return Center(
        child: Text('empty_products'.tr(),
            style: TextsStyle.noDataMessage(context)));
  }

  void loadCategoryProducts() {
    BlocProvider.of<HomeProductsBloc>(context)
        .add(FetchingCategoryProducts(categoryId: savedCategoryId));
  }

  void loadHomeData() {
    BlocProvider.of<HomeBloc>(context).add(FetchHomeData());
  }
}
