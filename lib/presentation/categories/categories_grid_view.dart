import 'package:flutter/material.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/widgets/category_item_large.dart';
import 'package:goomlah/themes/theme.dart';

class CategoriesGridView extends StatelessWidget {
  final Category mainCategory;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  const CategoriesGridView({
    Key key,
    @required this.categories,
    this.mainCategory,
    this.physics,
    this.shrinkWrap = false,
  }) : super(key: key);

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryItem(
          category: categories[index],
          mainCategory: mainCategory,
          previousPage: PageType.categories,
        );
      },
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
          right: AppTheme.fullWidth(context) * 0.07,
          left: AppTheme.fullWidth(context) * 0.07,
          top: AppTheme.fullHeight(context) * 0.02),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.5 / 3,
          crossAxisSpacing: AppTheme.fullWidth(context) * 0.07,
          mainAxisSpacing: AppTheme.fullHeight(context) * 0.05),
    );
  }
}
