import 'package:wisp_wizz/features/app/utils/typedef.dart';

abstract class UsecaseWithoutParam<Type> {
  const UsecaseWithoutParam();
  ResultFuture<Type> call();
}

abstract class UsecaseWithParam<Type, Param> {
  const UsecaseWithParam();
  ResultFuture<Type> call(Param param);
}
