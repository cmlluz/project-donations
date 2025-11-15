import 'dart:convert';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/models/campaign_participant_model.dart';

class CampaignParticipantApiService {
  final ApiClient _apiClient;

  CampaignParticipantApiService(this._apiClient);

  // Registrar interesse na campanha
  Future<CampaignParticipant?> participateInCampaign(String campaignId) async {
    final response = await _apiClient.post('campaigns/$campaignId/interest');

    if (response.statusCode == 201) {
      return CampaignParticipant.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 409) {
      throw Exception('Você já está registrado nesta campanha');
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Erro ao registrar interesse na campanha.');
    }
  }

  // Remover interesse da campanha
  Future<bool> removeInterest(String campaignId) async {
    final response = await _apiClient.delete('campaigns/$campaignId/interest');

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Erro ao cancelar participação.');
    }
  }

  // Verificar se usuário tem interesse na campanha
  Future<bool> checkMyInterest(String campaignId) async {
    try {
      final response =
          await _apiClient.get('campaigns/$campaignId/my-interest');

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Contar participantes da campanha
  Future<int> getParticipantCount(String campaignId) async {
    try {
      final response =
          await _apiClient.get('campaigns/$campaignId/participants/count');

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Listar participantes (para organizadores)
  Future<List<CampaignParticipant>> getParticipants(String campaignId,
      {int page = 0, int size = 20}) async {
    final response = await _apiClient
        .get('campaigns/$campaignId/participants?page=$page&size=$size');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> participantsJson = data['content'] ?? [];
      return participantsJson
          .map((json) => CampaignParticipant.fromJson(json))
          .toList();
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Erro ao carregar participantes.');
    }
  }

  // Listar todos os participantes (sem paginação)
  Future<List<CampaignParticipant>> getAllParticipants(
      String campaignId) async {
    final response =
        await _apiClient.get('campaigns/$campaignId/participants/all');

    if (response.statusCode == 200) {
      final List<dynamic> participantsJson =
          jsonDecode(utf8.decode(response.bodyBytes));
      return participantsJson
          .map((json) => CampaignParticipant.fromJson(json))
          .toList();
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Erro ao carregar todos os participantes.');
    }
  }

  // Listar minhas participações
  Future<List<CampaignParticipant>> getMyParticipations(
      {int page = 0, int size = 20}) async {
    final response = await _apiClient
        .get('campaigns/my-participations?page=$page&size=$size');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> participationsJson = data['content'] ?? [];
      return participationsJson
          .map((json) => CampaignParticipant.fromJson(json))
          .toList();
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Erro ao carregar minhas participações.');
    }
  }
}
