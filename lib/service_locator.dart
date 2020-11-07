import 'package:get_it/get_it.dart';
import 'package:goomlah/presentation/Register/bloc/account_bloc.dart';
import 'package:goomlah/presentation/Register/location_bloc/location_bloc.dart';
import 'package:goomlah/presentation/Register/verification/bloc/verification_bloc.dart';
import 'package:goomlah/presentation/categories/sub_categories/bloc/subcategories_bloc.dart';
import 'package:goomlah/presentation/home/bloc/home_bloc.dart';
import 'package:goomlah/presentation/home/products/home_products_bloc/products_bloc.dart';
import 'package:goomlah/presentation/home/search/bloc/search_bloc.dart';
import 'package:goomlah/presentation/orders_history/bloc/orders_bloc.dart';
import 'package:goomlah/presentation/product_page/bloc/product_bloc.dart';
import 'package:goomlah/presentation/profile/Auth_bloc/auth_bloc.dart';
import 'package:goomlah/presentation/profile/bloc/profile_bloc.dart';
import 'package:goomlah/presentation/shopping_cart/bloc/cart_bloc.dart';
import 'package:goomlah/presentation/wishlist/bloc/wish_list_bloc.dart';
import 'package:goomlah/services/api_handler.dart';
import 'package:goomlah/services/authentication_service/authenitcation_repository.dart';
import 'package:goomlah/services/authentication_service/authentication_impl.dart';
import 'package:goomlah/services/local_database_service/hive_db_impl.dart';
import 'package:goomlah/services/local_database_service/local_db_repository.dart';
import 'package:goomlah/services/online_database_service/database_impl.dart';
import 'package:goomlah/services/online_database_service/database_repository.dart';

import 'presentation/categories/main_categories/main_category_bloc/main_category_bloc.dart';

final GetIt serviceLocator = GetIt.instance;
final String host = 'goomlah.com';

void serviceLocatorSetup() {
  serviceLocator.registerFactory<ApiHandler>(() => ApiHandler(host: host));

  serviceLocator.registerFactory<DatabaseRepository>(
      () => DatabaseImplementation(serviceLocator<ApiHandler>()));

  serviceLocator
      .registerFactory<LocalDatabaseRepository>(() => HiveDatabaseImpl());

  serviceLocator.registerFactory<AuthenticationRepository>(
      () => AuthImpl(serviceLocator<ApiHandler>()));

  serviceLocator.registerFactory(() => WishlistBloc(
      databaseImpl: serviceLocator<DatabaseRepository>(),
      storage: serviceLocator<LocalDatabaseRepository>()));

  serviceLocator.registerFactory(() => CartBloc(
        storage: serviceLocator<LocalDatabaseRepository>(),
        databaseImpl: serviceLocator<DatabaseRepository>(),
      ));
  serviceLocator.registerFactory(() => LocationBloc());

  serviceLocator.registerFactory(() => OrdersBloc(
        databaseImpl: serviceLocator<DatabaseRepository>(),
        storage: serviceLocator<LocalDatabaseRepository>(),
      ));
  serviceLocator.registerFactory(() => ProductBloc(
        databaseImpl: serviceLocator<DatabaseRepository>(),
      ));

  serviceLocator.registerFactory(() => HomeBloc(
        storage: serviceLocator<LocalDatabaseRepository>(),
        databaseImpl: serviceLocator<DatabaseRepository>(),
      ));

  serviceLocator.registerFactory(() => VerificationBloc(
        storage: serviceLocator<LocalDatabaseRepository>(),
        authRep: serviceLocator<AuthenticationRepository>(),
      ));

  serviceLocator.registerFactory(
      () => SearchBloc(databaseImpl: serviceLocator<DatabaseRepository>()));

  serviceLocator.registerFactory(() => MainCategoriesBloc(
      storage: serviceLocator<LocalDatabaseRepository>(),
      databaseImpl: serviceLocator<DatabaseRepository>()));

  serviceLocator.registerFactory(() =>
      SubCategoriesBloc(databaseImpl: serviceLocator<DatabaseRepository>()));

  serviceLocator.registerFactory(() => HomeProductsBloc(
      storage: serviceLocator<LocalDatabaseRepository>(),
      databaseImpl: serviceLocator<DatabaseRepository>()));

  serviceLocator.registerFactory(() => ProfileBloc(
      databaseImpl: serviceLocator<DatabaseRepository>(),
      storage: serviceLocator<LocalDatabaseRepository>()));

  serviceLocator.registerLazySingleton(
      () => AuthBloc(storage: serviceLocator<LocalDatabaseRepository>()));

  serviceLocator.registerFactory(() => AccountBloc(
      authBloc: serviceLocator<AuthBloc>(),
      authRep: serviceLocator<AuthenticationRepository>(),
      storage: serviceLocator<LocalDatabaseRepository>()));
}
