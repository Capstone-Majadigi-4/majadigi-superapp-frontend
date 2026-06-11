import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static void Function()? onUnauthorized;
  static bool _isRefreshing = false;
  static final List<void Function(String)> _tokenListeners = [];

  static void _onTokenRefreshed(String token) {
    for (var listener in _tokenListeners) {
      listener(token);
    }
    _tokenListeners.clear();
  }

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
          // Handle global errors here (e.g. 401 token expired)
          if (e.response?.statusCode == 401 && 
              !e.requestOptions.path.contains('login') && 
              !e.requestOptions.path.contains('refresh')) {
            
            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString('refresh_token');
            
            if (refreshToken != null && refreshToken.isNotEmpty) {
              if (_isRefreshing) {
                // Queue this request and wait for the active refresh to complete
                final completer = Completer<Response>();
                _tokenListeners.add((newToken) {
                  final options = e.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newToken';
                  instance.fetch(options).then(
                    (res) => completer.complete(res),
                    onError: (err) => completer.completeError(err),
                  );
                });
                
                try {
                  final retryResponse = await completer.future;
                  return handler.resolve(retryResponse);
                } catch (err) {
                  return handler.next(DioException(
                    requestOptions: e.requestOptions,
                    error: err,
                  ));
                }
              }

              _isRefreshing = true;
              
              try {
                // Use a separate Dio instance to avoid interceptor recursion
                final refreshDio = Dio(BaseOptions(
                  baseUrl: baseUrl,
                  connectTimeout: const Duration(seconds: 15),
                  receiveTimeout: const Duration(seconds: 15),
                  headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                  },
                ));
                
                final response = await refreshDio.post(
                  '/auth/refresh',
                  data: {'refresh_token': refreshToken},
                );
                
                if (response.statusCode == 200) {
                  final responseData = response.data['data'] as Map<String, dynamic>?;
                  final newAccessToken = responseData?['access_token'] as String?;
                  
                  if (newAccessToken != null && newAccessToken.isNotEmpty) {
                    await prefs.setString('access_token', newAccessToken);
                    
                    _isRefreshing = false;
                    _onTokenRefreshed(newAccessToken);
                    
                    // Retry original request
                    final options = e.requestOptions;
                    options.headers['Authorization'] = 'Bearer $newAccessToken';
                    final retryResponse = await instance.fetch(options);
                    return handler.resolve(retryResponse);
                  }
                }
              } catch (err) {
                _isRefreshing = false;
                _tokenListeners.clear();
                print('Token refresh failed: $err');
              }
            }
            
            // If refresh fails or no refresh token, perform logout/clear data
            final prefs2 = await SharedPreferences.getInstance();
            await prefs2.remove('access_token');
            await prefs2.remove('refresh_token');
            await prefs2.remove('user_profile');
            
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
