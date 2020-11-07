import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/Register/bloc/account_bloc.dart';
import 'package:goomlah/themes/theme.dart';

class CustomForm extends StatefulWidget {
  CustomForm({
    Key key,
    @required this.blocListenerFunction,
    this.padding,
    @required this.onSubmit,
    @required this.inputFields,
  }) : super(key: key);
  final Function(AccountState) blocListenerFunction;
  final EdgeInsetsGeometry padding;
  final List<Widget> Function(
    AccountState state,
    Function confirm,
  ) inputFields;
  final Function onSubmit;

  @override
  _CustonFormState createState() => _CustonFormState();
}

class _CustonFormState extends State<CustomForm> {
  GlobalKey<FormState> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(listener: (context, state) {
      if (widget.blocListenerFunction != null) {
        widget.blocListenerFunction(state);
      }
    }, builder: (context, state) {
      return Form(
        key: formKey,
        child: Padding(
          padding: widget.padding ??
              EdgeInsets.only(
                top: AppTheme.fullHeight(context) * 0.05,
                right: AppTheme.fullWidth(context) * 0.1,
                left: AppTheme.fullWidth(context) * 0.1,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.inputFields(
              state,
              confirm,
            ),
          ),
        ),
      );
    });
  }

  void confirm() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (widget.onSubmit != null) {
        widget.onSubmit();
      }
    }
  }
}
