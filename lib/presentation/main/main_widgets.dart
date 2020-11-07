import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/Register/bloc/account_bloc.dart';
import 'package:goomlah/presentation/main/main_page_body.dart';
import 'package:goomlah/presentation/main/title.dart';
import 'package:goomlah/presentation/widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:goomlah/themes/theme.dart';

import 'app_bar.dart';
import 'bloc/page_bloc.dart';

class MainWidgets extends StatefulWidget {
  const MainWidgets({
    Key key,
  }) : super(key: key);

  @override
  _MainWidgetsState createState() => _MainWidgetsState();
}

class _MainWidgetsState extends State<MainWidgets> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) => handleAccountListener(state),
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: AbsorbPointer(
            absorbing: state is Loading,
            child: SingleChildScrollView(
              child: Container(
                height: AppTheme.fullHeight(context),
                child: SafeArea(
                  child: Column(
                    children: [
                      UpperAppBar(),
                      ApplicationTitle(),
                      Expanded(child: MainPageBody()),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: AppTheme.fullHeight(context) * 0.01),
                          child: CustomBottomNavigationBar(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void handleAccountListener(AccountState state) {
    if (state is LogoutSucceed) {
      context.bloc<PageBloc>().add(PageTransition(PageType.signIn));
    }
  }
}
