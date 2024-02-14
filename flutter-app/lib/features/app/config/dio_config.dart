import 'package:dio/dio.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';

class DioClient {
  static Dio? _dio;

  DioClient._internal();

  static Dio getInstance() {
    if (_dio == null) {
      _dio = Dio(_getBaseOptions());
      _dio!.interceptors.add(_getLoggingInterceptor());
    }
    return _dio!;
  }

  static BaseOptions _getBaseOptions() {
    return BaseOptions(
      baseUrl: baseUrl,
    );
  }

  static Interceptor _getLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (RequestOptions requestOptions,
          RequestInterceptorHandler requestInterceptorHandler) {
        DebugHelper.printWarning(
            'Request ${requestOptions.method}: ${requestOptions.uri}');
      },
      onResponse: (Response<dynamic> res,
          ResponseInterceptorHandler responseInterceptorHandler) {
        debugPrint(
            'Response ${res.statusCode}: ${res.realUri} \n Data: ${res.data}');
      },
      onError: (DioException dioException,
          ErrorInterceptorHandler errorInterceptorHandler) {
        DebugHelper.printError('Error ${dioException.message}');
      },
    );
  }
}
