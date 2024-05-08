import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  // Private constructor
  ApiClient._(this.baseUrl);

  // Singleton instance variable
  static ApiClient? _instance;

  // Base URL
  final String baseUrl;

  // Common headers
  final Map<String, String> _commonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Static method to access the singleton instance
  static ApiClient getInstance({required String baseUrl}) {
    _instance ??= ApiClient._(baseUrl);
    return _instance!;
  }

  // Methods
  Future<http.Response> get(
      {String? baseUrl,
      required String endpoint,
      Map<String, String>? headers}) async {
    final header = await _mergeHeaders(headers);
    final response = await http
        .get(Uri.parse((baseUrl ?? this.baseUrl) + endpoint), headers: header);
    return response;
  }

  Future<http.Response> post(
      {String? baseUrl,
      required String endpoint,
      dynamic body,
      Map<String, String>? headers}) async {
    final header = await _mergeHeaders(headers);
    final response = await http.post(
        Uri.parse((baseUrl ?? this.baseUrl) + endpoint),
        headers: header,
        body: jsonEncode(body));
    return response;
  }

  Future<http.Response> put(
      {String? baseUrl,
      required String endpoint,
      dynamic body,
      Map<String, String>? headers}) async {
    final header = await _mergeHeaders(headers);
    final response = await http.put(
        Uri.parse((baseUrl ?? this.baseUrl) + endpoint),
        headers: header,
        body: jsonEncode(body));
    return response;
  }

  Future<http.Response> delete(
      {String? baseUrl,
      required String endpoint,
      Map<String, String>? headers}) async {
    final header = await _mergeHeaders(headers);
    final response = await http.delete(
        Uri.parse((baseUrl ?? this.baseUrl) + endpoint),
        headers: header);
    return response;
  }

  Future<http.Response> uploadFile(
      {String? baseUrl,
      required List<http.MultipartFile> files,
      required String endpoint,
      Map<String, String>? body}) async {
    var url = Uri.parse("${baseUrl ?? this.baseUrl}$endpoint");
    final request = http.MultipartRequest('POST', url);
    if (body != null) {
      request.fields.addAll(body);
    }
    for (var file in files) {
      request.files.add(file);
    }

    final response = await http.Response.fromStream(await request.send());
    return response;
  }

  Future<Map<String, String>> _mergeHeaders(
      Map<String, String>? headers) async {
    final mergedHeaders = Map<String, String>.from(_commonHeaders);
    if (headers != null) {
      mergedHeaders.addAll(headers);
    }
    return mergedHeaders;
  }
}
