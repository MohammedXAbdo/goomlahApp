import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/widgets/custom_page_view.dart';
import 'package:goomlah/presentation/categories/main_categories/main_categories_page.dart';
import 'package:goomlah/presentation/categories/main_categories/main_category_bloc/main_category_bloc.dart';
import 'package:goomlah/presentation/categories/loading_categories.dart';
import 'package:goomlah/presentation/widgets/try_again.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/utils/functions/functions.dart';

class MainCategoriesSettings extends StatefulWidget {
  const MainCategoriesSettings({Key key}) : super(key: key);

  @override
  _MainCategoriesSettingsState createState() => _MainCategoriesSettingsState();
}

class _MainCategoriesSettingsState extends State<MainCategoriesSettings> {
  PageController controller = PageController(keepPage: true);
  List<Widget> pages;
  bool loadedPagesCount = false;
  int totalMainPages = 1;

  @override
  void initState() {
    BlocProvider.of<MainCategoriesBloc>(context).add(FetchMainCategories(1));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: AppTheme.getPadding(context),
          child: Text(
           'all_categories'.tr(),
            style: TextsStyle.subTitle(context),
          ),
        ),
        Expanded(
          child: BlocConsumer<MainCategoriesBloc, MainCategoriesState>(
            listenWhen: (previous, current) => !loadedPagesCount,
            buildWhen: (previous, current) => !loadedPagesCount,
            listener: (context, state) => handleBlocListener(state),
            builder: (context, state) => hanldeBlocBuilder(state),
          ),
        ),
      ],
    );
  }

  Widget hanldeBlocBuilder(MainCategoriesState state) {
    if (state is MainCategoriesSucceed) {
      loadedPagesCount = true;
      totalMainPages = state.lastPage;
      List<Widget> newPages = [];
      for (int i = 1; i <= totalMainPages; i++) {
        newPages.add(MainCategoriesPage(pageIndex: i));
      }
      pages = newPages;
    } else if (state is MainCategoriesLoading ||
        state is MainCategoriesIntial) {
      return LoadingCategoriesList();
    } else if (state is MainCategoriesFailed) {
      return TryAgainButton(onPressed: () => onTryAgain());
    }
    return pages != null
        ? CustomPageView(
            controller: controller,
            pages: pages,
            totalPages: totalMainPages,
          )
        : TryAgainButton(onPressed: () => onTryAgain());
  }

  void handleBlocListener(MainCategoriesState state) {
    if (state is MainCategoriesFailed) {
      Scaffold.of(context)
          .showSnackBar(Functions.getSnackBar(message: state.failure.code));
    }
  }

  void onTryAgain() {
    BlocProvider.of<MainCategoriesBloc>(context).add(FetchMainCategories(1));
  }
}
