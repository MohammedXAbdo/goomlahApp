import 'package:flutter/material.dart';
import 'package:goomlah/presentation/widgets/common_button.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class TryAgainButton extends StatelessWidget {
  final Function onPressed;
  const TryAgainButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: AppTheme.fullHeight(context) * .06,
        width: AppTheme.fullWidth(context) * 0.4,
        child: CommonButton(
          label: 'try_again'.tr(),
          onPressed: () {
            if (onPressed != null) {
              onPressed();
            }
          },
        ),
      ),
    );
  }
}
