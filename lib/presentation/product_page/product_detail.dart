import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/product_page/bloc/product_bloc.dart';
import 'package:goomlah/presentation/product_page/product_app_bar.dart';
import 'package:goomlah/presentation/product_page/product_header.dart';
import 'package:goomlah/presentation/product_page/scrollable_sheet.dart';
import 'package:goomlah/presentation/shopping_cart/bloc/cart_bloc.dart';
import 'package:goomlah/presentation/widgets/try_again.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/presentation/widgets/title_text.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  ProductDetailPage({Key key, @required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  Widget _availableColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _colorWidget(LightColor.yellowColor, isSelected: true),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.lightBlue),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.black),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.red),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.skyBlue),
          ],
        )
      ],
    );
  }

  Widget _colorWidget(Color color, {bool isSelected = false}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color.withAlpha(150),
      child: isSelected
          ? Icon(
              Icons.check_circle,
              color: color,
              size: 18,
            )
          : CircleAvatar(radius: 7, backgroundColor: color),
    );
  }

  bool addedToCart;

  @override
  void initState() {
    addedToCart = false;
    BlocProvider.of<CartBloc>(context).add(GetCartProducts());
    BlocProvider.of<ProductBloc>(context)
        .add(FetchProductData(id: widget.product.id));

    super.initState();
  }

  Product product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _flotingButton(),
      body: SafeArea(
        child: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductSucceed) {
              if (state.product.id == widget.product.id) {
                product = state.product;
              }
            } else if (state is ProductFailed) {
              Scaffold.of(context).showSnackBar(
                  Functions.getSnackBar(message: state.failure.code));
            }
          },
          builder: (context, state) {
            return product != null
                ? productDate(product)
                : state is ProductLoading
                    ? loadingWidget()
                    : state is ProductFailed
                        ? TryAgainButton(onPressed: () => tryAgainAction())
                        : SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return Center(
        child: CircularProgressIndicator(
      backgroundColor: LightColor.secondryColor,
    ));
  }

  void tryAgainAction() {
    BlocProvider.of<CartBloc>(context).add(GetCartProducts());
    BlocProvider.of<ProductBloc>(context)
        .add(FetchProductData(id: widget.product.id));
  }

  Widget productDate(Product product) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            ProcutAppBar(product: product),
            ProductHeader(product: product),
          ],
        ),
        ScrollableSheet(product: product)
      ],
    );
  }

  Widget _flotingButton() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return state is ProductSucceed
            ? BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartSucceed) {
                    if (state.itemsCount.keys
                        .contains(widget.product.id.toString())) {
                      addedToCart = true;
                    } else {
                      addedToCart = false;
                    }
                  }
                  return FloatingActionButton(
                    onPressed: () {
                      if (!addedToCart) {
                        BlocProvider.of<CartBloc>(context)
                            .add(AddToCart(product: widget.product));
                        Scaffold.of(context).showSnackBar(
                          Functions.getSnackBar(
                            duration: Duration(seconds: 2),
                            message: "added_to_cart".tr(),
                          ),
                        );
                      } else {
                        BlocProvider.of<PageBloc>(context)
                            .add(PageTransition(PageType.cart));
                        Navigator.pop(context);
                      }
                    },
                    backgroundColor: LightColor.orange,
                    child: addedToCart
                        ? Icon(Icons.shopping_cart)
                        : Icon(Icons.add_shopping_cart),
                  );
                },
              )
            : SizedBox.shrink();
      },
    );
  }
}
