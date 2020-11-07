import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/profile/Auth_bloc/auth_bloc.dart';
import 'package:goomlah/presentation/shopping_cart/confirm_button.dart';
import 'package:goomlah/presentation/shopping_cart/count_icons.dart';
import 'package:goomlah/presentation/widgets/product_row_item.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/utils/functions/functions.dart';

class ProductsShoppingList extends StatelessWidget {
  const ProductsShoppingList({
    Key key,
    @required this.products,
    @required this.itemsCount,
  }) : super(key: key);

  final List<Product> products;
  final Map<String, int> itemsCount;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: AppTheme.getPadding(context)
                .copyWith(bottom: 0, right: AppTheme.fullWidth(context) * 0.01),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductRowItem(
                  product: products[index],
                  trailing: (product) => CountIcons(
                    product: product,
                    count: itemsCount[product.id.toString()],
                  ),
                );
              },
            ),
          ),
        ),
        ConfirmPaymentButton(
          itemsCount: itemsCount,
          totalPrice: getTotalPrice(itemsCount, products),
          totalCount: getTotalCount(itemsCount),
          onPressed: () => handleConfirmButton(
              context, itemsCount, getTotalPrice(itemsCount, products)),
        )
      ],
    );
  }

  void handleConfirmButton(
      BuildContext context, Map<String, int> itemsCount, double totalPrice) {
    if (BlocProvider.of<AuthBloc>(context).isAuthenticated == true) {
      goToPaymentPage(context, itemsCount, totalPrice);
    } else {
      Functions.goToSignInPage(context);
    }
  }

  void goToPaymentPage(
      BuildContext context, Map<String, int> itemsCount, double totalPrice) {
    BlocProvider.of<PageBloc>(context)
        .add(GoToPayment(itemsCount: itemsCount, totalPrice: totalPrice));
  }

  int getTotalCount(Map<String, int> countMap) {
    int total = 0;
    for (var count in countMap.values) {
      total += count;
    }
    return total;
  }

  double getTotalPrice(Map<String, int> countMap, List<Product> products) {
    double total = 0;
    for (var product in products) {
      double price = countMap[product.id.toString()].toDouble() * product.price;
      total += price;
    }
    return total;
  }
}
