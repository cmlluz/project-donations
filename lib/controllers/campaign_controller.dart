import 'package:flutter/material.dart';
import 'package:appdonationsgestor/models/campaign_model.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/campaign_api_service.dart';

class CampaignController with ChangeNotifier {
  late final CampaignApiService _campaignApiService;
  final ApiClient _apiClient = ApiClient();

  List<Campaign> _campaigns = [];
  List<Campaign> _filteredCampaigns = [];
  Campaign? _selectedCampaign;
  String? _authorProfilePictureUrl;

  List<Campaign> get campaigns =>
      _filteredCampaigns.isEmpty ? _campaigns : _filteredCampaigns;

  Campaign? get selectedCampaign => _selectedCampaign;

  // URL da foto do autor da campanha selecionada
  String? get authorProfilePictureUrl => _authorProfilePictureUrl;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  CampaignController() {
    _campaignApiService = CampaignApiService(_apiClient);
  }

  // Para Histórico do perfil, Busca "Todos" e "Campanhas"
  Future<void> loadCampaigns({bool notify = true}) async {
    _isLoading = true;
    _errorMessage = '';
    if (notify) notifyListeners();

    try {
      _campaigns = await _campaignApiService.getCampaigns();
      _filteredCampaigns.clear();
    } catch (e) {
      _errorMessage = 'Erro ao carregar campanhas: $e';
      print('Erro no CampaignController: $e');
    } finally {
      _isLoading = false;
      if (notify) notifyListeners();
    }
  }

  // Para Histórico do perfil - carrega apenas campanhas do usuário atual
  Future<void> loadMyCampaigns({bool notify = true}) async {
    _isLoading = true;
    _errorMessage = '';
    if (notify) notifyListeners();

    try {
      _campaigns = await _campaignApiService.getMyCampaigns();
      _filteredCampaigns.clear();
    } catch (e) {
      _errorMessage = 'Erro ao carregar minhas campanhas: $e';
      print('Erro no CampaignController (getMyCampaigns): $e');
    } finally {
      _isLoading = false;
      if (notify) notifyListeners();
    }
  }

  // Para Campaign Details Page
  Future<void> loadCampaignById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _selectedCampaign = await _campaignApiService.getCampaignById(id);
    } catch (e) {
      _errorMessage = 'Erro ao carregar campanha: $e';
      print('Erro ao carregar campanha por ID: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Para Publish Campaign Page
  Future<bool> createCampaign(Map<String, dynamic> campaignData) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final newCampaign =
          await _campaignApiService.createCampaign(campaignData);
      // Adiciona à lista local para atualizar cache
      _campaigns.insert(0, newCampaign);
      _applyCurrentFilter();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao criar campanha: $e';
      print('Erro ao criar campanha: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Para Campaign Edit Page
  Future<bool> updateCampaign(
      String id, Map<String, dynamic> campaignData) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final updatedCampaign =
          await _campaignApiService.updateCampaign(id, campaignData);

      // Atualiza na lista local
      final index =
          _campaigns.indexWhere((campaign) => campaign.id.toString() == id);
      if (index != -1) {
        _campaigns[index] = updatedCampaign;
      }

      // Atualiza a campanha selecionada
      if (_selectedCampaign?.id.toString() == id) {
        _selectedCampaign = updatedCampaign;
      }

      _applyCurrentFilter();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao atualizar campanha: $e';
      print('Erro ao atualizar campanha: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Para Campaign Details Page
  Future<bool> deleteCampaign(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _campaignApiService.deleteCampaign(id);

      // Remove da lista local
      _campaigns.removeWhere((campaign) => campaign.id.toString() == id);

      // Limpa a seleção se foi a campanha deletada
      if (_selectedCampaign?.id.toString() == id) {
        _selectedCampaign = null;
      }

      _applyCurrentFilter();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao deletar campanha: $e';
      print('Erro ao deletar campanha: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Para Páginas de busca - filtrar por texto
  void searchCampaigns(String query) {
    _searchQuery = query;
    _applyCurrentFilter();
    notifyListeners();
  }

  // Filtra campanhas por título e descrição
  void _applyCurrentFilter() {
    if (_searchQuery.isNotEmpty) {
      _filteredCampaigns = _campaigns
          .where((campaign) =>
              campaign.titulo
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              campaign.descricao
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              campaign.localizacao
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    } else {
      _filteredCampaigns.clear();
    }
  }

  // Para Páginas de busca - limpar filtros
  void clearFilters() {
    _searchQuery = '';
    _filteredCampaigns.clear();
    notifyListeners();
  }

  // Para Limpar mensagens de erro em todas as páginas
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Para Pull-to-refresh nas páginas de listagem
  Future<void> refresh({bool myOnly = false}) async {
    if (myOnly) {
      await loadMyCampaigns();
    } else {
      await loadCampaigns();
    }
  }

  // Para Verificar se uma campanha específica existe na lista
  bool hasCampaign(int campaignId) {
    return _campaigns.any((campaign) => campaign.id == campaignId);
  }

  // Para Campaign Details Page - versão com carregamento automático da foto
  Future<void> loadCampaignByIdWithAuthor(
      String id, String? currentUserName, String? currentUserProfileUrl) async {
    await loadCampaignById(id);
    if (_selectedCampaign != null) {
      loadAuthorProfilePicture(_selectedCampaign!.authorName, currentUserName,
          currentUserProfileUrl);
    }
  }

  // Para Campaign Details Page - carregar foto do autor
  void loadAuthorProfilePicture(String? authorName, String? currentUserName,
      String? currentUserProfileUrl) {
    if (authorName == null || authorName.isEmpty) {
      _authorProfilePictureUrl = null;
    } else if (authorName == currentUserName) {
      // Se é o usuário atual, usa a foto do perfil atual
      _authorProfilePictureUrl = currentUserProfileUrl;
    } else {
      // Para outros usuários, por enquanto usa a imagem padrão
      // TODO: Implementar endpoint para buscar outros usuários quando disponível no backend
      _authorProfilePictureUrl = null;
    }
    notifyListeners();
  }
}
