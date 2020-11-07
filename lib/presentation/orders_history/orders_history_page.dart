import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goomlah/model/order.dart';
import 'package:goomlah/presentation/orders_history/bloc/orders_bloc.dart';
import 'package:goomlah/presentation/orders_history/orders_list.dart';
import 'package:goomlah/presentation/widgets/try_again.dart';
import 'package:goomlah/themes/TextStyle.dart';
import 'package:goomlah/themes/light_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:goomlah/themes/theme.dart';
import 'package:goomlah/utils/functions/functions.dart';

class OrdersHistoryPage extends StatefulWidget {
  const OrdersHistoryPage({Key key}) : super(key: key);

  @override
  _OrdersHistoryPageState createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<OrdersHistoryPage> {
  @override
  void initState() {
    BlocProvider.of<OrdersBloc>(context).add(FetchOrdersHistory());
    super.initState();
  }

  List<Order> orders;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is OrdersFailed) {
          Scaffold.of(context)
              .showSnackBar(Functions.getSnackBar(message: state.failure.code));
        } else if (state is OrdersSucceed) {
          orders = state.orders;
        }
      },
      builder: (context, state) {
        if (state is OrdersLoading) {
          return loadingProgress();
        } else if (state is OrdersFailed) {
          return TryAgainButton(
            onPressed: () {
              BlocProvider.of<OrdersBloc>(context).add(FetchOrdersHistory());
            },
          );
        }
        if (orders != null) {
          return Padding(
            padding: AppTheme.getPadding(context),
            child: OrdersList(
              orders: orders,
              emptyMessage: emptyMessage(),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget emptyMessage() {
    return Center(
        child: Text('empty_orders'.tr() + ".",
            style: TextsStyle.noDataMessage(context)));
  }

  Widget loadingProgress() {
    return Center(
        child: CircularProgressIndicator(
            backgroundColor: LightColor.secondryColor));
  }
}
