import 'dart:convert';

import 'package:meta/meta.dart';

class User {
  final int id;
  final String name;
  final String phone;
  final String address;
  const User(
      {@required this.id,
      @required this.name,
      @required this.phone,
      @required this.address})
      : assert(name != null, 'field mustnot be equal null'),
        assert(id != null, 'field mustnot be equal null'),
        assert(phone != null, 'field mustnot be equal null'),
        assert(address != null, 'field mustnot be equal null');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
    };
  }
  

  factory User.fromMap(Map<String, dynamic> map, {String address}) {
    if (map == null) return null;
    String myAddress;
    if (address != null) {
      myAddress = address;
    } else {
      myAddress = map['address'];
    }
    return User(
      name: map['name'],
      phone: map['phone'],
      address: myAddress,
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
