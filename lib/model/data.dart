import 'package:goomlah/model/category.dart';
import 'package:goomlah/model/product.dart';

class AppData {
  static List<Product> productList = [
    Product(
      descriptionArabic: 'arabic description',
      nameArabic: 'arabic name',
      description: description,
      id: 1,
      name: 'Nike Air Max 200',
      price: 240.00,
      isliked: true,
      image: 'assets/shooe_tilt_1.png',
    ),
  ];

  static List<Category> categoryList = [
    
    Category(
      descriptionArabic: 'arabic desc',
      nameArabic: 'arabic name',
      id: 1,
      name: "Sneakers",
      image: 'assets/small_tilt_shoe_1.png',
      description: description,
      mainCategory: 3,
    ),
  ];
  static List<String> showThumbnailList = [
    "assets/shoe_thumb_5.png",
    "assets/shoe_thumb_1.png",
    "assets/shoe_thumb_4.png",
    "assets/shoe_thumb_3.png",
  ];
  static String description =
      "Clean lines, versatile and timeless—the people shoe returns with the Nike Air Max 90. Featuring the same iconic Waffle sole, stitched overlays and classic TPU accents you come to love, it lets you walk among the pantheon of Air. ßNothing as fly, nothing as comfortable, nothing as proven. The Nike Air Max 90 stays true to its OG running roots with the iconic Waffle sole, stitched overlays and classic TPU details. Classic colours celebrate your fresh look while Max Air cushioning adds comfort to the journey.";
}
