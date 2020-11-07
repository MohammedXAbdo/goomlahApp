import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:goomlah/themes/theme.dart';

class CachedImage extends StatelessWidget {
  const CachedImage(
      {Key key,
      @required this.url,
      this.placeHolder,
      this.errorWidget,
      this.fit,
      this.isLoaded})
      : super(key: key);
  final String url;
  final Widget placeHolder;
  final Widget errorWidget;
  final BoxFit fit;
  final Function isLoaded;
  @override
  Widget build(BuildContext context) {
    if(url==null)return Icon(Icons.image);
    if (url.contains('assets')) {
      if (isLoaded != null) {
        isLoaded();
      }
      return Image.asset(
        url,
        fit: fit ?? BoxFit.cover,
      );
    }

    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(AppTheme.fullWidth(context) * 0.048),
    //   child: FadeInImage.memoryNetwork(
    //     imageErrorBuilder:
    //         (BuildContext context, Object exception, StackTrace stackTrace) {
    //       print('Error Handler');
    //       return Container(
    //         child: Icon(Icons.error),
    //       );
    //     },
    //     placeholder: kTransparentImage,
    //     image: url,
    //     fit: BoxFit.cover,
    //   ),
    // );
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.fullWidth(context) * 0.048),
      child: CachedNetworkImage(
        useOldImageOnUrlChange: true,
        imageUrl: url,
        errorWidget: (context, url, error) => Icon(Icons.error),
        placeholder: (context, url) => placeHolder ?? SizedBox.shrink(),
        fit: fit ?? BoxFit.cover,
      ),
    );
  }
}
