import 'dart:convert';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService(this._apiClient);

  Future<void> syncUser() async {
    try {
      final response = await _apiClient.post('auth/sync');

      if (response.statusCode == 200) {
        print("Utilizador sincronizado com sucesso.");
      } else {
        print("Falha ao sincronizar utilizador: ${response.statusCode}");
        print("Corpo da resposta: ${response.body}");
      }
    } catch (e) {
      print("Erro ao sincronizar utilizador: $e");
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      final response = await _apiClient.delete('users/me');

      if (response.statusCode == 204) {
        print("Utilizador deletado com sucesso no backend.");
      } else {
        print("Falha ao deletar utilizador no backend: ${response.statusCode}");
        print("Corpo da resposta: ${response.body}");
        throw Exception(
            "Falha ao deletar utilizador no backend: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao deletar utilizador no backend: $e");
      rethrow;
    }
  }

  Future<void> updateUser(Map<String, dynamic> userData) async {
    try {
      final response = await _apiClient.put('users/me', body: userData);

      if (response.statusCode == 200) {
        print("Utilizador atualizado com sucesso no backend.");
      } else {
        print(
            "Falha ao atualizar utilizador no backend: ${response.statusCode}");
        print("Corpo da resposta: ${response.body}");
        String rawBody = utf8.decode(response.bodyBytes);
        String errorMessage =
            "Falha ao atualizar utilizador no backend. Tente novamente.";
        if (rawBody.isNotEmpty) {
          try {
            final errorJson = jsonDecode(rawBody);
            errorMessage =
                errorJson['message'] ?? errorJson['error'] ?? rawBody;
          } catch (_) {
            errorMessage = rawBody;
          }
          errorMessage = errorMessage.replaceAll('"', '').trim();
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      print("Erro ao atualizar utilizador no backend: $e");
      rethrow;
    }
  }
}
