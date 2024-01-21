import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:wisp_wizz/features/app/config/dio_config.dart';
import 'package:wisp_wizz/features/auth/data/datasources/remote_data_source.dart';
import 'package:wisp_wizz/features/auth/data/repositories/auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/verify_otp_usecase.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/auth-bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //state management
  sl
    ..registerFactory<AuthBloc>(
        () => AuthBloc(loginUser: sl(), sendCode: sl(), verifyOTP: sl()))
    //usecases
    ..registerLazySingleton<SendCode>(() => SendCode(authRepository: sl()))
    ..registerLazySingleton<VerifyOTP>(() => VerifyOTP(authRepository: sl()))
    ..registerLazySingleton<LoginUser>(() => LoginUser(authRepository: sl()))
    //repositories
    ..registerLazySingleton<IAuthRepository>(
        () => AuthRepository(remoteDataSource: sl()))
    //data sources
    ..registerLazySingleton<RemoteDatasource>(() => RemoteDatasource(dio: sl()))
    //external dependency
    ..registerLazySingleton<Dio>(() => DioClient.getInstance());
}
