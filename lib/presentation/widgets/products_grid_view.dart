import 'package:flutter/material.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/widgets/product_card.dart';
import 'package:goomlah/themes/theme.dart';

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({
    Key key,
    @required this.products,
    this.padding,
    this.scrollDirection,
    this.sliverGridDelegate,
    this.shrinkWrap = false,
    this.physics,
  }) : super(key: key);
  final ScrollPhysics physics;
  final List<Product> products;
  final EdgeInsetsGeometry padding;
  final Axis scrollDirection;
  final SliverGridDelegate sliverGridDelegate;
  final bool shrinkWrap;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: AppTheme.fullWidth(context) * 0.02,
          ),
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
      itemCount: products.length,
      gridDelegate: sliverGridDelegate ??
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 4 / 2.8,
            mainAxisSpacing: AppTheme.fullWidth(context) * 0.025,
          ),
      scrollDirection: scrollDirection ?? Axis.horizontal,
    );
  }
}
