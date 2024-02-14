import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/user/data/datasources/auth_remote_data_source.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/domain/usecase/login_user_usecase.dart';

import '../../../../app/temp_path.dart';

class MDio extends Mock implements Dio {
  @override
  BaseOptions options;
  MDio({required this.options});
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late AuthRemoteDatasource remoteDatasource;
  late Dio dio;
  // MultipartFile? multipartFile;
  final params = CustomUserParam(
      name: "whatever.name",
      phoneNumber: "+92123456789",
      image: tempFile.readAsBytesSync());

  setUp(() {
    dio = MDio(options: BaseOptions(baseUrl: baseUrl));
    remoteDatasource = AuthRemoteDatasource(dio: dio);
    // multipartFile = params.image != null
    //     ? await MultipartFile.fromFile(params.image!.path,
    //         filename: imageFileName)
    //     : null;
  });

  const int statusCode = 500;
  const String errorMessage = "whatever.error";

  UserModel userModel = UserModel.empty();
  MapData userMap = userModel.toMap();
  group("[Auth RemoteDataSource] - ", () {
    group("[Login User] - ", () {
      test("It should post loginUser and return userModel by calling only once",
          () async {
        //Arrange
        when(() => dio.post(
                  any(),
                  data: any(named: "data"),
                ))
            .thenAnswer((invocation) async => Response(
                requestOptions: RequestOptions(),
                statusCode: 201,
                data: jsonEncode({"user": userMap})));
        //Act
        final response = await remoteDatasource.loginUser(
            name: userModel.name,
            phoneNumber: userModel.phoneNumber,
            image: userModel.image);
        //Assert
        expect(response, equals(UserModel.fromMap(userMap)));
        verify(() => dio.post(dio.options.baseUrl + loginUrl, data: {
              "image": base64Encode(userModel.image),
              "name": userModel.name,
              "phoneNumber": userModel.phoneNumber,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
      test(
          "It should call remoteDataSource.loginUser and throw api exception when dio Exception occurs calling only once",
          () async {
        //Arrange
        when(() => dio.post(
                  any(),
                  data: any(named: "data"),
                ))
            .thenThrow(DioException(
                requestOptions: RequestOptions(), message: errorMessage));
        //Act
        final response = remoteDatasource.loginUser(
            name: userModel.name,
            phoneNumber: userModel.phoneNumber,
            image: userModel.image);
        //Assert
        await expectLater(
            response,
            throwsA(const ApiException(
                message: "Internal server error", statusCode: statusCode)));
        verify(() => dio.post(dio.options.baseUrl + loginUrl, data: {
              "image": base64Encode(userModel.image),
              "name": userModel.name,
              "phoneNumber": userModel.phoneNumber,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });

      test(
          "It should call remoteDataSource.loginUser and throw api exception by calling only once",
          () async {
        //Arrange
        when(() => dio.post(
                  any(),
                  data: any(named: "data"),
                ))
            .thenAnswer((invocation) async => Response(
                requestOptions: RequestOptions(),
                statusCode: statusCode,
                data: {"message": errorMessage}));
        //Assert
        await expectLater(
          remoteDatasource.loginUser(
              name: userModel.name,
              phoneNumber: userModel.phoneNumber,
              image: userModel.image),
          throwsA(const ApiException(
            message: errorMessage,
            statusCode: statusCode,
          )),
        );
        verify(() => dio.post(dio.options.baseUrl + loginUrl, data: {
              "image": base64Encode(userModel.image),
              "name": userModel.name,
              "phoneNumber": userModel.phoneNumber,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
    });
    group("[Get User] - ", () {
      test("It should post getUser and return userModel by calling only once",
          () async {
        //Arrange
        when(() => dio.post(
                  any(),
                  data: any(named: "data"),
                ))
            .thenAnswer((invocation) async => Response(
                requestOptions: RequestOptions(),
                statusCode: 201,
                data: jsonEncode({"user": userMap})));
        //Act
        final response = await remoteDatasource.getUser(
          phoneNumber: params.phoneNumber,
        );
        //Assert
        expect(response, equals(UserModel.fromMap(userMap)));
        verify(() => dio.post(dio.options.baseUrl + getUserUrl, data: {
              "phoneNumber": params.phoneNumber,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
      test("It should post getUser and return null by calling only once",
          () async {
        //Arrange
        when(() => dio.post(
                  any(),
                  data: any(named: "data"),
                ))
            .thenAnswer((invocation) async => Response(
                requestOptions: RequestOptions(),
                statusCode: 201,
                data: jsonEncode({"user": null})));
        //Act
        final response = await remoteDatasource.getUser(
          phoneNumber: params.phoneNumber,
        );
        //Assert
        expect(response, null);
        verify(() => dio.post(dio.options.baseUrl + getUserUrl, data: {
              "phoneNumber": params.phoneNumber,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
      test(
          "It should call remoteDataSource.loginUser and throw api exception when dio Exception occurs calling only once",
          () async {
        //Arrange
        when(() => dio.post(
                  any(),
                  data: any(named: "data"),
                ))
            .thenThrow(DioException(
                requestOptions: RequestOptions(), message: errorMessage));
        //Act
        final response = remoteDatasource.getUser(
          phoneNumber: params.phoneNumber,
        );
        //Assert
        expect(
            response,
            throwsA(const ApiException(
                message: "Internal server error", statusCode: statusCode)));
        verify(() => dio.post(dio.options.baseUrl + getUserUrl, data: {
              "phoneNumber": params.phoneNumber,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });

      test(
          "It should call remoteDataSource.loginUser and throw api exception by calling only once",
          () async {
        //Arrange
        when(() => dio.post(
                  any(),
                  data: any(named: "data"),
                ))
            .thenAnswer((invocation) async => Response(
                requestOptions: RequestOptions(),
                statusCode: statusCode,
                data: {"message": errorMessage}));
        //Assert
        await expectLater(
          remoteDatasource.getUser(
            phoneNumber: params.phoneNumber,
          ),
          throwsA(const ApiException(
            message: errorMessage,
            statusCode: statusCode,
          )),
        );
        verify(() => dio.post(dio.options.baseUrl + getUserUrl, data: {
              "phoneNumber": params.phoneNumber,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
    });
    group("[Update User] - ", () {
      test(
          "It should post updateUser and return userModel by calling only once",
          () async {
        //Arrange
        when(() => dio.put(
                  any(),
                  data: any(named: "data"),
                ))
            .thenAnswer((invocation) async => Response(
                requestOptions: RequestOptions(),
                statusCode: 201,
                data: jsonEncode({"user": userMap})));
        //Act
        final response = await remoteDatasource.updateUser(
            name: userModel.name, id: userModel.id, image: userModel.image);
        //Assert
        expect(response, equals(UserModel.fromMap(userMap)));
        verify(() => dio.put(dio.options.baseUrl + updateUserUrl, data: {
              "image": base64Encode(userModel.image),
              "name": userModel.name,
              "_id": userModel.id,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
      test(
          "It should call remoteDataSource.loginUser and throw api exception when dio Exception occurs calling only once",
          () async {
        //Arrange
        when(() => dio.put(
                  any(),
                  data: any(named: "data"),
                ))
            .thenThrow(DioException(
                requestOptions: RequestOptions(), message: errorMessage));
        //Act
        final response = remoteDatasource.updateUser(
            name: userModel.name, id: userModel.id, image: userModel.image);
        //Assert
        await expectLater(
            response,
            throwsA(const ApiException(
                message: "Internal server error", statusCode: statusCode)));
        verify(() => dio.put(dio.options.baseUrl + updateUserUrl, data: {
              "image": base64Encode(userModel.image),
              "name": userModel.name,
              "_id": userModel.id,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });

      test(
          "It should call remoteDataSource.loginUser and throw api exception by calling only once",
          () async {
        //Arrange
        when(() => dio.put(
                  any(),
                  data: any(named: "data"),
                ))
            .thenAnswer((invocation) async => Response(
                requestOptions: RequestOptions(),
                statusCode: statusCode,
                data: {"message": errorMessage}));
        //Assert
        await expectLater(
          remoteDatasource.updateUser(
              name: userModel.name, id: userModel.id, image: userModel.image),
          throwsA(const ApiException(
            message: errorMessage,
            statusCode: statusCode,
          )),
        );
        verify(() => dio.put(dio.options.baseUrl + updateUserUrl, data: {
              "image": base64Encode(userModel.image),
              "name": userModel.name,
              "_id": userModel.id,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
    });
  });
}
