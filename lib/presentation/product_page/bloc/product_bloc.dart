import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/services/online_database_service/database_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({@required this.databaseImpl}) : super(ProductInitial());
  final DatabaseRepository databaseImpl;

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is FetchProductData) {
      yield ProductLoading();
      try {
        if (!await Functions.getNetworkStatus()) {
          throw NetworkFailure();
        }
        // TODO call the API
       final  product =  await databaseImpl.fetchProduct(id: event.id);
        yield ProductSucceed(product: product);
      } on Failure catch (failure) {
        yield ProductFailed(failure: failure);
      }
    }
  }
}
