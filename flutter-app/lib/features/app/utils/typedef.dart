import 'package:dartz/dartz.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef Result<T> = Either<Failure, T>;
typedef ResultVoid = Either<Failure, void>;
typedef StreamList<T> = Stream<List<T>>;
typedef ResultStreamList<T> = Result<StreamList<T>>;
typedef FutureVoid = ResultFuture<void>;
typedef FutureUser = ResultFuture<UserModel>;
typedef FutureNullabeleUser = ResultFuture<UserModel?>;
typedef NullabeleUser = Result<UserModel?>;
typedef MapData = Map<String, dynamic>;
