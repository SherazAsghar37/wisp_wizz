import 'package:dartz/dartz.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef FutureVoid = ResultFuture<void>;
typedef MapData = Map<String, dynamic>;
