import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/presentation/home/bloc/home_bloc.dart';
import 'package:goomlah/presentation/home/sub_categories/category_icon.dart';
import 'package:goomlah/presentation/home/products/home_products_bloc/products_bloc.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({
    Key key,
  }) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int selctedIndex = 0;
  List<Category> categories;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTheme.fullHeight(context) * 0.085,
      child: BlocConsumer<HomeBloc, HomeblocState>(
        listener: (context, homeState) => handleBlocListener(homeState),
        builder: (context, homeState) => handleBlocBuilder(homeState),
      ),
    );
  }

  Widget handleBlocBuilder(HomeblocState homeState) {
    if (homeState is HomeblocInitial || homeState is HomeDataLoading) {
      return getLoadingList();
    }
    if (homeState is HomeDataSucceed) {
      categories = homeState.subCategories;
      if (categories.length < 1) {
        return Center(
            child: Text('empty_categories'.tr(),
                style: TextsStyle.noDataMessage(context)));
      }
      return getCategoriesList();
    }
    return SizedBox.shrink();
  }

  void handleBlocListener(HomeblocState state) async {
    if (state is HomeDataSucceed) {
      if (state.subCategories.length > 0) {
        BlocProvider.of<HomeProductsBloc>(context).add(
            FetchingCategoryProducts(categoryId: state.subCategories[0].id));
      }
    }
  }

  Widget getCategoriesList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      padding: AppTheme.getPadding(context),
      itemBuilder: (context, index) {
        return CategoryIcon(
          index: index,
          internalPadding: index < categories.length - 1
              ? AppTheme.fullWidth(context) * 0.05
              : 0,
          category: categories[index],
          isSelected: selctedIndex == index ? true : false,
          onSelection: (index) {
            BlocProvider.of<HomeProductsBloc>(context).add(
                FetchingCategoryProducts(categoryId: categories[index].id));
            setState(() {
              selctedIndex = index;
            });
          },
        );
      },
    );
  }

  Widget getLoadingList() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        padding: AppTheme.getPadding(context),
        itemBuilder: (context, index) {
          return Padding(
              padding:
                  EdgeInsets.only(right: AppTheme.fullWidth(context) * 0.02),
              child: Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey[300],
                child: Container(
                    width: 150,
                    padding: AppTheme.getHorziontalPadding(context),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.5),
                        borderRadius: BorderRadius.all(Radius.circular(
                            AppTheme.fullWidth(context) * 0.025)))),
              ));
        });
  }
}
