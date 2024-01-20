import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/data/datasources/remote_data_source.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/verify_otp_usecase.dart';
import '../../../../app/temp_path.dart';

class MDio extends Mock implements Dio {
  MDio({required this.options});

  @override
  BaseOptions options;
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

  final otpParams = CustomVerificationParam(
    otp: 123456,
    phoneNumber: 123456789,
  );
  const int statusCode = 500;
  const MapData error = {"error": "whatever.error"};
  const String errorMessage = "whatever.error";
  group("[Auth RemoteDataSource] - ", () {
    group("[Login User] - ", () {
      test("It should post loginUser and return void by calling only once", () {
        //Arrange
        when(() => dio.post(
                  any(),
                  data: any(named: "data"),
                ))
            .thenAnswer((invocation) async => Response(
                requestOptions: RequestOptions(),
                statusCode: 201,
                data: {"message": "user logged in sucessfully"}));
        //Act
        final response = remoteDatasource.loginUser(
            name: params.name,
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
            image: params.image);
        //Assert
        expect(response, completes);
        // verify(() => dio.post(dio.options.baseUrl + loginUrl,
        //     data: FormData.fromMap({
        //       "image": multipartFile,
        //       "name": params.name,
        //       "phoneNumber": params.phoneNumber,
        //       "countryCode": params.countryCode
        //     }))).called(1);
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

    group("[Send Code] - ", () {
      test("It should post sendCode and return void by calling only once", () {
        //Arrange
        when(() => dio.post(
              any(),
              data: any(named: "data"),
            )).thenAnswer((invocation) async => Response(
              requestOptions: RequestOptions(),
              statusCode: 201,
              // data: {"message": "user logged in sucessfully"}
            ));
        //Act
        final response = remoteDatasource.sendCode(
          phoneNumber: params.phoneNumber,
          countryCode: params.countryCode,
        );
        //Assert
        expect(response, completes);
        verify(() => dio.post(dio.options.baseUrl + sendCodeUrl, data: {
              "phoneNumber": params.phoneNumber,
              "countryCode": params.countryCode,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
      test(
          "It should post sendCode and throw APi Exception when status code is not 200 or 201 by calling only once",
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
            remoteDatasource.sendCode(
              phoneNumber: params.phoneNumber,
              countryCode: params.countryCode,
            ),
            throwsA(const ApiException(
                message: errorMessage, statusCode: statusCode)));

        verify(() => dio.post(dio.options.baseUrl + sendCodeUrl, data: {
              "phoneNumber": params.phoneNumber,
              "countryCode": params.countryCode,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
      test(
          "It should post sendCode  and throw APi Exception by calling only once",
          () async {
        //Arrange
        when(() => dio.post(
                  any(),
                  data: any(named: "data"),
                ))
            .thenThrow(DioException(
                requestOptions: RequestOptions(),
                error: error,
                message: errorMessage));
        //Act

        //Assert
        expect(
            remoteDatasource.sendCode(
              phoneNumber: params.phoneNumber,
              countryCode: params.countryCode,
            ),
            throwsA(const ApiException(
                message: errorMessage, statusCode: statusCode)));
        verify(() => dio.post(dio.options.baseUrl + sendCodeUrl, data: {
              "phoneNumber": params.phoneNumber,
              "countryCode": params.countryCode,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
    });
    group("[Verify OTP] - ", () {
      test("It should post verifyOtp and return void by calling only once", () {
        //Arrange
        when(() => dio.post(
              any(),
              data: any(named: "data"),
            )).thenAnswer((invocation) async => Response(
              requestOptions: RequestOptions(),
              statusCode: 201,
              // data: {"message": "user logged in sucessfully"}
            ));
        //Act
        final response = remoteDatasource.verifyOTP(
          phoneNumber: otpParams.phoneNumber,
          otp: otpParams.otp,
        );
        //Assert
        expect(response, completes);
        verify(() => dio.post(dio.options.baseUrl + verifyOTPUrl, data: {
              "phoneNumber": otpParams.phoneNumber,
              "otp": otpParams.otp,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
      test(
          "It should post sendCode and throw APi Exception when status code is not 200 or 201 by calling only once",
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
            remoteDatasource.verifyOTP(
              phoneNumber: otpParams.phoneNumber,
              otp: otpParams.otp,
            ),
            throwsA(const ApiException(
                message: errorMessage, statusCode: statusCode)));

        verify(() => dio.post(dio.options.baseUrl + verifyOTPUrl, data: {
              "phoneNumber": otpParams.phoneNumber,
              "otp": otpParams.otp,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
      test(
          "It should post sendCode  and throw APi Exception by calling only once",
          () async {
        //Arrange
        when(() => dio.post(
                  any(),
                  data: any(named: "data"),
                ))
            .thenThrow(DioException(
                requestOptions: RequestOptions(),
                error: error,
                message: errorMessage));
        //Act

        //Assert
        expect(
            remoteDatasource.verifyOTP(
              phoneNumber: otpParams.phoneNumber,
              otp: otpParams.otp,
            ),
            throwsA(const ApiException(
                message: errorMessage, statusCode: statusCode)));
        verify(() => dio.post(dio.options.baseUrl + verifyOTPUrl, data: {
              "phoneNumber": otpParams.phoneNumber,
              "otp": otpParams.otp,
            })).called(1);
        verifyNoMoreInteractions(dio);
      });
    });
  });
}
