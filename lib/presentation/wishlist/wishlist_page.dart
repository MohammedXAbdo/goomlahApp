import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/widgets/icon_widget.dart';
import 'package:goomlah/presentation/widgets/product_row_item.dart';
import 'package:goomlah/presentation/wishlist/bloc/wish_list_bloc.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key key}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Product> products;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.padding.copyWith(
        bottom: 0,
        right: AppTheme.fullWidth(context) * 0.01,
      ),
      child:
          BlocConsumer<WishlistBloc, WishlistState>(listener: (context, state) {
        if (state is WishlistSucceed) {
          products = state.products;
        }
      }, builder: (context, state) {
        if (state is WishlistSucceed) {
          products = state.products;
        }
        if (products != null) {
          return getProducts(products);
        } else if (state is WishlistLoading) {
          return loadingProgress();
        } else {
          return SizedBox.shrink();
        }
      }),
    );
  }

  Widget getProducts(List<Product> products) {
    if (products.length < 1) {
      return emptyMessage();
    }
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductRowItem(
          product: products[index],
          trailing: (product) => favoriteIcon(product),
        );
      },
    );
  }

  Widget favoriteIcon(product) {
    return IconWidget(
      icon: Icons.favorite,
      color: Colors.red,
      size: AppTheme.fullWidth(context) * 0.05,
      onPressed: () {
        BlocProvider.of<WishlistBloc>(context)
            .add(RemoveFromWishlist(product: product));
      },
    );
  }

  Widget emptyMessage() {
    return Center(
        child: Text('empty_wish_list'.tr() + ".",
            style: TextsStyle.noDataMessage(context)));
  }

  Widget loadingProgress() {
    return Center(
        child: CircularProgressIndicator(backgroundColor: LightColor.orange));
  }
}
