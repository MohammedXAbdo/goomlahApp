import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/profile/Auth_bloc/auth_bloc.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/presentation/widgets/BottomNavigationBar/bottom_curved_Painter.dart';
import 'package:goomlah/themes/theme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  CustomBottomNavigationBar({Key key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final double iconsCount = 5;
  AnimationController _xController;
  AnimationController _yController;
  void setSelectedIndex(int newSelectedIndex) {}

  @override
  void didUpdateWidget(CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _xController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);
    _yController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);

    Listenable.merge([_xController, _yController]).addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _selectedIndex = mapPageToSelectedIndex();
    int moveTo = _selectedIndex;
    if (EasyLocalization.of(context).locale.languageCode == 'ar') {
      moveTo = iconsCount.toInt() - 1 - _selectedIndex;
    } else {
      moveTo = _selectedIndex;
    }
    _xController.value =
        _indexToPosition(moveTo) / MediaQuery.of(context).size.width;
    _yController.value = 1.0;
    super.didChangeDependencies();
  }

  int mapPageToSelectedIndex() {
    final pageType = BlocProvider.of<PageBloc>(context).state.pageType;
    if (pageType == PageType.home) return 0;
    if (pageType == PageType.categories || pageType == PageType.subCategories)
      return 1;
    if (pageType == PageType.cart ||
        pageType == PageType.payment ||
        pageType == PageType.ordersHistory) return 2;
    if (pageType == PageType.wishlist) return 3;
    if (pageType == PageType.signIn ||
        pageType == PageType.signUp ||
        pageType == PageType.profile ||
        pageType == PageType.verfication) return 4;
    return 0;
  }

  double _indexToPosition(int index) {
    // Calculate button positions based off of their
    // index (works with `MainAxisAlignment.spaceAround`)
    final appWidth = MediaQuery.of(context).size.width;
    final buttonsWidth = _getButtonContainerWidth();
    final startX = (appWidth - buttonsWidth) / 2;
    return startX +
        index.toDouble() * buttonsWidth / iconsCount +
        buttonsWidth / (iconsCount * 2.0);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  Widget _icon(IconData icon, bool isEnable, int index) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        onTap: () {
          _handlePressed(index, true);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          alignment: isEnable ? Alignment.topCenter : Alignment.center,
          child: AnimatedContainer(
              height: isEnable ? 40 : 20,
              duration: Duration(milliseconds: 300),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: isEnable ? LightColor.orange : Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: isEnable
                          ? LightColor.orange.withOpacity(0.05)
                          : Colors.white,
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: Offset(5, 5),
                    ),
                  ],
                  shape: BoxShape.circle),
              child: Opacity(
                opacity: isEnable ? _yController.value : 1,
                child: Icon(icon,
                    color: isEnable
                        ? LightColor.background
                        : LightColor.secondryColor
                    //Theme.of(context).iconTheme.color
                    ),
              )),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    final inCurve = ElasticOutCurve(0.38);
    return CustomPaint(
      painter: BackgroundCurvePainter(
          _xController.value * MediaQuery.of(context).size.width,
          Tween<double>(
            begin: Curves.easeInExpo.transform(_yController.value),
            end: inCurve.transform(_yController.value),
          ).transform(_yController.velocity.sign * 0.5 + 0.5),
          Theme.of(context).backgroundColor),
    );
  }

  double _getButtonContainerWidth() {
    double width = MediaQuery.of(context).size.width;
    if (width > 400.0) {
      width = 400.0;
    }
    return width;
  }

  void _handlePressed(int index, bool callOnPressed) {
    if (_selectedIndex == index || _xController.isAnimating) return;
    if (callOnPressed) onBottomIconPressed(index);
    setState(() {
      _selectedIndex = index;
    });
    int moveTo = index;
    if (EasyLocalization.of(context).locale.languageCode == 'ar') {
      moveTo = iconsCount.toInt() - 1 - index;
    } else {
      moveTo = index;
    }
    _yController.value = 1.0;
    _xController.animateTo(
        _indexToPosition(moveTo) / MediaQuery.of(context).size.width,
        duration: Duration(milliseconds: 620));
    Future.delayed(
      Duration(milliseconds: 100),
      () {
        _yController.animateTo(1.0, duration: Duration(milliseconds: 1200));
      },
    );
    _yController.animateTo(0.0, duration: Duration(milliseconds: 300));
  }

  void onBottomIconPressed(int index) {
    final state = context.bloc<PageBloc>().state;
    final lastAccountPage = context.bloc<PageBloc>().lastAccountPage;
    final lastCartPage = context.bloc<PageBloc>().lastCartPage;

    switch (index) {
      case 0:
        if (state.pageType != PageType.home)
          context.bloc<PageBloc>().add(PageTransition(PageType.home));
        break;
      case 1:
        if (state.pageType != PageType.categories)
          context.bloc<PageBloc>().add(PageTransition(PageType.categories));
        break;
      case 2:
        if (lastCartPage is PaymentPageState &&
            BlocProvider.of<AuthBloc>(context).isAuthenticated == true) {
          context.bloc<PageBloc>().add(GoToPayment(
              itemsCount: lastCartPage.itemsCount,
              totalPrice: lastCartPage.totalPrice));
        } else {
          context.bloc<PageBloc>().add(PageTransition(PageType.cart));
        }
        break;
      case 3:
        if (state.pageType != PageType.wishlist)
          context.bloc<PageBloc>().add(PageTransition(PageType.wishlist));
        break;
      case 4:
        if (state.pageType != lastAccountPage)
          context.bloc<PageBloc>().add(PageTransition(lastAccountPage));
        break;
      default:
        if (!(state.pageType == PageType.home))
          context.bloc<PageBloc>().add(PageTransition(PageType.home));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    final height = AppTheme.fullHeight(context) * 0.06;
    return BlocListener<PageBloc, PageState>(
      listener: (context, state) {
        if (state is SignInPageState) {
          _handlePressed(4, false);
        } else if (state is SignUpPageState) {
          _handlePressed(4, false);
        } else if (state is ProfilePageState) {
          _handlePressed(4, false);
        } else if (state is HomePageState) {
          _handlePressed(0, false);
        } else if (state is CategoriesPageState) {
          _handlePressed(1, false);
        } else if (state is SubCategoriesPageState) {
          _handlePressed(1, false);
        } else if (state is CartPageState) {
          _handlePressed(2, false);
        } else if (state is OrdersHistoryState) {
          _handlePressed(2, false);
        }
      },
      child: Container(
        width: appSize.width,
        height: AppTheme.fullHeight(context) * 0.06,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              width: appSize.width,
              height: height,
              child: _buildBackground(),
            ),
            Positioned(
              left: (appSize.width - _getButtonContainerWidth()) / 2,
              top: 0,
              width: _getButtonContainerWidth(),
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _icon(Icons.home, _selectedIndex == 0, 0),
                  _icon(Icons.apps, _selectedIndex == 1, 1),
                  _icon(Icons.shopping_cart, _selectedIndex == 2, 2),
                  _icon(Icons.favorite_border, _selectedIndex == 3, 3),
                  _icon(Icons.account_circle, _selectedIndex == 4, 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
