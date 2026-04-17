import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://10.74.230.1:8000/api';
  String? _token;

  String? get token => _token;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    print('ApiService: Loaded token from prefs: $_token');
  }

  /// حفظ أو حذف التوكن
  Future<void> setToken(String? token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('auth_token', token);
      print('ApiService: Token updated and saved to prefs: $_token');
    } else {
      await prefs.remove('auth_token');
      print('ApiService: Token removed from prefs.');
    }
  }

  /// بناء الهيدر لكل طلب
  Future<Map<String, String>> _buildHeaders({
    bool authRequired = true,
    Map<String, String>? customHeaders,
  }) async {
    if (authRequired) await loadToken();

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authRequired && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    if (customHeaders != null) headers.addAll(customHeaders);

    return headers;
  }

  /// GET request
  Future<Map<String, dynamic>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        bool authRequired = true,
      }) async {
    Uri uri = Uri.parse('$baseUrl$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      uri = uri.replace(
        queryParameters: queryParameters.map((k, v) => MapEntry(k, v.toString())),
      );
    }
    final finalHeaders = await _buildHeaders(authRequired: authRequired, customHeaders: headers);
    final response = await http.get(uri, headers: finalHeaders);
    return _handleResponse(response);
  }

  /// POST request
  Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> data, {
        Map<String, String>? headers,
        bool authRequired = true,
      }) async {
    final finalHeaders = await _buildHeaders(authRequired: authRequired, customHeaders: headers);
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: finalHeaders,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
      String endpoint,
      Map<String, dynamic> data, {
        bool authRequired = true,
      }) async {
    final finalHeaders = await _buildHeaders(authRequired: authRequired);
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: finalHeaders,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
      String endpoint, {
        Map<String, String>? headers,
        bool authRequired = true,
      }) async {
    final finalHeaders = await _buildHeaders(authRequired: authRequired, customHeaders: headers);
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: finalHeaders,
    );
    return _handleResponse(response);
  }

  /// التعامل مع الردود من السيرفر
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? json.decode(response.body) : {};
    } else if (response.statusCode == 401) {
      print('Unauthorized (401): ${response.body}');
      setToken(null);
      throw Exception('Unauthorized: Session expired or invalid token.');
    } else {
      String errorMessage = 'فشل في الاتصال: ${response.statusCode}';
      try {
        final errorBody = json.decode(response.body);
        if (errorBody is Map && errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        } else {
          errorMessage = 'فشل في الاتصال: ${response.statusCode}, Body: ${response.body}';
        }
      } catch (e) {
        errorMessage = 'فشل في الاتصال: ${response.statusCode}, لا يمكن تحليل الاستجابة كـ JSON.';
      }
      print('❌ API Error: ${response.statusCode} - $errorMessage');
      throw Exception(errorMessage);
    }
  }
}