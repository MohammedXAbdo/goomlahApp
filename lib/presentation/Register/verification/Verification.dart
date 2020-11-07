import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/Register/verification/bloc/verification_bloc.dart';
import 'package:goomlah/presentation/main/bloc/page_bloc.dart';
import 'package:goomlah/presentation/widgets/common_button.dart';
import 'package:goomlah/presentation/widgets/input_filed.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:goomlah/utils/vervication/register_client_validator.dart';
import 'package:easy_localization/easy_localization.dart';

class Verification extends StatefulWidget {
  const Verification({Key key}) : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  String submittedCode;
  String acutalCode;
  final FocusNode codeNode = FocusNode();
  GlobalKey<FormState> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    BlocProvider.of<VerificationBloc>(context).add(GetVerficationEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    VerificationClientValidator clientValidator = VerificationClientValidator();
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: BlocConsumer<VerificationBloc, VerificationState>(
          listener: (context, state) {
            if (state is PostVerficationSucceed) {
              context.bloc<PageBloc>().add(PageTransition(PageType.profile));
            } else if (state is VerificationFailed) {
              Scaffold.of(context).showSnackBar(
                  Functions.getSnackBar(message: state.failure.code));
            }
          },
          builder: (context, state) {
            if (state is GetVerficationSucceed) {
              acutalCode = state.verificationCode;
            }
            return Column(
              children: [
                SizedBox(height: AppTheme.fullHeight(context) * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.fullWidth(context) * 0.1,
                  ),
                  child: Form(
                    key: formKey,
                    child: InputField(
                        key: GlobalKey(),
                        initialValue: acutalCode,
                        focusNode: codeNode,
                        hintText: 'verify_hint'.tr(),
                        perfixIcon: Icons.sms,
                        onSubmitted: (value) => onSubmit(),
                        onSaved: (value) => submittedCode = value.trim(),
                        validator: (value) {
                          if (state is GetVerficationSucceed) {
                            return clientValidator.codeValidator(value,
                                actualCode: state.verificationCode);
                          }
                          return clientValidator.codeValidator(value);
                        }),
                  ),
                ),
                SizedBox(height: AppTheme.fullHeight(context) * 0.03),
                state is VerificationLoading || state is VerificationInitial
                    ? CommonButton(isLoading: true)
                    : CommonButton(
                        onPressed: () => onSubmit(), label: 'verify'.tr()),
              ],
            );
          },
        ),
      ),
    );
  }

  void handleListener(state) {
    if (state is VerificationFailed) {
      if (state.failure is NetworkFailure ||
          state.failure is UnimplementedFailure) {
        Scaffold.of(context)
            .showSnackBar(Functions.getSnackBar(message: state.failure.code));
      }
    }
  }

  void onSubmit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      BlocProvider.of<VerificationBloc>(context)
          .add(PostVerficationEvent(submittedCode: submittedCode));
    }
  }
}
