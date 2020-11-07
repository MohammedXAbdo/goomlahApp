import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/widgets/cached_image.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/presentation/widgets/extentions.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final Category mainCategory;
  final PageType previousPage;

  const CategoryItem(
      {Key key,
      @required this.category,
      this.mainCategory,
      @required this.previousPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isArabic = EasyLocalization.of(context).locale.languageCode == 'ar';
    String arabicName = category.nameArabic;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              Center(
                  child: Container(
                      height: AppTheme.fullHeight(context) * 0.06,
                      child: category.image != null
                          ? CachedImage(url: category.image)
                          : Icon(Icons.category)))
            ],
          ).ripple(() {
            BlocProvider.of<PageBloc>(context)
                .previousSubCategoryPages
                .add(previousPage);
            BlocProvider.of<PageBloc>(context).add(GoToSubCategory(
                category: category,
                mainCategory: mainCategory,
                previousPage: previousPage));
          }, borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
        SizedBox(height: AppTheme.fullHeight(context) * 0.018),
        FittedBox(
            child: Text(
                !isArabic
                    ? category.name
                    : arabicName != null && arabicName.isNotEmpty
                        ? arabicName
                        : category.name,
                style: TextsStyle.categoryIconName(context))),
      ],
    );
  }
}
