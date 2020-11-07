import 'package:flutter/material.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:shimmer/shimmer.dart';

class LoadingCategoriesList extends StatelessWidget {
  const LoadingCategoriesList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
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
                  borderRadius: BorderRadius.all(Radius.circular(
                      AppTheme.fullHeight(context) * 0.015))),
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
                  borderRadius: BorderRadius.all(Radius.circular(
                      AppTheme.fullHeight(context) * 0.015))),
              height: AppTheme.fullHeight(context) * 0.018),
        ),
      ],
    );
        },
        scrollDirection: Axis.vertical,
         padding: EdgeInsets.symmetric(
      horizontal: AppTheme.fullWidth(context) * 0.07,
      vertical: AppTheme.fullHeight(context) * 0.02),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      childAspectRatio: 2.5 / 3,
      crossAxisSpacing: AppTheme.fullWidth(context) * 0.07,
      mainAxisSpacing: AppTheme.fullHeight(context) * 0.04),
      );
  }
}
