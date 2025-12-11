import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _baseUrl = 'http://192.168.1.6:8080/api';

  User? get currentUser => _auth.currentUser;

  Future<Map<String, dynamic>> loadUserData() async {
    if (currentUser == null) throw Exception('Usuário não autenticado.');
    final token = await currentUser!.getIdToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("✅ DADOS RECEBIDOS DO BACKEND: ${response.body}");

      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Falha ao carregar dados do usuário do backend.');
    }
  }

  Future<void> updateUserProfileBackend(Map<String, dynamic> data) async {
    if (currentUser == null) throw Exception('Usuário não autenticado.');
    final token = await currentUser!.getIdToken();

    final response = await http.put(
      Uri.parse('$_baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      print("Erro ao atualizar perfil: ${response.body}");
      throw Exception('Falha ao atualizar o perfil no backend.');
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    if (currentUser == null) throw Exception('Usuário não autenticado.');
    final ref =
        _storage.ref().child('profile_images').child('${currentUser!.uid}.jpg');
    await ref.putFile(imageFile);
    return ref.getDownloadURL();
  }

  Future<void> reauthenticateUser(String currentPassword) async {
    if (currentUser == null || currentUser!.email == null) {
      throw Exception('Usuário ou email nulo.');
    }
    final cred = EmailAuthProvider.credential(
      email: currentUser!.email!,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(cred);
  }

  Future<void> updateAuthEmail(String newEmail) async {
    if (currentUser == null) throw Exception('Usuário não autenticado.');
    await currentUser!.verifyBeforeUpdateEmail(newEmail);
  }

  Future<void> updateAuthPassword(String newPassword) async {
    if (currentUser == null) throw Exception('Usuário não autenticado.');
    await currentUser!.updatePassword(newPassword);
  }

  Future<Map<String, dynamic>> getUserById(String uid) async {
    if (currentUser == null) throw Exception('Usuário não autenticado.');
    final token = await currentUser!.getIdToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/users/$uid'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Falha ao carregar dados do usuário $uid.');
    }
  }
}
