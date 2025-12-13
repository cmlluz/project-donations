import 'dart:convert';
import 'package:appdonationsgestor/models/nota_fiscal_model.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';

class NotaFiscalApiService {
  final ApiClient _apiClient;

  NotaFiscalApiService(this._apiClient);

  Future<NotaFiscal> createNotaFiscal(Map<String, dynamic> data) async {
    final response = await _apiClient.post('notas-fiscais', body: data);

    if (response.statusCode == 201) {
      return NotaFiscal.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao criar nota fiscal.');
    }
  }

  Future<List<NotaFiscal>> getNotasByAuthor(String authorUid) async {
    final response = await _apiClient.get('notas-fiscais/author/$authorUid');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => NotaFiscal.fromJson(item)).toList();
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao carregar notas fiscais.');
    }
  }

  Future<void> deleteNotaFiscal(int id) async {
    final response = await _apiClient.delete('notas-fiscais/$id');

    if (response.statusCode != 204) {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao deletar nota fiscal.');
    }
  }
}