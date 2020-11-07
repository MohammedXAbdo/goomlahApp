
import 'package:meta/meta.dart';

import 'package:goomlah/model/product.dart';

class Order {
  final Product product;
  final int quantity;
  final String date;
  Order({
    @required this.product,
    @required this.quantity,
    @required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'product': product?.toMap(),
      'quantity': quantity,
      'created_at': date,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, Product product) {
    if (map == null) return null;
    String date = map['created_at'];
    if (date.split(" ").length > 1) {
      date = date.split(" ")[0];
    }
    return Order(
      product: product,
      quantity: map['quantity'],
      date: date,
    );
  }
}
