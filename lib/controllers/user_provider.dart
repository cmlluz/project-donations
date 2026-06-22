import 'dart:convert';
import 'package:appdonationsgestor/models/public_user_model.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  PublicUser? _currentUser;
  PublicUser? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final ApiClient _apiClient = ApiClient();

  Future<void> fetchCurrentUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiClient.get('users/me');
      if (response.statusCode == 200) {
        _currentUser =
            PublicUser.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        _currentUser = null;
        throw Exception("Falha ao carregar dados do usuário");
      }
    } catch (e) {
      _currentUser = null;
      print(e.toString());
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateLocalUserData(
      {String? name, String? bio, String? profilePictureUrl}) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        bio: bio,
        profilePictureUrl: profilePictureUrl,
      );
      notifyListeners();
    }
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
