import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/categories/categories_grid_view.dart';
import 'package:goomlah/presentation/categories/empty_list.dart';
import 'package:goomlah/presentation/categories/loading_categories.dart';
import 'package:goomlah/presentation/categories/sub_categories/bloc/subcategories_bloc.dart';
import 'package:goomlah/presentation/widgets/products_grid_view.dart';
import 'package:goomlah/presentation/widgets/try_again.dart';
import 'package:goomlah/presentation/wishlist/bloc/wish_list_bloc.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:easy_localization/easy_localization.dart';

class SubCategoriesPage extends StatefulWidget {
  final int pageIndex;
  final Category category;
  const SubCategoriesPage(
      {Key key, @required this.pageIndex, @required this.category})
      : super(key: key);

  @override
  _SubCategoriesPageState createState() => _SubCategoriesPageState();
}

class _SubCategoriesPageState extends State<SubCategoriesPage>
    with AutomaticKeepAliveClientMixin {
  List<Category> categories;
  List<Product> products;
  @override
  void initState() {
    if (widget.pageIndex != 1) {
      BlocProvider.of<SubCategoriesBloc>(context).add(FetchingSubCategories(
        categoryID: widget.category.id,
        page: widget.pageIndex,
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<SubCategoriesBloc, SubCategoriesState>(
      listener: (context, state) => handleBlocListener(state),
      builder: (context, state) => handleBlocBuilder(state),
    );
  }

  void handleBlocListener(SubCategoriesState state) {
    if (sameCategoryAndPage(state)) {
      if (state is SubCategoriesFailed) {
        Scaffold.of(context)
            .showSnackBar(Functions.getSnackBar(message: state.failure.code));
      } else if (state is CategoriesAndProducts) {
        products = state.products;
        categories = state.categories;
      } else if (state is ContainCategories) {
        categories = state.categories;
      } else if (state is ContainProducts) {
        products = state.products;
      }
    }
  }

  Widget handleBlocBuilder(SubCategoriesState state) {
    if (sameCategoryAndPage(state)) {
      if (state is CategoriesAndProducts) {
        products = state.products;
        categories = state.categories;
      } else if (state is ContainCategories) {
        categories = state.categories;
      } else if (state is ContainProducts) {
        products = state.products;
      }
    }
    if (products != null && categories != null) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: AppTheme.fullHeight(context) * 0.024,
                left: AppTheme.fullWidth(context) * 0.048,
                right: AppTheme.fullWidth(context) * 0.048,
              ),
              child: Text(
                'subcategories'.tr(),
                style: TextsStyle.homeItem(context),
              ),
            ),
            CategoriesGridView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              categories: categories,
              mainCategory: widget.category,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: AppTheme.fullHeight(context) * 0.024,
                left: AppTheme.fullWidth(context) * 0.048,
                right: AppTheme.fullWidth(context) * 0.048,
              ),
              child: Text(
                'products'.tr(),
                style: TextsStyle.homeItem(context),
              ),
            ),
            productsView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      );
    } else if (categories != null) {
      if (categories.length < 1) return EmptyList();
      return CategoriesGridView(
        categories: categories,
        mainCategory: widget.category,
      );
    } else if (products != null) {
      if (products.length < 1) return EmptyList();
      return productsView();
    } else if (state is SubCategoriesLoading) {
      return LoadingCategoriesList();
    } else if (state is SubCategoriesFailed) {
      return TryAgainButton(onPressed: () => onTryAgain());
    }
    return SizedBox.shrink();
  }

  Widget productsView({shrinkWrap, physics}) {
    return BlocBuilder<WishlistBloc, WishlistState>(builder: (context, state) {
      if (state is WishlistSucceed) {
        final wishListProducts = state.products;
        products = Functions.modifyProducts(
            wishListProducts: wishListProducts, products: products);
        return productsGridView(shrinkWrap: shrinkWrap, physics: physics);
      } else if (state is WishlistFailed) {
        return productsGridView();
      }
      return LoadingCategoriesList();
    });
  }

  bool sameCategoryAndPage(SubCategoriesState state) {
    return state.currentPage == widget.pageIndex &&
        state.categoryId == widget.category.id;
  }

  void onTryAgain() {
    BlocProvider.of<SubCategoriesBloc>(context).add(FetchingSubCategories(
      categoryID: widget.category.id,
      page: widget.pageIndex,
    ));
  }

  Widget productsGridView({shrinkWrap = false, physics}) {
    return ProductsGridView(
      physics: physics,
      shrinkWrap: shrinkWrap ?? false,
      products: products,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(
          vertical: AppTheme.fullHeight(context) * 0.02,
          horizontal: AppTheme.fullWidth(context) * 0.1),
      sliverGridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.8 / 3.5,
          crossAxisSpacing: AppTheme.fullWidth(context) * 0.025,
          mainAxisSpacing: AppTheme.fullHeight(context) * 0.025),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
