import 'package:wisp_wizz/features/app/utils/typedef.dart';

abstract class UsecaseWithoutParam<Type> {
  const UsecaseWithoutParam();
  ResultFuture<Type> call();
}

abstract class UsecaseWithoutParamSync<Type> {
  const UsecaseWithoutParamSync();
  Result<Type> call();
}

abstract class UsecaseWithParamSync<Type, Param> {
  const UsecaseWithParamSync();
  Result<Type> call(Param param);
}

abstract class UsecaseWithParam<Type, Param> {
  const UsecaseWithParam();
  ResultFuture<Type> call(Param param);
}
