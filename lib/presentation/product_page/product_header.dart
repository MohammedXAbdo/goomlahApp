import 'package:flutter/material.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/widgets/cached_image.dart';
import 'package:goomlah/presentation/widgets/fade_widget.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/presentation/widgets/extentions.dart';

class ProductHeader extends StatefulWidget {
  final Product product;
  const ProductHeader({
    Key key,
    @required this.product,
  }) : super(key: key);

  @override
  _ProductHeaderState createState() => _ProductHeaderState();
}

class _ProductHeaderState extends State<ProductHeader> {
  String mainImage;
  int selectedIndex;
  List<String> images;
  @override
  void initState() {
    mainImage = widget.product.image;
    selectedIndex = 0;
    images = [widget.product.image] + widget.product.images;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: AppTheme.fullHeight(context) * .35,
            child: Padding(
              padding: EdgeInsets.all(AppTheme.fullHeight(context) * .016),
              child: FadeWidget(
                  key: GlobalKey(),
                  duration: Duration(milliseconds: 500),
                  child: CachedImage(url: mainImage)),
            )),
        SizedBox(height: AppTheme.fullHeight(context) * 0.02),
          Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getThumbnails(images),
              ),
      
      ],
    );
  }

  List<Widget> getThumbnails(List<String> images) {
    List<Widget> thumbnails = [];
    for (int i = 0; i < images.length; i++) {
      thumbnails.add(
        Thumbnail(
          image: images[i],
          index: i,
          isSelected: i == selectedIndex,
          onPressed: (image, index) {
            if (image != mainImage) {
              setState(() {
                mainImage = image;
                selectedIndex = index;
              });
            }
          },
        ),
      );
    }
    return thumbnails;
  }
}

class Thumbnail extends StatelessWidget {
  final String image;
  final int index;
  final Function(String, int) onPressed;
  final bool isSelected;
  const Thumbnail({
    Key key,
    this.image,
    this.onPressed,
    this.isSelected = false,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeWidget(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: AppTheme.fullWidth(context) * 0.01),
        child: Container(
          height: AppTheme.fullWidth(context) * 0.1,
          width: AppTheme.fullWidth(context) * 0.1,
          decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? LightColor.orange : LightColor.grey),
            borderRadius: BorderRadius.all(Radius.circular(13)),
          ),
          child: Padding(
              padding: EdgeInsets.all(AppTheme.fullWidth(context) * 0.01),
              child: CachedImage(url: image)),
        ).ripple(() {
          if (onPressed != null) {
            onPressed(image, index);
          }
        }, borderRadius: BorderRadius.all(Radius.circular(13))),
      ),
    );
  }
}
