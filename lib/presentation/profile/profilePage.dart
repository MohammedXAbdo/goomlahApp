import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/user.dart';
import 'package:goomlah/presentation/Register/location_bloc/location_bloc.dart';
import 'package:goomlah/presentation/orders_history/bloc/orders_bloc.dart';
import 'package:goomlah/presentation/orders_history/orders_list.dart';
import 'package:goomlah/presentation/profile/bloc/profile_bloc.dart';
import 'package:goomlah/presentation/widgets/cached_image.dart';
import 'package:goomlah/presentation/widgets/common_button.dart';
import 'package:goomlah/presentation/widgets/icon_widget.dart';
import 'package:goomlah/presentation/widgets/input_filed.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/Failure/server_validation_error.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:goomlah/utils/vervication/register_client_validator.dart';
import 'package:goomlah/utils/vervication/register_server_validator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  GlobalKey<FormState> _formKey;
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
  EditProfileValidator editCLientValidator = EditProfileValidator();
  RegisterServerValidator registerServerValidator = RegisterServerValidator();

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    BlocProvider.of<ProfileBloc>(context).add(FetchingProfile());
    BlocProvider.of<OrdersBloc>(context).add(FetchOrdersHistory());

    nameNode = FocusNode();
    phoneNode = FocusNode();
    addressNode = FocusNode();
    passwordNode = FocusNode();
    confirmNode = FocusNode();
    super.initState();
  }

  String welcomeMessage;
  User user;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, ordersState) =>
          BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFetchingSucceed) {
            welcomeMessage = "welcome".tr() + " " + state.user.name;
            user = state.user;
          } else if (state is ProfileFetchingFailed) {
            Scaffold.of(context).showSnackBar(
                Functions.getSnackBar(message: state.failure.code));
          } else if (state is EditProfileFailed) {
            if (state.failure is NetworkFailure) {
              Scaffold.of(context).showSnackBar(
                  Functions.getSnackBar(message: state.failure.code));
            }
          } else if (state is EditProfileSucceed) {
            Scaffold.of(context).showSnackBar(
                Functions.getSnackBar(message: "edit_succeed".tr()));
            name = null;
            phone = null;
            address = null;
            password = null;
            confirmPassword = null;
            latitude = null;
            longitude = null;
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || ordersState is OrdersLoading) {
            return Center(
              child: CircularProgressIndicator(
                  backgroundColor: LightColor.secondryColor),
            );
          }
          if (welcomeMessage != null && user != null) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          width: AppTheme.fullHeight(context) * 0.15,
                          height: AppTheme.fullHeight(context) * 0.15,
                          child: CachedImage(url: 'assets/avatar5.png'),
                        ),
                        SizedBox(height: AppTheme.fullHeight(context) * 0.03),
                        Center(
                          child: Text(
                            welcomeMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: AppTheme.fullHeight(context) * 0.028,
                                fontWeight: FontWeight.w600,
                                color: LightColor.tiraryColor),
                          ),
                        ),
                        if (ordersState is OrdersSucceed) ...[
                          if (ordersState.orders.length > 0) ...[
                            SizedBox(
                                height: AppTheme.fullHeight(context) * 0.03),
                            Text(
                              "orders_history".tr(),
                              style: TextsStyle.homeItem(context),
                            ),
                            SizedBox(
                                height: AppTheme.fullHeight(context) * 0.02),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      AppTheme.fullWidth(context) * 0.1),
                              child: OrdersList(
                                key: GlobalKey(),
                                orders: ordersState.orders,
                                emptyMessage: SizedBox(),
                              ),
                            )
                          ]
                        ],
                        Padding(
                          padding: EdgeInsets.only(
                            top: AppTheme.fullHeight(context) * 0.01,
                            right: AppTheme.fullWidth(context) * 0.1,
                            left: AppTheme.fullWidth(context) * 0.1,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: AppTheme.fullHeight(context) * 0.02),
                              Text(
                                "edit_info".tr(),
                                style: TextsStyle.homeItem(context),
                              ),
                              SizedBox(
                                  height: AppTheme.fullHeight(context) * 0.02),
                              InputField(
                                textCapitalization: TextCapitalization.words,
                                focusNode: nameNode,
                                nextNode: phoneNode,
                                initialValue: user.name,
                                perfixIcon: Icons.account_box,
                                textInputAction: TextInputAction.next,
                                onSaved: (value) => name = value,
                                validator: (value) =>
                                    editCLientValidator.nameValidator(value),
                              ),
                              SizedBox(
                                  height: AppTheme.fullHeight(context) * 0.03),
                              InputField(
                                  focusNode: phoneNode,
                                  nextNode: passwordNode,
                                  inputType: TextInputType.phone,
                                  initialValue: user.phone,
                                  perfixIcon: Icons.phone,
                                  errorText: registerServerValidator
                                      .setEditProfileError<
                                          PhoneValidationError>(state),
                                  textInputAction: TextInputAction.next,
                                  onSaved: (value) => phone = value,
                                  validator: (value) =>
                                      editCLientValidator.phoneValidator(value),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ]),
                              SizedBox(
                                  height: AppTheme.fullHeight(context) * 0.03),
                              InputField(
                                focusNode: passwordNode,
                                nextNode: confirmNode,
                                hintText: 'new_password_hint'.tr(),
                                obscureText: true,
                                perfixIcon: Icons.lock,
                                textInputAction: TextInputAction.next,
                                onSaved: (value) => password = value.trim(),
                                validator: (value) => editCLientValidator
                                    .shortPasswordValidator(value.trim()),
                                onChanged: (value) => password = value.trim(),
                              ),
                              SizedBox(
                                  height: AppTheme.fullHeight(context) * 0.03),
                              InputField(
                                  focusNode: confirmNode,
                                  hintText: "confirm_password_hint".tr(),
                                  obscureText: true,
                                  perfixIcon: Icons.lock,
                                  textInputAction: TextInputAction.done,
                                  onSaved: (value) =>
                                      confirmPassword = value.trim(),
                                  onSubmitted: (value) => confirm(),
                                  validator: (value) => editCLientValidator
                                      .confirmPassword(password, value)),
                              SizedBox(
                                  height: AppTheme.fullHeight(context) * 0.03),
                              CommonButton(
                                  onPressed: () => confirm(),
                                  label: 'save_changes'.tr()),
                              SizedBox(
                                  height: AppTheme.fullHeight(context) * 0.03),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                state is ProfileEditingLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            backgroundColor: LightColor.secondryColor),
                      )
                    : SizedBox.shrink()
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  BlocBuilder<LocationBloc, LocationState> addressField() {
    return BlocBuilder<LocationBloc, LocationState>(
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
                    initialValue: address ?? user.address,
                    enabled: false,
                    focusNode: addressNode,
                    nextNode: passwordNode,
                    perfixIcon: Icons.location_on,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(width: AppTheme.fullWidth(context) * 0.05),
                IconWidget(
                  icon: Icons.location_on,
                  color: address == null ? Colors.red : LightColor.orange,
                  onPressed: () {
                    BlocProvider.of<LocationBloc>(context).add(GetLocation());
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
    );
  }

  void confirm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if ((user.name == name && user.phone == phone.toString()) &&
          (password == null || password.isEmpty)) {
        Scaffold.of(context).showSnackBar(
            Functions.getSnackBar(message: "nothing_changed".tr() + " !"));
      } else {
        BlocProvider.of<ProfileBloc>(context).add(EditingProfile(
          name: name,
          phone: phone,
          password: password.isEmpty ? null : password,
        ));
      }
    }
  }
}
