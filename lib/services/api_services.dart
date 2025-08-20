import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  final String _baseUrl = "http://10.0.2.2:8080/api";

  Future<Map<String, String>> _getAuthHeaders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Utilizador não autenticado.");
    }
    final idToken = await user.getIdToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $idToken',
    };
  }

  Future<void> syncUser() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/sync'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("Utilizador sincronizado com sucesso.");
        // Opcional: pode processar a resposta do utilizador aqui
      } else {
        print("Falha ao sincronizar utilizador: ${response.statusCode}");
        print("Corpo da resposta: ${response.body}");
      }
    } catch (e) {
      print("Erro ao sincronizar utilizador: $e");
    }
  }

  Future<void> deleteUser() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$_baseUrl/auth/delete'),
        headers: headers,
      );

      if (response.statusCode == 204) {
        print("Utilizador deletado com sucesso.");
      } else {
        print("Falha ao deletar utilizador: ${response.statusCode}");
        print("Corpo da resposta: ${response.body}");
      }
    } catch (e) {
      print("Erro ao deletar utilizador: $e");
    }
  }

  Future<void> updateUser(Map<String, dynamic> userData) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl/auth/update'),
        headers: headers,
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        print("Utilizador atualizado com sucesso.");
      } else {
        print("Falha ao atualizar utilizador: ${response.statusCode}");
        print("Corpo da resposta: ${response.body}");
      }
    } catch (e) {
      print("Erro ao atualizar utilizador: $e");
    }
  }

  Future<List<dynamic>> getDonations() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/donations'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Converte a resposta JSON numa lista de objetos Dart
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        print("Falha ao buscar doações: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Erro ao buscar doações: $e");
      return [];
    }
  }

  Future<void> createDonation(Map<String, dynamic> donationData) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/donations'),
        headers: headers,
        body: jsonEncode(donationData), // Converte o mapa para uma string JSON
      );

      if (response.statusCode == 201) {
        print("Doação criada com sucesso.");
      } else {
        print("Falha ao criar doação: ${response.statusCode}");
        print("Corpo da resposta: ${response.body}");
      }
    } catch (e) {
      print("Erro ao criar doação: $e");
    }
  }

  Future<void> updateDonation(
      String id, Map<String, dynamic> donationData) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl/donations/$id'),
        headers: headers,
        body: jsonEncode(donationData), // Converte o mapa para uma string JSON
      );

      if (response.statusCode == 200) {
        print("Doação atualizada com sucesso.");
      } else {
        print("Falha ao atualizar doação: ${response.statusCode}");
        print("Corpo da resposta: ${response.body}");
      }
    } catch (e) {
      print("Erro ao atualizar doação: $e");
    }
  }

  Future<void> deleteDonation(String id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$_baseUrl/donations/$id'),
        headers: headers,
      );

      if (response.statusCode == 204) {
        print("Doação deletada com sucesso.");
      } else {
        print("Falha ao deletar doação: ${response.statusCode}");
        print("Corpo da resposta: ${response.body}");
      }
    } catch (e) {
      print("Erro ao deletar doação: $e");
    }
  }
}
