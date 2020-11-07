import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/presentation/widgets/cached_image.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import '../../widgets/extentions.dart';

class CategoryIcon extends StatefulWidget {
  final Category category;
  final Function(int) onSelection;
  final bool isSelected;
  final int index;
  final Function imageLoaded;
  final double internalPadding;
  CategoryIcon(
      {Key key,
      this.category,
      this.isSelected,
      this.onSelection,
      this.index,
      this.imageLoaded,
      this.internalPadding})
      : super(key: key);

  @override
  _CategoryIconState createState() => _CategoryIconState();
}

class _CategoryIconState extends State<CategoryIcon> {
  bool isArabic;
  String arabicName;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    isArabic = EasyLocalization.of(context).locale.languageCode == 'ar';
    arabicName = widget.category.nameArabic;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.fullWidth(context) * 0.02,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(AppTheme.fullWidth(context) * 0.025)),
              color: widget.isSelected ? LightColor.background : Colors.white,
              border: Border.all(
                color: widget.isSelected ? LightColor.orange : LightColor.grey,
                width: widget.isSelected ? 2 : 1,
              ),
              boxShadow: widget.isSelected
                  ? <BoxShadow>[
                      BoxShadow(
                        color: widget.isSelected
                            ? LightColor.orange.withOpacity(0.05)
                            : Colors.white,
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(5, 5),
                      ),
                    ]
                  : null),
          child: Row(
            children: <Widget>[
              widget.category.image == null
                  ? Icon(Icons.category)
                  : CachedImage(url: widget.category.image),
              SizedBox(
                width: AppTheme.fullWidth(context) * 0.01,
              ),
              Text(
                  !isArabic
                      ? widget.category.name
                      : arabicName != null && arabicName.isNotEmpty
                          ? arabicName
                          : widget.category.name,
                  style: TextsStyle.categoryIconName(context))
            ],
          ),
        ).ripple(
          () {
            if (widget.onSelection != null && !widget.isSelected) {
              widget.onSelection(widget.index);
            }
          },
          borderRadius: BorderRadius.all(
              Radius.circular(AppTheme.fullWidth(context) * 0.025)),
        ),
        SizedBox(width: widget.internalPadding ?? 0)
      ],
    );
  }
}
