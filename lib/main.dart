import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/bloc_observer.dart';
import 'package:goomlah/presentation/Register/bloc/account_bloc.dart';
import 'package:goomlah/presentation/Register/location_bloc/location_bloc.dart';
import 'package:goomlah/presentation/Register/verification/bloc/verification_bloc.dart';
import 'package:goomlah/presentation/categories/main_categories/main_category_bloc/main_category_bloc.dart';
import 'package:goomlah/presentation/categories/sub_categories/bloc/subcategories_bloc.dart';
import 'package:goomlah/presentation/home/bloc/home_bloc.dart';
import 'package:goomlah/presentation/home/search/bloc/search_bloc.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/main/main_page_controller.dart';
import 'package:goomlah/presentation/home/products/home_products_bloc/products_bloc.dart';
import 'package:goomlah/presentation/orders_history/bloc/orders_bloc.dart';
import 'package:goomlah/presentation/product_page/bloc/product_bloc.dart';
import 'package:goomlah/presentation/profile/Auth_bloc/auth_bloc.dart';
import 'package:goomlah/presentation/profile/bloc/profile_bloc.dart';
import 'package:goomlah/presentation/shopping_cart/bloc/cart_bloc.dart';
import 'package:goomlah/presentation/wishlist/bloc/wish_list_bloc.dart';
import 'package:goomlah/service_locator.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final String translationsPath = 'assets/translations';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  serviceLocatorSetup();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  runApp(
    EasyLocalization(
      path: translationsPath,
      fallbackLocale: Locale('ar'),
      startLocale: Locale('ar'),
      saveLocale: true,
      supportedLocales: [Locale("ar"), Locale("en")],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp(
        title: 'app_title'.tr(),
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate
        ],
        // localizationsDelegates: [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   EasyLocalization.of(context).delegate,
        // ],
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: MainPage(),
      ),
    );
  }

  final blocProviders = [
    BlocProvider<WishlistBloc>(create: (_) => serviceLocator<WishlistBloc>()),
    BlocProvider<CartBloc>(create: (_) => serviceLocator<CartBloc>()),
    BlocProvider<LocationBloc>(create: (_) => serviceLocator<LocationBloc>()),
    BlocProvider<OrdersBloc>(create: (_) => serviceLocator<OrdersBloc>()),
    BlocProvider<ProductBloc>(create: (_) => serviceLocator<ProductBloc>()),
    BlocProvider<PageBloc>(create: (_) => PageBloc()),
    BlocProvider<AccountBloc>(create: (_) => serviceLocator<AccountBloc>()),
    BlocProvider<VerificationBloc>(
        create: (_) => serviceLocator<VerificationBloc>()),
    BlocProvider<HomeBloc>(create: (_) => serviceLocator<HomeBloc>()),
    BlocProvider<SearchBloc>(create: (_) => serviceLocator<SearchBloc>()),
    BlocProvider<AuthBloc>(create: (_) => serviceLocator<AuthBloc>()),
    BlocProvider<MainCategoriesBloc>(
        create: (_) => serviceLocator<MainCategoriesBloc>()),
    BlocProvider<SubCategoriesBloc>(
        create: (_) => serviceLocator<SubCategoriesBloc>()),
    BlocProvider<HomeProductsBloc>(
        create: (_) => serviceLocator<HomeProductsBloc>()),
    BlocProvider<ProfileBloc>(create: (_) => serviceLocator<ProfileBloc>()),
  ];
}
