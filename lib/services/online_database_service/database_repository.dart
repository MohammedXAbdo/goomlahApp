import 'package:goomlah/model/category.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/services/api_handler.dart';
import 'package:meta/meta.dart';

abstract class DatabaseRepository {
  final String categoriesKey = 'categories';
  final String currentPageKey = 'current_page';
  final String lastPageKey = 'last_page';
  final String productsKey = 'products';
  final String dataKey = 'data';

  final ApiHandler apiHandler;
  DatabaseRepository(this.apiHandler);
  Future<Map<String, dynamic>> fetchHomeData();
  Future<Map<String, dynamic>> fetchMainCategories({@required int page});
  Future<Map<String, dynamic>> fetchSubCategories(
      {@required int categoryId, @required int page});
  Future<dynamic> fetchHomeProducts({@required int categoryId});
  Future<dynamic> fetchProfile(
      {@required String userId, @required String token});
  Future<String> editProfile({@required String token , @required String id , @required String name , @required String phone ,String password });
  Future<dynamic> fetchOrders({@required String token});
  Future<dynamic> fetchProduct({@required int id});
  Future<List<Product>> searchByProduct({@required String productName,int categoryId});
  Future<List<Category>> getAllCategories();
  Future<void> paymentRequest(
      {@required Map<String, int> itemsCount,
      @required String token,
      @required String additonalAddress,
      @required int timeId});
}
