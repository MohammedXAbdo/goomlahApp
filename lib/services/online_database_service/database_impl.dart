import 'dart:convert';

import 'package:goomlah/model/category.dart';
import 'package:goomlah/model/order.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/services/api_handler.dart';
import 'package:goomlah/services/online_database_service/database_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/Failure/server_validation_error.dart';
import 'package:meta/meta.dart';

class DatabaseImplementation extends DatabaseRepository {
  DatabaseImplementation(ApiHandler apiHandler) : super(apiHandler);
  final String categoriesPath = 'public/api/categories/';
  final String usersPath = 'public/api/users/';
  final String paymentPath = "public/api/orders";
  final String itemsPostKey = 'products';
  final String ordersPath = 'public/api/orders';
  final String ordersGetKey = 'orders';
  final String searchPath = 'public/api/products/search';
  final String searchPostKey = 'keyword';
  final String categoryIdSearchKey = 'categoryId';
  final String searchGetKey = 'results';
  final String productPath = 'public/api/products';
  final String productGetKey = 'product';
  final String allCategoriesPath = "allCategories";
  final String allCategoriesKey = "allCategories";
  final String editProfilePath = "public/api/users/";
  final String dataKey = 'data';
  final String pageQuery = 'page';
  final String userKey = 'user';
  final String messageKey = "message";

  @override
  Future<Map<String, dynamic>> fetchMainCategories({@required int page}) async {
    try {
      final response = await apiHandler.getData(
        path: categoriesPath,
        queryParameters: {pageQuery: '$page'},
      );

      if (apiHandler.successResponse(response.statusCode)) {
        final categoriesMap =
            json.decode(response.body)[categoriesKey][dataKey];
        final lastPage = json.decode(response.body)[categoriesKey][lastPageKey];
        final currentPage =
            json.decode(response.body)[categoriesKey][currentPageKey];
        final Map<String, dynamic> pageData = {
          categoriesKey: categoriesMap,
          lastPageKey: lastPage,
          currentPageKey: currentPage,
        };
        return pageData;
      } else {
        print('not success response');
        throw UnimplementedFailure();
      }
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      print(e);
      throw UnimplementedFailure();
    }
  }

  @override
  Future<Map<String, dynamic>> fetchSubCategories(
      {int categoryId, int page}) async {
    try {
      final response = await apiHandler.getData(
        path: categoriesPath + categoryId.toString(),
        queryParameters: {pageQuery: '$page'},
      );

      if (apiHandler.successResponse(response.statusCode)) {
        Map<String, dynamic> data = {
          categoriesKey: null,
          productsKey: null,
          lastPageKey: 1,
          currentPageKey: page
        };
        dynamic categoriesMap = json.decode(response.body)[categoriesKey];
        if (categoriesMap != null) {
          if (!categoriesMap[dataKey].isEmpty) {
            final categories = categoriesMap[dataKey];
            final lastPage = categoriesMap[lastPageKey];
            data[categoriesKey] = categories;
            if (lastPage > data[lastPageKey]) {
              data[lastPageKey] = lastPage;
            }
          }
        }
        dynamic productsMap = json.decode(response.body)[productsKey];
        if (productsMap != null) {
          if (!productsMap[dataKey].isEmpty) {
            final products = productsMap[dataKey];
            final lastPage = productsMap[lastPageKey];
            data[productsKey] = products;
            if (lastPage > data[lastPageKey]) {
              data[lastPageKey] = lastPage;
            }
          }
        }
        if (data[productsKey] == null && data[categoriesKey] == null) {
          data[productsKey] = [];
        }
        return (data);
      } else {
        print('not success response');
        throw UnimplementedFailure();
      }
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      print(e);
      throw UnimplementedFailure();
    }
  }

  @override
  Future<Map<String, dynamic>> fetchHomeData() async {
    final response = await apiHandler.getData(path: 'public/api');

    try {
      if (apiHandler.successResponse(response.statusCode)) {
        final categoriesMap = json.decode(response.body)[categoriesKey];
        final productsMap = jsonDecode(response.body)[productsKey];
        return {
          categoriesKey: categoriesMap,
          productsKey: productsMap,
        };
      } else {
        print('not success response');
        throw UnimplementedFailure();
      }
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      print(e);
      throw UnimplementedFailure();
    }
  }

  @override
  Future<dynamic> fetchHomeProducts({@required int categoryId}) async {
    try {
      final response = await apiHandler.getData(
          path: categoriesPath + categoryId.toString(),
          queryParameters: {pageQuery: '1'});

      if (apiHandler.successResponse(response.statusCode)) {
        final productsMap = jsonDecode(response.body)[productsKey][dataKey];
        return productsMap;
      } else {
        print('not success response');
        throw UnimplementedFailure();
      }
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      print(e);
      throw UnimplementedFailure();
    }
  }

  @override
  Future<dynamic> fetchProduct({@required int id}) async {
    try {
      final response = await apiHandler.getData(path: productPath + "/$id");
      if (apiHandler.successResponse(response.statusCode)) {
        var productMap = json.decode(response.body)[productGetKey];
        if (productMap == null) return null;
        productMap = _adjustProductImages(productMap);
        final product = Product.fromMap(productMap);
        return product;
      } else {
        print('not success response');
        throw UnimplementedFailure();
      }
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      print(e);
      throw UnimplementedFailure();
    }
  }

