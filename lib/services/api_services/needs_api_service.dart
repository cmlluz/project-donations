import 'dart:convert';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';

class NeedApiService {
  final ApiClient _apiClient;

  NeedApiService(this._apiClient);

  Future<List<Need>> getNeeds() async {
    final response = await _apiClient.get('needs');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Need.fromJson(item)).toList();
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao carregar as necessidades.');
    }
  }

  Future<Need> getNeedById(String id) async {
    final response = await _apiClient.get('needs/$id');

    if (response.statusCode == 200) {
      return Need.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao carregar a necessidade.');
    }
  }

  Future<Need> createNeed(Map<String, dynamic> needData) async {
    final response = await _apiClient.post('needs', body: needData);

    if (response.statusCode == 201) {
      return Need.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao criar a necessidade.');
    }
  }

  Future<Need> updateNeed(int id, Map<String, dynamic> needData) async {
    final response = await _apiClient.put('needs/$id', body: needData);

    if (response.statusCode == 200) {
      return Need.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao atualizar a necessidade.');
    }
  }

  Future<void> deleteNeed(int id) async {
    final response = await _apiClient.delete('needs/$id');

    if (response.statusCode != 204) {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao deletar a necessidade.');
    }
    print("Necessidade $id deletada com sucesso.");
  }

  Future<Need> approveNeed(String id) async {
    final response = await _apiClient.post('needs/$id/approve');

    if (response.statusCode == 200) {
      return Need.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao aprovar a necessidade.');
    }
  }

  Future<Need> rejectNeed(String id) async {
    final response = await _apiClient.post('needs/$id/reject');

    if (response.statusCode == 200) {
      return Need.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao rejeitar a necessidade.');
    }
  }
}
