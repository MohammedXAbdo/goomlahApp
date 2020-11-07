import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/Register/bloc/account_bloc.dart';
import 'package:goomlah/presentation/widgets/custom_form.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/widgets/common_button.dart';
import 'package:goomlah/presentation/widgets/input_filed.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/Failure/server_validation_error.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:goomlah/utils/vervication/register_client_validator.dart';
import 'package:goomlah/utils/vervication/register_server_validator.dart';
import 'package:easy_localization/easy_localization.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phone;
  String password;
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  SignInCLientValidator signInCLientValidator = SignInCLientValidator();
  RegisterServerValidator registerServerValidator = RegisterServerValidator();
  @override
  void initState() {
    phoneNode = FocusNode();
    passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    phoneNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomForm(
          blocListenerFunction: (state) => handleListener(state),
          inputFields: (state, confirm) => [
                InputField(
                  nextNode: passwordNode,
                  focusNode: phoneNode,
                  errorText: registerServerValidator
                      .setSignInError<PhoneValidationError>(state),
                  onSaved: (value) => phone = value,
                  textInputAction: TextInputAction.next,
                  inputType: TextInputType.number,
                  hintText: 'phone_hint'.tr(),
                  perfixIcon: Icons.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validator: (value) =>
                      signInCLientValidator.phoneValidator(value.trim()),
                ),
                SizedBox(height: AppTheme.fullHeight(context) * 0.05),
                InputField(
                  focusNode: passwordNode,
                  errorText: registerServerValidator
                      .setSignInError<PasswordValidationError>(state),
                  textInputAction: TextInputAction.done,
                  onSaved: (value) => password = value,
                  obscureText: true,
                  hintText: 'password_hint'.tr(),
                  onSubmitted: (value) => confirm(),
                  perfixIcon: Icons.lock,
                  validator: (value) =>
                      signInCLientValidator.passwordValidator(value.trim()),
                ),
                SizedBox(height: AppTheme.fullHeight(context) * 0.05),
                CommonButton(
                  label: 'login'.tr(),
                  onPressed: () => confirm(),
                ),
                SizedBox(height: AppTheme.fullHeight(context) * 0.05),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<PageBloc>(context)
                        .add(PageTransition(PageType.signUp));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "dont_have_an_account".tr() + " ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: LightColor.titleTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "register_now".tr() + ".",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: LightColor.titleTextColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
          onSubmit: () => onSubmit()),
    );
  }

  void handleListener(AccountState state) {
    if (state is SignInFailed) {
      if (state.failure is NetworkFailure ||
          state.failure is UnimplementedFailure) {
        Scaffold.of(context)
            .showSnackBar(Functions.getSnackBar(message: state.failure.code));
      }
    } else if (state is SignInSucceed) {
      context.bloc<PageBloc>().add(PageTransition(PageType.profile));
    }
  }

  void onSubmit() {
    BlocProvider.of<AccountBloc>(context)
        .add(SignInEvent(phone: phone, password: password));
  }
}
