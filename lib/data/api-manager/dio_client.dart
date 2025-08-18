import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio _dio;
  String _baseUrl = '';

  String? _token;
  Completer<void>? _refreshCompleter;

  /// Set or change the base URL
  Future<void> setBaseUrl(String url) async {
    _baseUrl = url;
    _dio.options.baseUrl = url;
  }

  String get baseUrl => _baseUrl;
  String get token => _token ?? "-";

  /// Set token
  void setToken(String? token) {
    _token = token;
  }

  DioClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        //Base Url Options
        String? customUrl = options.extra["baseUrl"];
        options.baseUrl = customUrl ?? _baseUrl;
        //Token Options
        final requiresAuth = options.extra["requiresAuth"] ?? true;
        final token = _token;
        if (token != null && requiresAuth) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        // Example: token refresh
        if (e.response?.statusCode == 401) {
          await _handleTokenRefresh();
          return handler.resolve(await _retry(e.requestOptions));
        }
        return handler.next(e);
      },
    ));
  }

  /// GET
  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters,
      bool requireToken = true,
      String? baseUrl}) async {
    return await _dio.get(endpoint,
        queryParameters: queryParameters,
        options: _overrideOptions(
            requireToken: requireToken, customBaseUrl: baseUrl));
  }

  /// POST
  Future<Response> post(String endpoint,
      {dynamic body,
      bool requireToken = true,
      bool isFormData = false,
      String? baseUrl}) async {
    final data = isFormData ? createFormData(body) : body;
    return await _dio.post(endpoint,
        data: data,
        options: _overrideOptions(
            requireToken: requireToken, customBaseUrl: baseUrl));
  }

  /// PUT
  Future<Response> put(String endpoint,
      {dynamic body,
      bool requireToken = true,
      bool isFormData = false,
      String? baseUrl}) async {
    final data = isFormData ? createFormData(body) : body;
    return await _dio.put(endpoint,
        data: data,
        options: _overrideOptions(
            requireToken: requireToken, customBaseUrl: baseUrl));
  }

  /// DELETE
  Future<Response> delete(String endpoint,
      {dynamic body,
      bool requireToken = true,
      bool isFormData = false,
      String? baseUrl}) async {
    final data = isFormData ? createFormData(body) : body;
    return await _dio.delete(endpoint,
        data: data,
        options: _overrideOptions(
            requireToken: requireToken, customBaseUrl: baseUrl));
  }

  Options _overrideOptions(
      {required bool requireToken, String? customBaseUrl}) {
    return Options(
        extra: {"requiresAuth": requireToken, "baseUrl": customBaseUrl});
  }

  Future<void> _handleTokenRefresh() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future; // wait for ongoing refresh
    }

    _refreshCompleter = Completer();

    try {
      final response = await _dio.post('/auth/refresh', data: {
        'refreshToken': 'yourRefreshToken',
      });

      final newToken = response.data['accessToken'];
      setToken(newToken);
      _refreshCompleter!.complete();
    } catch (e) {
      _refreshCompleter!.completeError(e);
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request(
      requestOptions.path,
      options: options,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }

  FormData createFormData(Map<String, dynamic> rawData) {
    final convertedMap = _convertToMultipart(rawData);
    return FormData.fromMap(convertedMap);
  }

  Map<String, dynamic> _convertToMultipart(Map<String, dynamic> data) {
    final Map<String, dynamic> newData = {};

    data.forEach((key, value) {
      if (value is Uint8List) {
        // Single Uint8List → MultipartFile
        newData[key] = MultipartFile.fromBytes(
          value,
          filename: "$key-${DateTime.now().millisecondsSinceEpoch}.png",
        );
      } else if (value is List<Uint8List>) {
        // List<Uint8List> → List<MultipartFile>
        newData[key] = value.map((bytes) {
          return MultipartFile.fromBytes(
            bytes,
            filename: "$key-${DateTime.now().millisecondsSinceEpoch}.png",
          );
        }).toList();
      } else if (value is Map<String, dynamic>) {
        // Recursive for nested maps
        newData[key] = _convertToMultipart(value);
      } else {
        // Leave other data unchanged
        newData[key] = value;
      }
    });

    return newData;
  }
}
