import 'package:flutter/material.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:shimmer/shimmer.dart';

class LoadingProducts extends StatelessWidget {
  const LoadingProducts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: AppTheme.fullWidth(context) * 0.02),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 4 / 2.8,
        mainAxisSpacing: AppTheme.fullWidth(context) * 0.025,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.white,
          child: Container(
            width: AppTheme.fullWidth(context) * 0.4,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.all(
                    Radius.circular(AppTheme.fullWidth(context) * 0.048))),
          ),
        );
      },
    );
  }
}
