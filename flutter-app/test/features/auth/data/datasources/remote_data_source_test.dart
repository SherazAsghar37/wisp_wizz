import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/auth/data/datasources/remote_data_source.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';
import '../../../../app/temp_path.dart';

class MDio extends Mock implements Dio {
  @override
  BaseOptions options;
  MDio({required this.options});
}

void main() {
  late RemoteDatasource remoteDatasource;
  late Dio dio;
  // MultipartFile? multipartFile;
  final params = CustomUserParam(
      countryCode: "whatever.countryCode",
      name: "whatever.name",
      phoneNumber: 123456789,
      image: tempFile);

  setUp(() {
    dio = MDio(options: BaseOptions(baseUrl: baseUrl));
    remoteDatasource = RemoteDatasource(dio: dio);
    // multipartFile = params.image != null
    //     ? await MultipartFile.fromFile(params.image!.path,
    //         filename: imageFileName)
    //     : null;
  });

  const int statusCode = 500;
  const String errorMessage = "whatever.error";

  UserModel userModel = UserModel.empty();
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
                data: jsonEncode({"user": userModel.toMap()})));
        //Act
        final response = await remoteDatasource.loginUser(
            name: params.name,
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
            image: params.image);
        //Assert
        expect(response, isA<UserModel>());
        // verify(() => dio.post(dio.options.baseUrl + loginUrl,
        //     data: FormData.fromMap({
        //       "image": multipartFile,
        //       "name": params.name,
        //       "phoneNumber": params.phoneNumber,
        //       "countryCode": params.countryCode
        //     }))).called(1);
        // verifyNoMoreInteractions(dio);
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
            name: params.name,
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
            image: params.image);
        //Assert
        expect(
            response,
            throwsA(const ApiException(
                message: errorMessage, statusCode: statusCode)));

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
            name: params.name,
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
            image: params.image,
          ),
          throwsA(const ApiException(
            message: errorMessage,
            statusCode: statusCode,
          )),
        );
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
                data: jsonEncode({"user": userModel.toMap()})));
        //Act
        final response = await remoteDatasource.getUser(
          phoneNumber: params.phoneNumber,
          countryCode: params.countryCode,
        );
        //Assert
        expect(response, isA<UserModel>());
        verify(() => dio.post(dio.options.baseUrl + getUserUrl, data: {
              "phoneNumber": params.phoneNumber,
              "countryCode": params.countryCode
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
          countryCode: params.countryCode,
        );
        //Assert
        expect(response, null);
        verify(() => dio.post(dio.options.baseUrl + getUserUrl, data: {
              "phoneNumber": params.phoneNumber,
              "countryCode": params.countryCode
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
          countryCode: params.countryCode,
        );
        //Assert
        expect(
            response,
            throwsA(const ApiException(
                message: errorMessage, statusCode: statusCode)));
        verify(() => dio.post(dio.options.baseUrl + getUserUrl, data: {
              "phoneNumber": params.phoneNumber,
              "countryCode": params.countryCode
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
            countryCode: params.countryCode,
          ),
          throwsA(const ApiException(
            message: errorMessage,
            statusCode: statusCode,
          )),
        );
        verify(() => dio.post(dio.options.baseUrl + getUserUrl, data: {
              "phoneNumber": params.phoneNumber,
              "countryCode": params.countryCode
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
    });
  });
}
