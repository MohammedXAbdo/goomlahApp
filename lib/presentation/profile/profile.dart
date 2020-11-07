import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/presentation/orders_history/bloc/orders_bloc.dart';
import 'package:goomlah/presentation/orders_history/orders_list.dart';
import 'package:goomlah/presentation/profile/bloc/profile_bloc.dart';
import 'package:goomlah/presentation/widgets/cached_image.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(FetchingProfile());
    BlocProvider.of<OrdersBloc>(context).add(FetchOrdersHistory());
    super.initState();
  }

  String welcomeMessage;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, ordersState) =>
          BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFetchingSucceed) {
            welcomeMessage = "Welcome " + state.user.name;
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || ordersState is OrdersLoading) {
            return Center(
              child: CircularProgressIndicator(
                  backgroundColor: LightColor.secondryColor),
            );
          }
          if (welcomeMessage != null) {
            return Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: AppTheme.fullHeight(context) * 0.05),
                    Container(
                      width: AppTheme.fullHeight(context) * 0.15,
                      height: AppTheme.fullHeight(context) * 0.15,
                      child: CachedImage(url: 'assets/avatar5.png'),
                    ),
                    SizedBox(height: AppTheme.fullHeight(context) * 0.05),
                    Center(
                      child: Text(
                        welcomeMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppTheme.fullHeight(context) * 0.032,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (ordersState is OrdersSucceed) ...[
                      if (ordersState.orders.length > 0) ...[
                        SizedBox(height: AppTheme.fullHeight(context) * 0.03),
                        Text(
                          "orders_history".tr(),
                          style: TextsStyle.homeItem(context),
                        ),
                        SizedBox(height: AppTheme.fullHeight(context) * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppTheme.fullWidth(context) * 0.1),
                          child: OrdersList(
                            orders: ordersState.orders,
                            emptyMessage: SizedBox(),
                          ),
                        )
                      ]
                    ]
                    // SizedBox(height: AppTheme.fullHeight(context) * 0.05),
                    // GestureDetector(
                    //   onTap: () => context.bloc<AccountBloc>().add(LogoutEvent()),
                    //   child: TitleText(
                    //     color: LightColor.orange,
                    //     text: 'log_out'.tr(),
                    //     fontSize: AppTheme.fullHeight(context) * 0.025,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
