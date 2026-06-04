import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static void Function()? onUnauthorized;

  // Staging Base URL: http://157.10.253.219/api/v1
  static String get baseUrl {
    return 'http://157.10.253.219/api/v1';
  }

  static Dio? _dio;

  static Dio get instance {
    _dio ??= _initDio();
    return _dio!;
  }

  static Dio _initDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Authorization Interceptor to inject JWT token automatically
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Handle global errors here if needed (e.g. 401 token expired)
          if (e.response?.statusCode == 401 && !e.requestOptions.path.contains('login')) {
            // Auto logout or trigger refresh token flow
            // Since this is the initial phase, we can clear token if unauthorized
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('access_token');
            await prefs.remove('refresh_token');
            await prefs.remove('user_profile');
            
            if (onUnauthorized != null) {
              onUnauthorized!();
            }
          }
          return handler.next(e);
        },
      ),
    );

    // Logging interceptor for debugging
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ),
    );

    return dio;
  }
}
