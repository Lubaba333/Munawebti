import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://backend.munawebti.dom-dev.cloud/api';

  String? _token;

  Future<void> _loadTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    print('ApiService: Loaded token from prefs: $_token');
  }

  void setToken(String? token) async {
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

  Future<Map<String, String>> _buildHeaders({bool authRequired = true, Map<String, String>? customHeaders}) async {
    if (authRequired) {
      await _loadTokenFromPrefs();
      if (_token == null) {
        print('Error: Authentication token is missing for a required authenticated request.');
      }
    }

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authRequired && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  Future<Map<String, dynamic>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        bool authRequired = true,
      }) async {
    Uri uri = Uri.parse('$baseUrl$endpoint');

    if (queryParameters != null && queryParameters.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParameters.map(
            (key, value) => MapEntry(key, value.toString()),
      ));
    }

    final finalHeaders = await _buildHeaders(authRequired: authRequired, customHeaders: headers);
    final response = await http.get(
      uri,
      headers: finalHeaders,
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> data, {
        Map<String, String>? headers,
        bool authRequired = true,
      }) async {
    final finalHeaders = await _buildHeaders(authRequired: authRequired, customHeaders: headers);

    print('📤 POST Request: $baseUrl$endpoint');
    print('📤 Headers: ${finalHeaders}');
    print('📤 Body: ${jsonEncode(data)}');

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: finalHeaders,
      body: jsonEncode(data),
    );

    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    return _handleResponse(response);
  }

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

// في ملف service.dart - تحديث دالة _handleResponse

Map<String, dynamic> _handleResponse(http.Response response) {
  Map<String, dynamic> responseBody = {};
  if (response.body.isNotEmpty) {
    try {
      responseBody = json.decode(response.body);
    } catch (e) {
      print('❌ Failed to parse response as JSON: ${response.body}');
    }
  }

  // النجاح
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return responseBody;
  }
  
  // حالة 401
  else if (response.statusCode == 401) {
    print('Unauthorized (401): ${response.body}');
    setToken(null);
    throw Exception('Session expired. Please login again.');
  }
  
  // حالة 422 - Validation Error (🔥 الأهم)
  else if (response.statusCode == 422) {
    print('❌ Validation Error (422): ${response.body}');
    
    // محاولة استخراج رسالة الخطأ من الـ API
    String errorMessage = 'Validation failed';
    
    if (responseBody.containsKey('message')) {
      errorMessage = responseBody['message'];
    }
    
    // إذا كان هناك تفاصيل أخطاء (errors object)
    if (responseBody.containsKey('errors') && responseBody['errors'] != null) {
      final errors = responseBody['errors'];
      
      if (errors is Map) {
        // استخراج أول خطأ موجود
        errors.forEach((field, messages) {
          if (messages is List && messages.isNotEmpty) {
            errorMessage = messages.first;
          } else if (messages is String) {
            errorMessage = messages;
          }
        });
      }
    }
    
    throw Exception(errorMessage);
  }
  
  // حالات خطأ أخرى
  else {
    String errorMessage = 'Request failed: ${response.statusCode}';
    if (responseBody.containsKey('message')) {
      errorMessage = responseBody['message'];
    }
    
    print('❌ API Error: ${response.statusCode} - $errorMessage');
    throw Exception(errorMessage);
  }
}
}