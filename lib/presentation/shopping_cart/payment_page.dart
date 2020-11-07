import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/profile/Auth_bloc/auth_bloc.dart';
import 'package:goomlah/presentation/shopping_cart/bloc/cart_bloc.dart';
import 'package:goomlah/presentation/shopping_cart/confirm_button.dart';
import 'package:goomlah/presentation/widgets/input_filed.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:goomlah/utils/functions/functions.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, int> itemsCount;
  final double totalPrice;

  const PaymentPage({
    Key key,
    @required this.itemsCount,
    @required this.totalPrice,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<String> options = ['cache_on_delivery'.tr()];
  int selectedMethod = 0;
  String address = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.fullWidth(context) * 0.0,
        vertical: AppTheme.fullHeight(context) * 0.0,
      ),
      child: BlocConsumer<CartBloc, CartState>(listener: (context, state) {
        if (state is PaymentFailed) {
          Scaffold.of(context).showSnackBar(Functions.getSnackBar(
              message: state.failure.code, duration: Duration(seconds: 2)));
        } else if (state is PaymentSucceed) {
          BlocProvider.of<PageBloc>(context)
              .add(PageTransition(PageType.ordersHistory));
          BlocProvider.of<PageBloc>(context).setLastCartPage(CartPageState());
          Scaffold.of(context).showSnackBar(Functions.getSnackBar(
              message: "success_payment".tr() + ".",
              duration: Duration(seconds: 3)));
        }
      }, builder: (context, state) {
        return AbsorbPointer(
          absorbing: state is PaymentLoading,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.fullWidth(context) * 0.2,
                      vertical: AppTheme.fullHeight(context) * 0.01,
                    ),
                    child: RadioListTile(
                      value: 0,
                      groupValue: selectedMethod,
                      title: Text(options[0]),
                      onChanged: (newValue) {
                        setState(() {
                          selectedMethod = newValue;
                        });
                      },
                      selected: selectedMethod == 0,
                      activeColor: LightColor.orange,
                    ),
                  ),
                  Padding(
                    padding: AppTheme.getPadding(context).copyWith(top: 0),
                    child: Row(
                      children: [
                        Text(
                          "additional_address".tr(),
                          style: TextsStyle.homeItem(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppTheme.fullHeight(context) * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.fullWidth(context) * 0.1),
                    child: InputField(
                      onSaved: (value) => address = value,
                      textInputAction: TextInputAction.next,
                      hintText: 'add_address'.tr(),
                      perfixIcon: Icons.location_on,
                    ),
                  ),
                  SizedBox(height: AppTheme.fullHeight(context) * 0.03),
                  ConfirmPaymentButton(
                    itemsCount: widget.itemsCount,
                    totalPrice: widget.totalPrice,
                    totalCount: getTotalCount(widget.itemsCount),
                    onPressed: () {
                      if (BlocProvider.of<AuthBloc>(context).isAuthenticated ==
                          true) {
                        BlocProvider.of<CartBloc>(context).add(PaymentEvent(
                            itemsCount: widget.itemsCount,
                            additionalAddress: address));
                      } else {
                        Functions.goToSignInPage(context);
                      }
                    },
                  ),
                ],
              ),
              state is PaymentLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: LightColor.secondryColor,
                      ),
                    )
                  : SizedBox.shrink()
            ],
          ),
        );
      }),
    );
  }

  int getTotalCount(Map<String, int> countMap) {
    int total = 0;
    for (var count in countMap.values) {
      total += count;
    }
    return total;
  }
}
