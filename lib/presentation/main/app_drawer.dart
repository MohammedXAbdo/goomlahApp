import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/home/search/bloc/search_bloc.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/main/drawer_List_items.dart';
import 'package:goomlah/presentation/profile/Auth_bloc/auth_bloc.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    Key key,
  }) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isAuthenticated = false;
  PageType pageType;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    pageType = BlocProvider.of<PageBloc>(context).state.pageType;
    FocusScope.of(context).requestFocus(new FocusNode());

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PageBloc, PageState>(
      listener: (context, state) {
        pageType = state.pageType;
      },
      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        isAuthenticated = state is IsAuthenticatedState;
        return Drawer(
          child: Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                Expanded(
                  child: DrawerListItems(pageType: pageType),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: AppTheme.fullHeight(context) * 0.08),
                  child: DrawerLanguagesItems(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class DrawerLanguagesItems extends StatelessWidget {
  const DrawerLanguagesItems({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LanguageItem(language: 'english'.tr(), languageCode: 'en'),
        SizedBox(height: AppTheme.fullHeight(context) * 0.02),
        LanguageItem(language: 'arabic'.tr(), languageCode: 'ar'),
      ],
    );
  }
}

class LanguageItem extends StatelessWidget {
  final String language;
  final String languageCode;
  const LanguageItem({
    Key key,
    @required this.language,
    @required this.languageCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected =
        EasyLocalization.of(context).locale.languageCode == languageCode;
    return GestureDetector(
      onTap: () {
        EasyLocalization.of(context).locale = Locale(languageCode);
        BlocProvider.of<SearchBloc>(context).add(ClearSearchPage());
        Navigator.pop(context);
      },
      child: Text(
        language,
        style: TextStyle(
          color: isSelected ? LightColor.orange : LightColor.menuTextColor,
          fontWeight: FontWeight.w600,
          fontSize: AppTheme.fullHeight(context) * 0.02,
        ),
      ),
    );
  }
}
