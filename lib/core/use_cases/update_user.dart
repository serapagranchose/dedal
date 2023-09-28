import 'dart:async';

import 'package:dedal/core/datasources/local_storage_datasource.dart';
import 'package:wyatt_architecture/wyatt_architecture.dart';
import 'package:wyatt_type_utils/wyatt_type_utils.dart';

class UpdateUser extends AsyncUseCase<String?, NoParam> {
  UpdateUser({
    required this.localStorageDataSource,
  });

  LocalStorageDataSource localStorageDataSource;

  @override
  FutureOr<void> onStart(String? params) {
    if (params == null) {
      throw const ClientException('params not valid');
    }
  }

  @override
  FutureOrResult<NoParam> execute(String? params) async => Result.tryCatchAsync(
      () => localStorageDataSource
          .setuser(params!)
          .then((value) => const NoParam()),
      (error) =>
          error is AppException ? error : ServerException(error.toString()));
}