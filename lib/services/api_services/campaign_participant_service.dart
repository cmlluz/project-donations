import 'dart:convert';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/models/campaign_participant_model.dart';

class CampaignParticipantService {
  final ApiClient _apiClient;

  CampaignParticipantService(this._apiClient);

  // Registrar interesse na campanha
  Future<CampaignParticipant?> participateInCampaign(String campaignId) async {
    try {
      final response = await _apiClient.post('campaigns/$campaignId/interest');
      if (response.statusCode == 201) {
        return CampaignParticipant.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 409) {
        throw Exception('Já registrado nesta campanha');
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao registrar interesse: $e');
    }
  }

  // Verificar se usuário já tem interesse na campanha
  Future<bool> checkMyInterest(String campaignId) async {
    try {
      final response =
          await _apiClient.get('campaigns/$campaignId/my-interest');
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        return responseBody.toLowerCase() == 'true';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Contar número de participantes
  Future<int> getParticipantCount(String campaignId) async {
    try {
      final response =
          await _apiClient.get('campaigns/$campaignId/participants/count');
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        return int.tryParse(responseBody) ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Listar todos os participantes (para organizadores)
  Future<List<CampaignParticipant>> getAllParticipants(
      String campaignId) async {
    try {
      final response =
          await _apiClient.get('campaigns/$campaignId/participants/all');
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body
            .map((dynamic item) => CampaignParticipant.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