  Map<String, dynamic> _adjustProductImages(Map<String, dynamic> productMap) {
    final imagesMap = productMap['product_images'];
    List<String> images = [];
    for (var imageMap in imagesMap) {
      images.add(imageMap['image']);
    }
    productMap['images'] = images;
    return productMap;
  }

  @override
  Future<dynamic> fetchProfile({String userId, String token}) async {
    try {
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      final response =
          await apiHandler.getData(path: usersPath + userId, headers: headers);
      if (apiHandler.successResponse(response.statusCode)) {
        if (json.decode(response.body) == null) throw UnimplementedFailure();
        return json.decode(response.body)[userKey];
      } else {
        throw UnimplementedFailure();
      }
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      throw UnimplementedFailure();
    }
  }

  @override
  Future<dynamic> fetchOrders({String token}) async {
    try {
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      final response =
          await apiHandler.getData(path: ordersPath, headers: headers);
      if (apiHandler.successResponse(response.statusCode)) {
        if (json.decode(response.body) == null) throw UnimplementedFailure();
        final ordersMap = json.decode(response.body)[ordersGetKey];
        List<Order> orders = [];
        if (ordersMap is String) return orders;
        for (var orderMap in ordersMap) {
          orders.add(Order.fromMap(
              orderMap, Product.fromMap(orderMap[productGetKey])));
        }
        return orders;
      } else {
        throw UnimplementedFailure();
      }
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      throw UnimplementedFailure();
    }
  }

  @override
  Future<List<Product>> searchByProduct(
      {String productName, int categoryId}) async {
    try {
      Map<String, Object> body;
      if (categoryId == -1 || categoryId == null) {
        body = {searchPostKey: productName};
      } else {
        body = {
          searchPostKey: productName,
          categoryIdSearchKey: categoryId.toString()
        };
      }

      final response = await apiHandler.postData(body: body, path: searchPath);
      if (apiHandler.successResponse(response.statusCode)) {
        final productsMap = json.decode(response.body)[searchGetKey];
        if (productsMap is String) {
          return [];
        }
        List<Product> products = [];
        for (var productMap in productsMap) {
          products.add(Product.fromMap(productMap));
        }
        return products;
      } else {
        print(response.statusCode);
        throw UnimplementedFailure();
      }
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      print(e);
      throw UnimplementedFailure();
    }
  }

  @override
  Future<void> paymentRequest(
      {@required Map<String, int> itemsCount,
      @required String token,
      @required String additonalAddress,
      @required int timeId}) async {
    try {
      dynamic itemsCountList = [];
      for (var itemCount in itemsCount.keys) {
        itemsCountList.add({
          'id': itemCount,
          'quantity': itemsCount[itemCount],
        });
      }
      final body = {
        itemsPostKey: itemsCountList,
      };
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      final response = await apiHandler.postData(
          body: json.encode(body), path: paymentPath, headers: headers);
      if (!apiHandler.successResponse(response.statusCode)) {
        print(response.statusCode);
        throw UnimplementedFailure();
      }
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      print(e.toString());

      throw UnimplementedFailure();
    }
  }

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await apiHandler.getData(path: allCategoriesPath);
      if (apiHandler.successResponse(response.statusCode)) {
        final categoriesMap = json.decode(response.body)[allCategoriesKey];
        List<Category> categories = [];
        for (var catgeoryMap in categoriesMap) {
          categories.add(Category.fromMap(catgeoryMap));
        }
        return categories;
      } else {
        throw UnimplementedFailure();
      }
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {}
    throw UnimplementedError();
  }

  @override
  Future<String> editProfile(
      {String token,
      String id,
      String name,
      String phone,
      String password}) async {
    try {
      final headers = {"Authorization": "Bearer $token"};
      Map<String, String> queryParameters;
      if (password != null) {
        queryParameters = {
          "name": name,
          "phone": phone.toString(),
          "password": password,
        };
      } else {
        queryParameters = {
          "name": name,
          "phone": phone.toString(),
        };
      }
      final response = await apiHandler.putData(
          path: editProfilePath + id.toString(),
          headers: headers,
          queryParameters: queryParameters);
      if (apiHandler.successResponse(response.statusCode)) {
        return jsonDecode(response.body)[messageKey];
      } else {
        if (response.statusCode == 401) {
          final messagesList = json.decode(response.body)[messageKey];
          throw getAuthErrors(messagesList);
        }
        throw UnimplementedFailure(
            code: jsonDecode(response.body)[messageKey].toString());
      }
    } on UnimplementedFailure {
      rethrow;
    } on ServerValidationErrors {
      rethrow;
    } catch (e) {
      print(e);
      throw UnimplementedFailure();
    }
  }

  Failure getAuthErrors(dynamic errorMessages) {
    List<Failure> failures = [];
    if (errorMessages == null) return UnimplementedFailure();
    errorMessages.forEach((key, value) {
      failures.add(mapFieldToFailure(key, value[0]));
    });

    if (failures.length < 1) {
      return UnimplementedFailure();
    } else {
      return ServerValidationErrors(failures);
    }
  }

  Failure mapFieldToFailure(String field, String errorMessage) {
    if (field == "phone") {
      return PhoneValidationError(errorMessage);
    } else if (field == "name") {
      return NameValidationError(errorMessage);
    }
    return NameValidationError(errorMessage);
  }
}
