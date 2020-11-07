import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/presentation/categories/categories_grid_view.dart';
import 'package:goomlah/presentation/categories/empty_list.dart';
import 'package:goomlah/presentation/categories/main_categories/main_category_bloc/main_category_bloc.dart';
import 'package:goomlah/presentation/categories/loading_categories.dart';
import 'package:goomlah/presentation/widgets/try_again.dart';
import 'package:goomlah/utils/functions/functions.dart';

class MainCategoriesPage extends StatefulWidget {
  final int pageIndex;
  const MainCategoriesPage({Key key, @required this.pageIndex})
      : super(key: key);

  @override
  _MainCategoriesPageState createState() => _MainCategoriesPageState();
}

class _MainCategoriesPageState extends State<MainCategoriesPage>
    with AutomaticKeepAliveClientMixin 
    {
  List<Category> categories;
  @override
  void initState() {
    if (widget.pageIndex != 1) {
      BlocProvider.of<MainCategoriesBloc>(context)
          .add(FetchMainCategories(widget.pageIndex));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<MainCategoriesBloc, MainCategoriesState>(
        buildWhen: (previous, current) =>
            current.currentPage == widget.pageIndex,
        listenWhen: (previous, current) =>
            current.currentPage == widget.pageIndex,
        listener: (context, state) => handleBlocListener(state),
        builder: (context, state) => handleBlocBuilder(state));
  }

  void handleBlocListener(MainCategoriesState state) {
    if (state.currentPage == widget.pageIndex) {
      if (state is MainCategoriesFailed) {
        Scaffold.of(context)
            .showSnackBar(Functions.getSnackBar(message: state.failure.code));
      }
    }
  }

  Widget handleBlocBuilder(MainCategoriesState state) {
    if (state.currentPage == widget.pageIndex) {
      if (state is MainCategoriesSucceed) {
        if (state.currentPage == widget.pageIndex) {
          categories = state.categories;
        }
      }
      if (categories != null) {
        if (categories.length < 1) return EmptyList();
        return CategoriesGridView(categories: categories);
      } else {
        if (state is MainCategoriesLoading) {
          return LoadingCategoriesList();
        } else if (state is MainCategoriesFailed) {
          return TryAgainButton(onPressed: () => tryAgainAction());
        }
      }
    }
    return SizedBox.shrink();
  }

  void tryAgainAction() {
    BlocProvider.of<MainCategoriesBloc>(context)
        .add(FetchMainCategories(widget.pageIndex));
  }

  @override
  bool get wantKeepAlive => true;
}
