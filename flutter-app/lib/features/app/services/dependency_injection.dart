import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/auth/data/datasources/firebase_authentication.dart';
import 'package:wisp_wizz/features/auth/data/datasources/remote_data_source.dart';
import 'package:wisp_wizz/features/auth/data/repositories/auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/get_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/verify_otp_usecase.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/auth-bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //state management
  sl
    ..registerFactory<AuthBloc>(() => AuthBloc(
        loginUser: sl(), sendCode: sl(), verifyOTP: sl(), getUser: sl()))
    //usecases
    ..registerLazySingleton<SendCode>(() => SendCode(authRepository: sl()))
    ..registerLazySingleton<VerifyOTP>(() => VerifyOTP(authRepository: sl()))
    ..registerLazySingleton<LoginUser>(() => LoginUser(authRepository: sl()))
    ..registerLazySingleton<GetUser>(() => GetUser(authRepository: sl()))
    //repositories
    ..registerLazySingleton<IAuthRepository>(() =>
        AuthRepository(remoteDataSource: sl(), firebaseAuthentication: sl()))
    //data sources
    ..registerLazySingleton<RemoteDatasource>(() => RemoteDatasource(dio: sl()))
    ..registerLazySingleton<FirebaseAuthentication>(() =>
        FirebaseAuthentication(auth: sl(), phoneAuthProviderWrapper: sl()))
    //external dependency
    ..registerLazySingleton<Dio>(() => Dio(BaseOptions(
          baseUrl: baseUrl,
        )))
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<PhoneAuthProviderWrapper>(
        () => PhoneAuthProviderWrapper());
}
