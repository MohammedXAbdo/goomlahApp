import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/presentation/categories/loading_categories.dart';
import 'package:goomlah/presentation/categories/sub_categories/bloc/subcategories_bloc.dart';
import 'package:goomlah/presentation/categories/sub_categories/sub_categories_page.dart';
import 'package:goomlah/presentation/widgets/custom_page_view.dart';
import 'package:goomlah/presentation/widgets/try_again.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/utils/functions/functions.dart';

class SubCategoriesSettings extends StatefulWidget {
  final Category category;
  SubCategoriesSettings({Key key, @required this.category}) : super(key: key);

  @override
  _SubCategoriesSettingsState createState() => _SubCategoriesSettingsState();
}

class _SubCategoriesSettingsState extends State<SubCategoriesSettings> {
  PageController controller = PageController(keepPage: true);
  List<Widget> pages;
  bool loadedPagesCount = false;
  int totalMainPages = 1;
  @override
  void initState() {
    BlocProvider.of<SubCategoriesBloc>(context)
        .add(FetchingSubCategories(page: 1, categoryID: widget.category.id));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = EasyLocalization.of(context).locale.languageCode == 'ar';
    String arabicName = widget.category.nameArabic;
    String arabicDescription = widget.category.descriptionArabic;
    return Column(
      children: [
        FittedBox(
          child: Text(
            !isArabic
                ? widget.category.name
                : arabicName != null && arabicName.isNotEmpty
                    ? arabicName
                    : widget.category.name,
            style: TextsStyle.subTitle(context),
          ),
        ),
        SizedBox(height: AppTheme.fullHeight(context) * 0.01),
        widget.category.description != null
            ? Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.fullWidth(context) * 0.08),
                child: AutoSizeText(
                  !isArabic
                      ? widget.category.description
                      : arabicDescription != null &&
                              arabicDescription.isNotEmpty
                          ? arabicDescription
                          : widget.category.description,
                  style: TextsStyle.categoryDescription(context),
                ),
              )
            : SizedBox.shrink(),
        Expanded(
          child: BlocConsumer<SubCategoriesBloc, SubCategoriesState>(
            listener: (context, state) => handleBloclistener(state),
            listenWhen: (previous, current) => !loadedPagesCount,
            buildWhen: (previous, current) => !loadedPagesCount,
            builder: (context, state) => handleBlocBuilder(state),
          ),
        ),
      ],
    );
  }

  void handleBloclistener(SubCategoriesState state) {
    if (state is SubCategoriesFailed) {
      Scaffold.of(context)
          .showSnackBar(Functions.getSnackBar(message: state.failure.code));
    }
  }

  Widget handleBlocBuilder(SubCategoriesState state) {
    if (state.categoryId == widget.category.id) {
      if (state is CategoriesAndProducts) {
        totalMainPages = state.lastPage;
        loadedPagesCount = true;
        pages = generatePages(totalMainPages);
      } else if (state is ContainCategories) {
        totalMainPages = state.lastPage;
        loadedPagesCount = true;
        pages = generatePages(totalMainPages);
      } else if (state is ContainProducts) {
        totalMainPages = state.lastPage;
        loadedPagesCount = true;
        pages = generatePages(totalMainPages);
      } else if (state is SubCategoriesLoading) {
        return LoadingCategoriesList();
      } else if (state is SubCategoriesFailed) {
        return TryAgainButton(onPressed: () => onTryAgain());
      }
      return pages != null
          ? CustomPageView(
              controller: controller,
              pages: pages,
              totalPages: totalMainPages,
            )
          : LoadingCategoriesList();
    }
    return LoadingCategoriesList();
  }

  List<Widget> generatePages(int pagesCount) {
    List<Widget> newPages = [];
    for (int i = 1; i <= pagesCount; i++) {
      newPages.add(SubCategoriesPage(pageIndex: i, category: widget.category));
    }
    return newPages;
  }

  void onTryAgain() {
    BlocProvider.of<SubCategoriesBloc>(context)
        .add(FetchingSubCategories(page: 1, categoryID: widget.category.id));
  }
}
