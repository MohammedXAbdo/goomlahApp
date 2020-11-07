import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/shopping_cart/bloc/cart_bloc.dart';
import 'package:goomlah/presentation/widgets/icon_widget.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';

class CountIcons extends StatefulWidget {
  const CountIcons({
    Key key,
    @required this.product,
    @required this.count,
  }) : super(key: key);
  final Product product;
  final int count;

  @override
  _CountIconsState createState() => _CountIconsState();
}

class _CountIconsState extends State<CountIcons> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconWidget(
          nonIconWidget: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppTheme.fullWidth(context) * 0.005),
            child: Text(
              "+" + "${widget.count}",
              style: TextsStyle.productWishlistPrice(context),
            ),
          ),
          color: Colors.red,
          onPressed: () {
            BlocProvider.of<CartBloc>(context)
                .add(IncreaseProductCount(product: widget.product));
          },
        ),
        SizedBox(width: AppTheme.fullWidth(context) * 0.03),
        IconWidget(
          icon: widget.count > 1 ? Icons.remove_circle : Icons.delete,
          color:widget.count > 1 ?LightColor.orange :Colors.red,
          size: AppTheme.fullWidth(context) * 0.05,
          onPressed: () {
            if (widget.count > 1) {
              BlocProvider.of<CartBloc>(context)
                  .add(DecreaseProductCount(product: widget.product));
            } else {
              BlocProvider.of<CartBloc>(context)
                  .add(RemoveFromCart(product: widget.product));
            }
          },
        )
      ],
    );
  }
}
