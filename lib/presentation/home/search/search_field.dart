import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/presentation/home/search/bloc/search_bloc.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:goomlah/utils/functions/functions.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      hideSuggestionsOnKeyboardHide: false,
      keepSuggestionsOnLoading: false,
      noItemsFoundBuilder: (context) {
        return EmptyMessage();
      },
      loadingBuilder: (context) {
        return LoadingWidget(controller: controller);
      },
      hideOnError: true,
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        minLines: 1,
        textInputAction: TextInputAction.search,
        decoration: searchDecoration(context),
      ),
      suggestionsCallback: (value) async {
        if (value.isNotEmpty) {
          final result =
              await BlocProvider.of<SearchBloc>(context).searchByProduct(value);
          if (!(result is List<Product>)) {
            return [SizedBox.shrink()];
          }
          return result;
        }
        return [SizedBox.shrink()];
      },
      itemBuilder: (context, suggestion) {
        if (suggestion is SizedBox) {
          return SizedBox.shrink();
        } else if (suggestion is Product) {
          return SuggestionProduct(suggestion: suggestion);
        }
        return SizedBox.shrink();
      },
      onSuggestionSelected: (value) {
        if (value is Product) {
          Functions.goToProductPage(context, value);
        }
      },
    );
  }

  InputDecoration searchDecoration(context) {
    return InputDecoration(
      errorStyle: TextStyle(fontSize: AppTheme.fullHeight(context) * 0.015),
      filled: true,
      isDense: true,
      fillColor: LightColor.lightGrey.withAlpha(100),
      border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
              Radius.circular(AppTheme.fullWidth(context) * 0.025))),
      hintText: "search_hint".tr(),
      hintStyle: TextStyle(fontSize: AppTheme.fullHeight(context) * 0.017),
      prefixText: "  ",
      prefixIcon: Icon(Icons.search,
          color: LightColor.orange, size: AppTheme.fullWidth(context) * 0.045),
    );
  }
}

class SuggestionProduct extends StatelessWidget {
  final Product suggestion;
  const SuggestionProduct({
    Key key,
    @required this.suggestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.fullWidth(context) * 0.03,
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: suggestion.image,
            width: AppTheme.fullWidth(context) * 0.1,
            height: AppTheme.fullWidth(context) * 0.1,
            placeholder: (context, string) => CircularProgressIndicator(
                backgroundColor: LightColor.secondryColor),
          ),
        ),
        title: AutoSizeText(
          suggestion.name,
          maxLines: 1,
          minFontSize: 10,
          maxFontSize: 18,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: AppTheme.fullHeight(context) * 0.018),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: LightColor.orange,
          size: 15,
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final TextEditingController controller;

  const LoadingWidget({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.text.isEmpty) {
      return SizedBox.shrink();
    }
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: AppTheme.fullHeight(context) * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: LightColor.secondryColor,
          ),
        ],
      ),
    );
  }
}

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppTheme.fullWidth(context) * 0.03,
          vertical: AppTheme.fullHeight(context) * 0.01),
      child: Text(
        'empty_search'.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).disabledColor,
            fontSize: AppTheme.fullHeight(context) * 0.018),
      ),
    );
  }
}
