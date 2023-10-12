import 'dart:async';

import 'package:dedal/core/datasources/filters/filters_datasource.dart';
import 'package:dedal/core/models/place.dart';
import 'package:dedal/core/models/user.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';
import 'package:wyatt_type_utils/wyatt_type_utils.dart';

class UserGetPlace extends AsyncUseCase<User, List<Place>?> {
  UserGetPlace({
    required this.filterDataSource,
  });

  FilterDataSource filterDataSource;

  @override
  FutureOr<void> onStart(User? params) {
    if (params == null) {
      throw const ClientException('params not valid');
    }
  }

  @override
  FutureOrResult<List<Place>?> execute(User? params) async =>
      Result.tryCatchAsync(
          () => filterDataSource.getPlaces(params!),
          (error) => error is AppException
              ? error
              : ServerException(error.toString()));
}