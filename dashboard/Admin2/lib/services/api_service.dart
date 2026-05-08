import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://backend.munawebti.dom-dev.cloud/api';

  /// =========================
  /// Get token مباشرة من التخزين
  /// =========================
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// =========================
  /// حفظ التوكن
  /// =========================
  Future<void> setToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();

    if (token != null) {
      await prefs.setString('auth_token', token);
      print('ApiService: Token saved -> $token');
    } else {
      await prefs.remove('auth_token');
      print('ApiService: Token removed');
    }
  }

  /// =========================
  /// بناء الهيدر
  /// =========================
  Future<Map<String, String>> _buildHeaders({
    bool authRequired = true,
    Map<String, String>? customHeaders,
  }) async {

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // 🔥 هنا الإصلاح الحقيقي
    if (authRequired) {
      final token = await _getToken();

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  /// =========================
  /// GET
  /// =========================
  Future<Map<String, dynamic>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        bool authRequired = true,
      }) async {

    Uri uri = Uri.parse('$baseUrl$endpoint');

    if (queryParameters != null && queryParameters.isNotEmpty) {
      uri = uri.replace(
        queryParameters: queryParameters.map(
              (k, v) => MapEntry(k, v.toString()),
        ),
      );
    }

    final finalHeaders = await _buildHeaders(
      authRequired: authRequired,
      customHeaders: headers,
    );

    final response = await http.get(uri, headers: finalHeaders);

    return _handleResponse(response);
  }

  /// =========================
  /// POST
  /// =========================
  Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> data, {
        Map<String, String>? headers,
        bool authRequired = true,
      }) async {

    final finalHeaders = await _buildHeaders(
      authRequired: authRequired,
      customHeaders: headers,
    );

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: finalHeaders,
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  /// =========================
  /// PUT
  /// =========================
  Future<Map<String, dynamic>> put(
      String endpoint,
      Map<String, dynamic> data, {
        bool authRequired = true,
      }) async {

    final finalHeaders = await _buildHeaders(
      authRequired: authRequired,
    );

    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: finalHeaders,
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  /// =========================
  /// DELETE
  /// =========================
  Future<Map<String, dynamic>> delete(
      String endpoint, {
        Map<String, String>? headers,
        bool authRequired = true,
      }) async {

    final finalHeaders = await _buildHeaders(
      authRequired: authRequired,
      customHeaders: headers,
    );

    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: finalHeaders,
    );

    return _handleResponse(response);
  }

  /// =========================
  /// Handle Response
  /// =========================
  Map<String, dynamic> _handleResponse(http.Response response) {
    final status = response.statusCode;

    if (status >= 200 && status < 300) {
      return response.body.isNotEmpty
          ? json.decode(response.body)
          : {};
    }

    if (status == 401) {
      print('❌ Unauthorized (401): ${response.body}');
      throw Exception('Unauthorized - Please login again');
    }

    String errorMessage = 'Request failed: $status';

    try {
      final errorBody = json.decode(response.body);

      if (errorBody is Map && errorBody.containsKey('message')) {
        errorMessage = errorBody['message'];
      } else {
        errorMessage = response.body;
      }
    } catch (_) {
      errorMessage = response.body;
    }

    print('❌ API ERROR [$status]: $errorMessage');

    throw Exception(errorMessage);
  }
}