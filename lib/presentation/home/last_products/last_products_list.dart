import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/home/bloc/home_bloc.dart';
import 'package:goomlah/presentation/widgets/products_grid_view.dart';
import 'package:goomlah/presentation/wishlist/bloc/wish_list_bloc.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:goomlah/utils/functions/functions.dart';

import '../loading_porducts.dart';

class LastProductsList extends StatefulWidget {
  LastProductsList({Key key}) : super(key: key);

  @override
  _LastProductsListState createState() => _LastProductsListState();
}

class _LastProductsListState extends State<LastProductsList> {
  List<Product> products;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeblocState>(
      builder: (context, homeState) => handleBlocBuilder(homeState),
    );
  }

  Widget handleBlocBuilder(HomeblocState homeState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        homeState is HomeDataFailed ? SizedBox.shrink() : lastProductsTitle(),
        Container(
          height: AppTheme.fullHeight(context) * .26,
          child: LayoutBuilder(
            builder: (_, __) {
              if (homeState is HomeblocInitial ||
                  homeState is HomeDataLoading) {
                return LoadingProducts();
              } else if (homeState is HomeDataSucceed) {
                products = homeState.products;
                return BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, wishlistState) {
                    if (wishlistState is WishlistSucceed) {
                      final wishListProducts = wishlistState.products;
                      products = Functions.modifyProducts(
                          wishListProducts: wishListProducts,
                          products: products);
                      if (products.length < 1) {
                        return showNoProductMessage();
                      }
                      return ProductsGridView(products: products);
                    } else if (wishlistState is WishlistFailed) {
                      return ProductsGridView(products: products);
                    }
                    return LoadingProducts();
                  },
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget showNoProductMessage() {
    return Center(
        child: Text('empty_products'.tr() + ".",
            style: TextsStyle.noDataMessage(context)));
  }

  Widget lastProductsTitle() {
    return Padding(
      padding: AppTheme.getPadding(context),
      child: Text(
        'last_products'.tr(),
        style: TextsStyle.homeItem(context),
      ),
    );
  }
}
