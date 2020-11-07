import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';

class InputField extends StatefulWidget {
  InputField({
    Key key,
    this.hintText,
    this.perfixIcon,
    this.inputType,
    this.obscureText = false,
    this.onSaved,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.validator,
    this.perfixIconColor,
    this.onChanged,
    this.errorText,
    this.focusNode,
    this.nextNode,
    this.textCapitalization,
    this.initialValue,
    this.enabled = true,
    this.controller,
    this.inputFormatters,
  }) : super(key: key);
  final TextEditingController controller;
  final String hintText;
  final String errorText;
  final IconData perfixIcon;
  final Color perfixIconColor;
  final TextInputType inputType;
  final String initialValue;
  final bool obscureText;
  final Function(String) onSaved;
  final Function(String) onSubmitted;
  final String Function(String) validator;
  final Function(String) onChanged;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final FocusNode nextNode;
  final bool enabled;
  static final bool singleError = false;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatters;
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool focusedbefore = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textInputAction: widget.textInputAction,
        onEditingComplete: () {
          if (widget.textInputAction == TextInputAction.next &&
              widget.nextNode != null) {
            widget.nextNode.requestFocus();
          }
        },
        validator: (value) {
          if (widget.validator != null) {
            return widget.validator(value);
          }
          return null;
        },
        onFieldSubmitted: (value) {
          if (widget.textInputAction == TextInputAction.done ||
              widget.textInputAction == TextInputAction.search) {
            if (widget.onSubmitted != null) {
              widget.onSubmitted(value);
            }
          }
        },
        onSaved: (newValue) {
          if (widget.onSaved != null) {
            widget.onSaved(newValue);
          }
        },
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged(value);
          }
        },
        controller: widget.controller,
        enabled: widget.enabled,
        initialValue: widget.initialValue,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        maxLines: widget.obscureText ? 1 : null,
        minLines: 1,
        focusNode: widget.focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.inputType,
        style: TextStyle(fontSize: AppTheme.fullHeight(context) * 0.017),
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          errorText: widget.errorText,
          errorStyle: TextStyle(fontSize: AppTheme.fullHeight(context) * 0.015),
          filled: true,
          isDense: true,
          fillColor: LightColor.lightGrey.withAlpha(100),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                  Radius.circular(AppTheme.fullWidth(context) * 0.025))),
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: AppTheme.fullHeight(context) * 0.017),
          prefixText: "  ",
          prefixIcon: Icon(widget.perfixIcon,
              color: widget.perfixIconColor ?? LightColor.orange,
              size: AppTheme.fullWidth(context) * 0.045),
        ));
  }
}
