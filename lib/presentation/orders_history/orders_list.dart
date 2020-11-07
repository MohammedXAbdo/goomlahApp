
import 'package:flutter/material.dart';
import 'package:goomlah/model/order.dart';
import 'package:goomlah/presentation/widgets/product_row_item.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:easy_localization/easy_localization.dart';

class OrdersList extends StatefulWidget {
  final Widget emptyMessage;
  const OrdersList({
    Key key,
    @required this.orders,
    @required this.emptyMessage,
  }) : super(key: key);

  final List<Order> orders;

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    if (widget.orders.length < 1) return widget.emptyMessage;
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.orders.length,
      itemBuilder: (context, index) {
        return ProductRowItem(
          product: widget.orders[index].product,
          trailing: (product) => orderQuantity(widget.orders[index].quantity),
          subTitle: orderData(widget.orders[index].date),
        );
      },
    );
  }

  Widget orderQuantity(int count) {
    String items = count.toString() + " " + 'items'.tr();
    if (count == 1) {
      items = count.toString() + " " + 'item'.tr();
    } else if (count == 2) {
      items = 'two_items'.tr();
    } else if (count > 10) {
      items = count.toString() + " " + "more_than_ten_items".tr();
    }
    return FittedBox(
      child: Text(items, style: TextsStyle.orderCount(context)),
    );
  }

  Widget orderData(String date) {
    return FittedBox(
      child:
          Text('at'.tr() + " " + date, style: TextsStyle.orderCount(context)),
    );
  }
}
