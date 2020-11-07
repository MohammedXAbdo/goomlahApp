import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/presentation/home/bloc/home_bloc.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/widgets/category_item_large.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:goomlah/presentation/widgets/extentions.dart';
import 'package:shimmer/shimmer.dart';

class MainCategoriesList extends StatefulWidget {
  @override
  _MainCategoriesListState createState() => _MainCategoriesListState();
}

class _MainCategoriesListState extends State<MainCategoriesList> {
  List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeblocState>(builder: (context, homeState) {
      return Column(
        children: [
          homeState is HomeDataFailed
              ? SizedBox.shrink()
              : mainCategoriesTitle(context),
          Container(
            height: AppTheme.fullHeight(context) * 0.163,
            child: LayoutBuilder(builder: (_, __) {
              if (homeState is HomeDataSucceed) {
                categories = homeState.mainCategories;
                return categoriesList(categories);
              } else if (homeState is HomeDataLoading ||
                  homeState is HomeblocInitial) {
                return loadingList();
              } else {
                return SizedBox();
              }
            }),
          )
        ],
      );
    });
  }

  Widget loadingList() {
    return GridView.builder(
        padding: EdgeInsets.only(
            right: AppTheme.fullWidth(context) * 0.02,
            left: AppTheme.fullWidth(context) * 0.02,
            bottom: AppTheme.fullHeight(context) * 0.013),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: AppTheme.fullWidth(context) * 0.035),
        itemBuilder: (context, index) => laodingItem());
  }

  Widget laodingItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Shimmer.fromColors(
            highlightColor: Colors.white,
            baseColor: Colors.grey[300],
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(
                      Radius.circular(AppTheme.fullHeight(context) * 0.015))),
            ),
          ),
        ),
        SizedBox(height: AppTheme.fullHeight(context) * 0.018),
        Shimmer.fromColors(
          highlightColor: Colors.white,
          baseColor: Colors.grey[300],
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(
                      Radius.circular(AppTheme.fullHeight(context) * 0.015))),
              height: AppTheme.fullHeight(context) * 0.018),
        ),
      ],
    );
  }

  Widget categoriesList(categories) {
    return GridView.builder(
        padding: EdgeInsets.only(
            right: AppTheme.fullWidth(context) * 0.02,
            left: AppTheme.fullWidth(context) * 0.02,
            bottom: AppTheme.fullHeight(context) * 0.013),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: AppTheme.fullWidth(context) * 0.035),
        itemBuilder: (context, index) => CategoryItem(
              category: categories[index],previousPage: PageType.home,
            ));
  }

  Widget mainCategoriesTitle(context) {
    return Padding(
      padding: AppTheme.getPadding(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('all_categories'.tr(), style: TextsStyle.homeItem(context)),
          Text('see_more'.tr(), style: TextsStyle.seeMore(context)).ripple(() {
            BlocProvider.of<PageBloc>(context)
                .add(PageTransition(PageType.categories));
          }),
        ],
      ),
    );
  }
}
