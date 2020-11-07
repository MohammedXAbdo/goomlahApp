import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/home/bloc/home_bloc.dart';
import 'package:goomlah/presentation/home/main_categories/main_categories.dart';
import 'package:goomlah/presentation/home/sub_categories/category_list.dart';
import 'package:goomlah/presentation/home/last_products/last_products_list.dart';
import 'package:goomlah/presentation/home/products/product_list.dart';
import 'package:goomlah/presentation/home/search/bloc/search_bloc.dart';
import 'package:goomlah/presentation/home/search/search_bar.dart';
import 'package:goomlah/presentation/widgets/products_grid_view.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:goomlah/utils/functions/functions.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  static final String emptySearchResult = 'empty_search'.tr() + ".";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SearchBar(),
          Expanded(
              child: BlocConsumer<SearchBloc, SearchState>(
            listener: (context, searchState) {
              if (searchState is ProductsSearchFailed) {
                Scaffold.of(context).showSnackBar(
                    Functions.getSnackBar(message: searchState.failure.code));
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  homeWidgets(),
                  if (state is AllCategoriesLoading) ...[
                    Center(
                      child: CircularProgressIndicator(
                          backgroundColor: LightColor.secondryColor),
                    )
                  ]
                ],
              );
            },
          )
              //   BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
              // if (state is ProductsSearchLoading) {
              //   return progressIndicator(context);
              // } else if (state is ProductsSearchSucceed) {
              //   if (state.products.length < 1) {
              //     return errorText(MyHomePage.emptySearchResult, context);
              //   }
              //   return searchList(state.products);
              // } else if (state is ProductsSearchFailed) {
              //   return errorText(state.failure.code, context);
              // }
              //return
              ),
        ],
      ),
    );
  }

  Widget errorText(String text, context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
          padding: EdgeInsets.all(AppTheme.fullHeight(context) * .03),
          child: Text(text, style: TextsStyle.noDataMessage(context))),
    );
  }

  Widget progressIndicator(context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.all(AppTheme.fullHeight(context) * .03),
        child: CircularProgressIndicator(
          backgroundColor: LightColor.secondryColor,
        ),
      ),
    );
  }

  Widget searchList(products) {
    return ProductsGridView(
        shrinkWrap: true,
        products: products,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(
            vertical: AppTheme.fullHeight(context) * 0.04,
            horizontal: AppTheme.fullWidth(context) * 0.1),
        sliverGridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.8 / 4,
            crossAxisSpacing: AppTheme.fullWidth(context) * 0.025,
            mainAxisSpacing: AppTheme.fullHeight(context) * 0.025));
  }

  Widget homeWidgets() {
    return RefreshIndicator(
      onRefresh: () async {
        print("refresh");
        BlocProvider.of<HomeBloc>(context).add(FetchHomeData());
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: BlocBuilder<HomeBloc, HomeblocState>(
          builder: (context, state) {
            return Container(
              child: Column(
                children: [
                  getCategoryList(state),
                  getMainCategories(state),
                  getLastProductsList(state),
                  getNoDataMessage(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getCategoryList(HomeblocState state) {
    if (state is HomeDataSucceed) {
      if (state.subCategories.length < 1) {
        return SizedBox.shrink();
      }
    }
    return Column(
      children: [
        CategoryList(),
        ProductsList(),
      ],
    );
  }

  Widget getLastProductsList(HomeblocState state) {
    if (state is HomeDataSucceed) {
      if (state.products.length < 1) {
        return SizedBox.shrink();
      }
    }
    return LastProductsList();
  }

  Widget getMainCategories(HomeblocState state) {
    if (state is HomeDataSucceed) {
      if (state.mainCategories.length < 1) {
        return SizedBox.shrink();
      }
    }
    return MainCategoriesList();
  }

  Widget getNoDataMessage(HomeblocState state) {
    if (state is HomeDataSucceed) {
      if (state.products.length < 1 &&
          state.subCategories.length < 1 &&
          state.mainCategories.length < 1) {
        return Center(
            child: Text('empty_data'.tr() + ".",
                style: TextsStyle.noDataMessage(context)));
      }
    }
    return SizedBox.shrink();
  }
}
