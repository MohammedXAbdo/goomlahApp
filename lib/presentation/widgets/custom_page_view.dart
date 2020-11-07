import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';

class CustomPageView extends StatefulWidget {
  const CustomPageView({
    Key key,
    @required this.controller,
    @required this.pages,
    @required this.totalPages,
  }) : super(key: key);

  final PageController controller;
  final List<Widget> pages;
  final int totalPages;

  @override
  _CustomPageViewState createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  int currentMainPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
            onPageChanged: (index) {
              // set this if you dont want to keep the state of pages
              // if (index == 0) {
              //   BlocProvider.of<MainCategoriesBloc>(context)
              //       .add(FetchMainCategories(1));
              // }
              setState(() {
                currentMainPageIndex = index;
              });
            },
            controller: widget.controller,
            children: widget.pages),
        Padding(
          padding: EdgeInsets.only(
            bottom: AppTheme.fullHeight(context) * 0.1,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: DotsIndicator(
              dotsCount: widget.totalPages,
              position: currentMainPageIndex.toDouble(),
              decorator: DotsDecorator(
                color: Colors.grey[300], // Inactive color
                activeColor: LightColor.orange,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
