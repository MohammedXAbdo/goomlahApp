import 'package:meta/meta.dart';

class Product {
  final int id;
  final String name;
  final String nameArabic;
  final String image;
  final double price;
  final bool isliked;
  final String description;
  final String descriptionArabic;

  final List<String> images;
  const Product(
      {@required this.nameArabic,
      @required this.descriptionArabic,
      @required this.description,
      @required this.id,
      this.images,
      @required this.name,
      @required this.price,
      this.isliked = false,
      @required this.image})
      : assert(id != null, 'id shouldnt equall null'),
        assert(name != null, 'id shouldnt equall null');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'isliked': isliked,
      'description': description,
      'images': images,
    };
  }

  Product copyWith({
    int id,
    String name,
    String image,
    double price,
    bool isliked,
    String description,
  }) {
    return Product(
      nameArabic: nameArabic??this.nameArabic,
      descriptionArabic: descriptionArabic??this.descriptionArabic,
      images: images ?? this.images,
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      isliked: isliked ?? this.isliked,
      description: description ?? this.description,
    );
  }

  factory Product.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;
    var price = map['price'];
    if (price is String) {
      price = double.parse(map['price']);
    }
    if (price is int) {
      price = price.toDouble();
    }
    return Product(
      descriptionArabic: map['description_ar'],
      nameArabic: map['name_ar'],
      images: map['images'],
      description: map['description'],
      id: map['id'],
      name: map['name'],
      image: map['image'],
      price: price,
    );
  }
}
