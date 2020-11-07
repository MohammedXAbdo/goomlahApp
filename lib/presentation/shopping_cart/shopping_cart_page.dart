import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/shopping_cart/bloc/cart_bloc.dart';
import 'package:goomlah/presentation/shopping_cart/products_shooping_list.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:easy_localization/easy_localization.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key key}) : super(key: key);

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Product> products;
  Map<String, int> itemsCount;

  @override
  void initState() {
    BlocProvider.of<CartBloc>(context).add(GetCartProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is CartSucceed) {
          products = state.products;
          itemsCount = state.itemsCount;
          return getProducts(products, itemsCount);
        } else if (state is CartLoading) {
          return loadingProgress();
        } else if (products != null && itemsCount != null) {
          return getProducts(products, itemsCount);
        } else {
          return SizedBox.shrink();
        }
      },
    ));
  }

  Widget getProducts(List<Product> products, Map<String, int> itemsCount) {
    if (products.length < 1) {
      return emptyMessage();
    }
    return ProductsShoppingList(products: products, itemsCount: itemsCount);
  }

  Widget emptyMessage() {
    return Center(
        child: Text('empty_cart'.tr() + ".",
            style: TextsStyle.noDataMessage(context)));
  }

  Widget loadingProgress() {
    return Center(
        child: CircularProgressIndicator(
            backgroundColor: LightColor.secondryColor));
  }
}
