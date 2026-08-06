import 'package:dio/dio.dart';
import '../storage/shared_prefernce.dart';

/// Central HTTP client. Every feature's *_service.dart file should
/// use ApiClient().dio to make requests — never create a new Dio
/// instance elsewhere, or the auth interceptor won't apply.
class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 45),
        receiveTimeout: const Duration(seconds: 45),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage().getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _tryRefreshToken();
            if (refreshed) {
              final retryResponse = await _dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();
  factory ApiClient() => instance;

  late final Dio _dio;
  Dio get dio => _dio;

  // TODO: switch to your production URL when deploying.
  static const String baseUrl =
      'https://autocare-backend-iz74.onrender.com/api/v1';

  Future<bool> _tryRefreshToken() async {
    final refreshToken = await SecureStorage().getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        '/auth/refresh/',
        data: {'refresh': refreshToken},
      );
      final newAccessToken = response.data['access'] as String;
      await SecureStorage().saveTokens(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
      );
      return true;
    } catch (_) {
      await SecureStorage().clearAll();
      return false;
    }
  }
}