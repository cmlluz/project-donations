import 'dart:convert';
import 'package:appdonationsgestor/models/campaign_model.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';

class CampaignApiService {
  final ApiClient _apiClient;

  CampaignApiService(this._apiClient);

  Future<List<Campaign>> getCampaigns() async {
    final response = await _apiClient.get('campaigns');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Campaign.fromJson(item)).toList();
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao carregar as campanhas.');
    }
  }

  Future<Campaign> getCampaignById(String id) async {
    final response = await _apiClient.get('campaigns/$id');

    if (response.statusCode == 200) {
      return Campaign.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao carregar a campanha.');
    }
  }

  Future<Campaign> createCampaign(Map<String, dynamic> campaignData) async {
    final response = await _apiClient.post('campaigns', body: campaignData);

    if (response.statusCode == 201) {
      return Campaign.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao criar a campanha.');
    }
  }

  Future<Campaign> updateCampaign(
      String id, Map<String, dynamic> campaignData) async {
    final response = await _apiClient.put('campaigns/$id', body: campaignData);

    if (response.statusCode == 200) {
      return Campaign.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao atualizar a campanha.');
    }
  }

  Future<void> deleteCampaign(String id) async {
    final response = await _apiClient.delete('campaigns/$id');

    if (response.statusCode != 204) {
      print("Falha ao deletar campanha: ${response.statusCode}");
      print("Corpo da resposta: ${response.body}");
      throw Exception("Falha ao deletar campanha: ${response.statusCode}");
    }
    print("Campanha deletada com sucesso.");
  }

  Future<List<Campaign>> getMyCampaigns() async {
    final response = await _apiClient.get('campaigns/me');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => Campaign.fromJson(item)).toList();
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao carregar as minhas campanhas.');
    }
  }
}
