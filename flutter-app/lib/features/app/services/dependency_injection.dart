import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/contacts/data/datasources/contacts_data_source.dart';
import 'package:wisp_wizz/features/contacts/data/datasources/flutter_contacts_wraper.dart';
import 'package:wisp_wizz/features/contacts/data/repositories/contact_repository.dart';
import 'package:wisp_wizz/features/contacts/domain/repository/i_contacts_repository.dart';
import 'package:wisp_wizz/features/contacts/domain/usecases/fetch_contacts.dart';
import 'package:wisp_wizz/features/contacts/presentation/bloc/contact_bloc.dart';
import 'package:wisp_wizz/features/user/data/datasources/auth_firebase_datasource.dart';
import 'package:wisp_wizz/features/user/data/datasources/auth_local_data_source.dart';
import 'package:wisp_wizz/features/user/data/datasources/auth_remote_data_source.dart';
import 'package:wisp_wizz/features/user/data/datasources/socket_manager_wrapper.dart';
import 'package:wisp_wizz/features/user/data/repositories/auth_repository.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/user/domain/usecase/cache_user_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/get_cached_user.dart';
import 'package:wisp_wizz/features/user/domain/usecase/get_user_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/logout_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/send_code_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/update_user_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/verify_otp_usecase.dart';
import 'package:wisp_wizz/features/user/presentation/bloc/auth-bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );
  await sl.getAsync<SharedPreferences>();

  //state management
  sl
    ..registerFactory<AuthBloc>(() => AuthBloc(
        loginUser: sl(),
        sendCode: sl(),
        verifyOTP: sl(),
        getUser: sl(),
        getCachedUser: sl(),
        logoutUser: sl(),
        updateUser: sl(),
        cacheUser: sl()))
    //usecases
    ..registerLazySingleton<SendCode>(() => SendCode(authRepository: sl()))
    ..registerLazySingleton<VerifyOTP>(() => VerifyOTP(authRepository: sl()))
    ..registerLazySingleton<LoginUser>(() => LoginUser(authRepository: sl()))
    ..registerLazySingleton<GetUser>(() => GetUser(authRepository: sl()))
    ..registerLazySingleton<GetCachedUser>(
        () => GetCachedUser(authRepository: sl()))
    ..registerLazySingleton<LogoutUser>(() => LogoutUser(authRepository: sl()))
    ..registerLazySingleton<UpdateUser>(() => UpdateUser(authRepository: sl()))
    ..registerLazySingleton<CacheUser>(() => CacheUser(authRepository: sl()))

    //repositories
    ..registerLazySingleton<IAuthRepository>(() => AuthRepository(
        remoteDataSource: sl(),
        firebaseAuthentication: sl(),
        localDataSource: sl()))
    //data sources
    ..registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasource(dio: sl(), webSocketManagerWrapper: sl()))
    ..registerLazySingleton<AuthFirebaseDatasource>(() =>
        AuthFirebaseDatasource(auth: sl(), phoneAuthProviderWrapper: sl()))
    ..registerLazySingleton<AuthLocalDatasource>(
        () => AuthLocalDatasource(sharedPreferences: sl()))
    //external dependency
    ..registerLazySingleton<Dio>(() => Dio(BaseOptions(
          baseUrl: baseUrl,
        )))
    ..registerLazySingleton<WebSocketManagerWrapper>(
        () => WebSocketManagerWrapper())
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<PhoneAuthProviderWrapper>(
        () => PhoneAuthProviderWrapper());

  sl
    ..registerFactory(() => ContactBloc(fetchContacts: sl()))
    //usecases
    ..registerLazySingleton<FetchContacts>(
        () => FetchContacts(contactReposiotry: sl()))
    //repositories
    ..registerLazySingleton<IContactReposiotry>(
        () => ContactReposiotry(contactDatasource: sl()))
    //data sources
    ..registerLazySingleton<ContactDatasource>(
        () => ContactDatasource(flutterContactsWrapper: sl()))
    //external dependency
    ..registerLazySingleton<FlutterContactsWrapper>(
        () => FlutterContactsWrapper());
}
