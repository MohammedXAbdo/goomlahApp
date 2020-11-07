abstract class LocalDatabaseRepository {
  final homeSubCategoriesTable = 'home_sub_categories_table';
  final homeMainCategoriesTable = 'home_main_categories_table';
  final lastProductsTable = 'last_products';
  final categoryProductsTable = "category_products";
  final mainCategoriesTable = "main_categories";
  final productsWishlistTable = 'Products_wishlist';
  final profileTable = "profile";
  final profileKey = 'profile';
  final welcomeMessageKey ='welcomeMessage';
  final String tokenKey = 'token';
  final String idKey = 'id';
  Future<dynamic> read({String tableName, String key});
  Future<void> write({String tableName, String key, dynamic value});
  Future<void> delete({String tableName, String key});
}
