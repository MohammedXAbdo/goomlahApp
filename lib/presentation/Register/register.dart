import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/Register/location_bloc/location_bloc.dart';
import 'package:goomlah/presentation/widgets/custom_form.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/widgets/common_button.dart';
import 'package:goomlah/presentation/widgets/icon_widget.dart';
import 'package:goomlah/presentation/widgets/input_filed.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/Failure/server_validation_error.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:goomlah/utils/vervication/register_client_validator.dart';
import 'package:goomlah/utils/vervication/register_server_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'bloc/account_bloc.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

SignUpCLientValidator signUpCLientValidator = SignUpCLientValidator();
RegisterServerValidator registerServerValidator = RegisterServerValidator();

class _RegisterState extends State<Register> {
  String name;
  String phone;
  String address;
  String password;
  String confirmPassword;
  double latitude;
  double longitude;
  FocusNode nameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmNode = FocusNode();
  @override
  void initState() {
    nameNode = FocusNode();
    phoneNode = FocusNode();
    addressNode = FocusNode();
    passwordNode = FocusNode();
    confirmNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    nameNode.dispose();
    phoneNode.dispose();
    addressNode.dispose();
    passwordNode.dispose();
    confirmNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomForm(
          blocListenerFunction: (state) => handleListener(state),
          onSubmit: () => onSubmit(),
          padding: EdgeInsets.only(
            top: AppTheme.fullHeight(context) * 0.01,
            right: AppTheme.fullWidth(context) * 0.1,
            left: AppTheme.fullWidth(context) * 0.1,
          ),
          inputFields: (state, confirm) => [
                InputField(
                  textCapitalization: TextCapitalization.words,
                  focusNode: nameNode,
                  nextNode: phoneNode,
                  errorText: registerServerValidator
                      .setSignUpError<NameValidationError>(state),
                  hintText: 'name_hint'.tr(),
                  perfixIcon: Icons.account_box,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => name = value,
                  validator: (value) =>
                      signUpCLientValidator.nameValidator(value.trim()),
                ),
                SizedBox(height: AppTheme.fullHeight(context) * 0.05),
                InputField(
                  focusNode: phoneNode,
                  nextNode: passwordNode,
                  errorText: registerServerValidator
                      .setSignUpError<PhoneValidationError>(state),
                  inputType: TextInputType.number,
                  hintText: 'phone_hint'.tr(),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  perfixIcon: Icons.phone,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => phone = value,
                  validator: (value) =>
                      signUpCLientValidator.phoneValidator(value.trim()),
                ),
                SizedBox(height: AppTheme.fullHeight(context) * 0.05),
                BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, locationState) {
                    if (locationState is LocationSucceed) {
                      latitude = locationState.latitude;
                      longitude = locationState.longitude;
                      address = locationState.location;
                    }
                    return Stack(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InputField(
                                key: GlobalKey(),
                                initialValue: address,
                                enabled: false,
                                focusNode: addressNode,
                                nextNode: passwordNode,
                                hintText: 'address_hint'.tr(),
                                perfixIcon: Icons.location_on,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            SizedBox(width: AppTheme.fullWidth(context) * 0.05),
                            IconWidget(
                              icon: Icons.location_on,
                              color: address == null
                                  ? Colors.red
                                  : LightColor.orange,
                              onPressed: () {
                                BlocProvider.of<LocationBloc>(context)
                                    .add(GetLocation());
                              },
                            )
                          ],
                        ),
                        locationState is LocationLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: LightColor.secondryColor),
                              )
                            : SizedBox.shrink(),
                      ],
                    );
                  },
                ),
                SizedBox(height: AppTheme.fullHeight(context) * 0.05),
                InputField(
                  focusNode: passwordNode,
                  nextNode: confirmNode,
                  errorText: registerServerValidator
                      .setSignUpError<PasswordValidationError>(state),
                  hintText: 'password_hint'.tr(),
                  obscureText: true,
                  perfixIcon: Icons.lock,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => password = value,
                  validator: (value) =>
                      signUpCLientValidator.passwordValidator(value.trim()),
                  onChanged: (value) => password = value.trim(),
                ),
                SizedBox(height: AppTheme.fullHeight(context) * 0.05),
                InputField(
                  focusNode: confirmNode,
                  hintText: "confirm_password_hint".tr(),
                  obscureText: true,
                  perfixIcon: Icons.lock,
                  textInputAction: TextInputAction.done,
                  onSaved: (value) => confirmPassword = value.trim(),
                  onSubmitted: (value) => confirm(),
                  validator: (value) => signUpCLientValidator.confirmPassword(
                      password.trim(), value.trim()),
                ),
                SizedBox(height: AppTheme.fullHeight(context) * 0.03),
                CommonButton(onPressed: () => confirm(), label: 'sign_up'.tr()),
                SizedBox(height: AppTheme.fullHeight(context) * 0.03),
                GestureDetector(
                    onTap: () {
                      BlocProvider.of<PageBloc>(context)
                          .add(PageTransition(PageType.signIn));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "have_an_account".tr() + " ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: LightColor.titleTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "login".tr() + ".",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: LightColor.titleTextColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: AppTheme.fullHeight(context) * 0.1),
              ]),
    );
  }

  void handleListener(state) {
    if (state is SignUpFailed) {
      if (state.failure is NetworkFailure ||
          state.failure is UnimplementedFailure) {
        Scaffold.of(context)
            .showSnackBar(Functions.getSnackBar(message: state.failure.code));
      }
    } else if (state is SignUpSucceed) {
      BlocProvider.of<PageBloc>(context)
          .add(PageTransition(PageType.verfication));
    }
  }

  onSubmit() {
    if (address == null || latitude == null || longitude == null) {
      Scaffold.of(context).showSnackBar(Functions.getSnackBar(
          message: 'empty_address'.tr(), duration: Duration(seconds: 3)));
    } else {
      BlocProvider.of<AccountBloc>(context).add(SignUpEvent(
        latitude: latitude,
        longitude: longitude,
        name: name,
        phone: phone,
        password: password,
        passwordConfirmation: confirmPassword,
        address: address,
      ));
    }
  }
}
