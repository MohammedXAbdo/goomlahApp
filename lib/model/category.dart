import 'dart:convert';
import 'package:meta/meta.dart';

class Category {
  final int id;
  final String name;
  final String nameArabic;
  final String description;
  final String descriptionArabic;

  final String image;
  final int mainCategory;
  const Category(
      {@required this.id,
      @required this.descriptionArabic,
      @required this.nameArabic,
      @required this.name,
      @required this.image,
      @required this.mainCategory,
      @required this.description})
      : assert(id != null, 'field cant be equal null'),
        assert(name != null,
            'field cant be equal null'); //assert(image != null, 'field cant be equal null');

  Map<String, dynamic> toMap() {
    return {
      'name_ar': nameArabic,
      'description_ar': descriptionArabic,
      'id': id,
      'name': name,
      'image': image,
      'main_category': mainCategory,
      'description': description
    };
  }

  factory Category.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return Category(
        nameArabic: map['name_ar'],
        descriptionArabic: map['description_ar'],
        id: map['id'],
        name: map['name'],
        image: map['image'],
        mainCategory: map['main_category'],
        description: map['description']);
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));
}
