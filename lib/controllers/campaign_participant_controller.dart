import 'package:flutter/material.dart';
import 'package:appdonationsgestor/services/api_services/campaign_participant_api_service.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/models/campaign_participant_model.dart';

class CampaignParticipantController extends ChangeNotifier {
  final CampaignParticipantApiService _participantService;

  // Estado para cada campanha
  final Map<String, bool> _userInterests = {};
  final Map<String, int> _participantCounts = {};
  final Map<String, List<CampaignParticipant>> _participantLists = {};

  // Estados de loading
  final Map<String, bool> _isLoadingInterest = {};
  final Map<String, bool> _isLoadingCount = {};
  final Map<String, bool> _isLoadingParticipants = {};
  final Map<String, bool> _isSubmittingInterest = {};

  CampaignParticipantController(this._participantService);

  // Factory constructor para criar instância com ApiClient
  factory CampaignParticipantController.withApiClient() {
    final apiClient = ApiClient();
    final participantService = CampaignParticipantApiService(apiClient);
    return CampaignParticipantController(participantService);
  }

  // Getters
  bool getUserInterest(String campaignId) =>
      _userInterests[campaignId] ?? false;
  int getParticipantCount(String campaignId) =>
      _participantCounts[campaignId] ?? 0;
  List<CampaignParticipant> getParticipantList(String campaignId) =>
      _participantLists[campaignId] ?? [];

  bool isLoadingInterest(String campaignId) =>
      _isLoadingInterest[campaignId] ?? false;
  bool isLoadingCount(String campaignId) =>
      _isLoadingCount[campaignId] ?? false;
  bool isLoadingParticipants(String campaignId) =>
      _isLoadingParticipants[campaignId] ?? false;
  bool isSubmittingInterest(String campaignId) =>
      _isSubmittingInterest[campaignId] ?? false;

  // Verificar interesse do usuário
  Future<void> checkUserInterest(String campaignId) async {
    _isLoadingInterest[campaignId] = true;
    notifyListeners();

    try {
      final hasInterest = await _participantService.checkMyInterest(campaignId);
      _userInterests[campaignId] = hasInterest;
    } catch (e) {
      print('Erro ao verificar interesse: $e');
      _userInterests[campaignId] = false;
    } finally {
      _isLoadingInterest[campaignId] = false;
      notifyListeners();
    }
  }

  // Carregar contagem de participantes
  Future<void> loadParticipantCount(String campaignId) async {
    _isLoadingCount[campaignId] = true;
    notifyListeners();

    try {
      final count = await _participantService.getParticipantCount(campaignId);
      _participantCounts[campaignId] = count;
    } catch (e) {
      print('Erro ao carregar contagem: $e');
      _participantCounts[campaignId] = 0;
    } finally {
      _isLoadingCount[campaignId] = false;
      notifyListeners();
    }
  }

  // Alternar participação (registrar ou remover interesse)
  Future<bool> toggleParticipation(String campaignId) async {
    _isSubmittingInterest[campaignId] = true;
    notifyListeners();

    try {
      final currentInterest = _userInterests[campaignId] ?? false;

      if (currentInterest) {
        // Remover interesse
        final success = await _participantService.removeInterest(campaignId);
        if (success) {
          _userInterests[campaignId] = false;
          // Atualizar contagem
          _participantCounts[campaignId] = (_participantCounts[campaignId] ?? 1) - 1;
          return true;
        }
      } else {
        // Registrar interesse
        final participant =
            await _participantService.participateInCampaign(campaignId);
        if (participant != null) {
          _userInterests[campaignId] = true;
          // Atualizar contagem
          _participantCounts[campaignId] =
              (_participantCounts[campaignId] ?? 0) + 1;
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Erro ao alterar participação: $e');
      return false;
    } finally {
      _isSubmittingInterest[campaignId] = false;
      notifyListeners();
    }
  }

  // Carregar lista de participantes (para organizadores)
  Future<void> loadParticipantList(String campaignId) async {
    _isLoadingParticipants[campaignId] = true;
    notifyListeners();

    try {
      final participants =
          await _participantService.getAllParticipants(campaignId);
      _participantLists[campaignId] = participants;
    } catch (e) {
      print('Erro ao carregar participantes: $e');
      _participantLists[campaignId] = [];
    } finally {
      _isLoadingParticipants[campaignId] = false;
      notifyListeners();
    }
  }

  // Carregar dados iniciais para uma campanha
  Future<void> initializeCampaignData(String campaignId) async {
    await Future.wait([
      checkUserInterest(campaignId),
      loadParticipantCount(campaignId),
    ]);
  }

  // Limpar dados de uma campanha específica
  void clearCampaignData(String campaignId) {
    _userInterests.remove(campaignId);
    _participantCounts.remove(campaignId);
    _participantLists.remove(campaignId);
    _isLoadingInterest.remove(campaignId);
    _isLoadingCount.remove(campaignId);
    _isLoadingParticipants.remove(campaignId);
    _isSubmittingInterest.remove(campaignId);
    notifyListeners();
  }
}
