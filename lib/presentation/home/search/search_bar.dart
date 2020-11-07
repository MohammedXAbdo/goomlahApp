import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/presentation/home/search/bloc/search_bloc.dart';
import 'package:goomlah/presentation/home/search/search_field.dart';
import 'package:goomlah/presentation/widgets/icon_widget.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:select_dialog/select_dialog.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key key,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController controller;
  bool showClearSearch = false;
  List<Category> allCategories;
  bool isArabic = true;
  @override
  void initState() {
    controller = TextEditingController();
    controller.addListener(() {
      if (controller.text.length > 0) {
        if (!showClearSearch)
          setState(() {
            showClearSearch = true;
          });
      } else {
        if (showClearSearch) {
          setState(() {
            showClearSearch = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isArabic = EasyLocalization.of(context).locale.languageCode == 'ar';
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is AllCategoriesSucceed) {
          allCategories = state.categories;
          if (allCategories.isNotEmpty) {
            showCategoriesList();
          }
        }
      },
      child: Container(
        margin: AppTheme.getPadding(context),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SearchField(controller: controller),
                    if (showClearSearch) ...[
                      GestureDetector(
                        onTap: () {
                          controller.clear();
                          FocusScope.of(context).requestFocus(new FocusNode());
                          BlocProvider.of<SearchBloc>(context)
                              .add(ClearSearchPage());
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppTheme.fullWidth(context) * 0.03,
                            vertical: AppTheme.fullHeight(context) * 0.01,
                          ),
                          child: Container(
                            child: Align(
                              alignment: isArabic
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Icon(
                                Icons.clear,
                                color: LightColor.orange,
                                size: AppTheme.fullWidth(context) * 0.045,
                              ),
                            ),
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
            SizedBox(width: AppTheme.fullHeight(context) * 0.024),
            IconWidget(
              icon: Icons.filter_list,
              color: Colors.black54,
              onPressed: () async {
                if (allCategories == null) {
                  BlocProvider.of<SearchBloc>(context).add(GetAllCategoreis());
                } else {
                  showCategoriesList();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  int selectedMethod = 0;
  String selectedItem = "all".tr();

  List<String> getCategoriesNames(List<Category> categories) {
    List<String> names = ["all".tr()];
    for (var category in categories) {
      names.add(isArabic ? category.nameArabic : category.name);
    }
    return names;
  }

  int getCategoryId(String name) {
    if (name == "all".tr()) return -1;
    if (isArabic) {
      for (var category in allCategories) {
        if (category.nameArabic == name) {
          return category.id;
        }
      }
    } else {
      for (var category in allCategories) {
        if (category.name == name) {
          return category.id;
        }
      }
    }
    return -1;
  }

  Future<String> showCategoriesList() {
    return SelectDialog.showModal<String>(
      context,
      label: "select_category".tr(),
      itemBuilder: (context, value, selected) {
        return RadioListTile(
          value: getCategoriesNames(allCategories).indexOf(value),
          groupValue: selectedMethod,
          title: Text(value),
          onChanged: (newValue) {
            setState(() {
              selectedItem = getCategoriesNames(allCategories)[newValue];
              selectedMethod = newValue;
            });
            BlocProvider.of<SearchBloc>(context).selectedCategoryid =
                getCategoryId(selectedItem);
            print(BlocProvider.of<SearchBloc>(context).selectedCategoryid.toString());
            Navigator.pop(context);
          },
          selected: selected,
          activeColor: LightColor.orange,
        );
      },
      titleStyle: TextStyle(color: LightColor.tiraryColor),
      showSearchBox: false,
      selectedValue: selectedItem,
      items: getCategoriesNames(allCategories),
      onChange: (String selected) {
        setState(() {
          selectedItem = selected;
        });
      },
    );
  }
}

// InputField(
//   controller: controller,
//   inputType: TextInputType.multiline,
//   hintText: "search_hint".tr(),
//   perfixIcon: Icons.search,
//   perfixIconColor: LightColor.orange,
//   textInputAction: TextInputAction.search,
//   onSubmitted: (value) {
//     if (value.trim().length > 0) {
//       BlocProvider.of<SearchBloc>(context)
//           .add(SearchByProduct(name: value.trim()));
//     } else {
//       controller.clear();
//     }
//   },
//   onChanged: (value) {
//     if (value.length < 1) {
//       BlocProvider.of<SearchBloc>(context)
//           .add(ClearSearchPage());
//     }
//   },
// ),
