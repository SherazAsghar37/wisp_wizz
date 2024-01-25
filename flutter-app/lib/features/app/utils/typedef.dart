import 'package:dartz/dartz.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef FutureVoid = ResultFuture<void>;
typedef FutureUser = ResultFuture<UserModel>;
typedef FutureNullabeleUser = ResultFuture<UserModel?>;
typedef MapData = Map<String, dynamic>;
