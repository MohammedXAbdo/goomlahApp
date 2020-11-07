import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/widgets/icon_widget.dart';
import 'package:goomlah/presentation/wishlist/bloc/wish_list_bloc.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/utils/functions/functions.dart';

class ProcutAppBar extends StatefulWidget {
  const ProcutAppBar({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProcutAppBarState createState() => _ProcutAppBarState();
}

class _ProcutAppBarState extends State<ProcutAppBar> {
  bool isliked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.getPadding(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconWidget(
            icon: Icons.arrow_back_ios,
            color: Colors.black54,
            size: AppTheme.fullWidth(context) * 0.045,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              if (state is WishlistSucceed) {
                isliked = Functions.isLiked(widget.product, state.products);
              }
              return IconWidget(
                icon: isliked ? Icons.favorite : Icons.favorite_border,
                color: isliked ? Colors.red : LightColor.lightGrey,
                size: AppTheme.fullWidth(context) * 0.05,
                onPressed: () {
                  if (isliked) {
                    BlocProvider.of<WishlistBloc>(context)
                        .add(RemoveFromWishlist(product: widget.product));
                  } else {
                    BlocProvider.of<WishlistBloc>(context)
                        .add(AddToWishlist(product: widget.product));
                  }

                  setState(() {
                    isliked = !isliked;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
