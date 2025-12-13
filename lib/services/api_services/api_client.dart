import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class PaginatedResponse<T> {
  final List<T> content;
  final int totalPages;
  final int totalElements;
  final int pageNumber;
  final int pageSize;
  final bool isLast;
  final bool isFirst;

  PaginatedResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.pageNumber,
    required this.pageSize,
    required this.isLast,
    required this.isFirst,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return PaginatedResponse(
      content: List<T>.from(json['content'].map((item) => fromJson(item))),
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      pageNumber: json['number'],
      pageSize: json['size'],
      isLast: json['last'],
      isFirst: json['first'],
    );
  }
}

class ApiClient {
  final String _baseUrl = "http://10.0.2.2:8080/api";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, String>> _getAuthHeaders() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Utilizador não autenticado.");
    }
    final idToken = await user.getIdToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $idToken',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getAuthHeaders();
    return http.get(Uri.parse('$_baseUrl/$endpoint'), headers: headers);
  }

  Future<http.Response> post(String endpoint,
      {Map<String, dynamic>? body}) async {
    final headers = await _getAuthHeaders();
    return http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> put(String endpoint,
      {Map<String, dynamic>? body}) async {
    final headers = await _getAuthHeaders();
    return http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final headers = await _getAuthHeaders();
    return http.delete(Uri.parse('$_baseUrl/$endpoint'), headers: headers);
  }
}
