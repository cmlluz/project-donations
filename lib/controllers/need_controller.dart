import 'package:flutter/material.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/needs_api_service.dart';

class NeedController with ChangeNotifier {
  late final NeedApiService _needApiService;
  final ApiClient _apiClient = ApiClient();

  List<Need> _needs = [];
  List<Need> _filteredNeeds = [];

  List<Need> get needs => _filteredNeeds.isEmpty ? _needs : _filteredNeeds;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  NeedController() {
    _needApiService = NeedApiService(_apiClient);
  }

  // Carrega todas as necessidades
  Future<void> loadNeeds({bool notify = true}) async {
    _isLoading = true;
    _errorMessage = '';
    if (notify) notifyListeners();

    try {
      _needs = await _needApiService.getNeeds();
      _filteredNeeds.clear();
    } catch (e) {
      _errorMessage = 'Erro ao carregar necessidades: $e';
      print('Erro no NeedController: $e');
    } finally {
      _isLoading = false;
      if (notify) notifyListeners();
    }
  }

  // Carrega apenas necessidades do usuário atual
  Future<void> loadMyNeeds({bool notify = true}) async {
    _isLoading = true;
    _errorMessage = '';
    if (notify) notifyListeners();

    try {
      _needs = await _needApiService.getMyNeeds();
      _filteredNeeds.clear();
    } catch (e) {
      _errorMessage = 'Erro ao carregar minhas necessidades: $e';
      print('Erro no NeedController (getMyNeeds): $e');
    } finally {
      _isLoading = false;
      if (notify) notifyListeners();
    }
  }

  // Cria uma nova necessidade
  Future<bool> createNeed(Map<String, dynamic> needData) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final newNeed = await _needApiService.createNeed(needData);
      // Adiciona à lista local para atualizar cache
      _needs.insert(0, newNeed);
      _applyCurrentFilter();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao criar necessidade: $e';
      print('Erro ao criar necessidade: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateNeedStatus(int needId, String postStatus) {
    final index = _needs.indexWhere((need) => need.id == needId);
    if (index == -1) return;

    final currentNeed = _needs[index];
    _needs[index] = Need(
      id: currentNeed.id,
      title: currentNeed.title,
      description: currentNeed.description,
      date: currentNeed.date,
      category: currentNeed.category,
      quantity: currentNeed.quantity,
      postStatus: postStatus,
      authorName: currentNeed.authorName,
      authorUid: currentNeed.authorUid,
      imageUrl: currentNeed.imageUrl,
      isFavorite: currentNeed.isFavorite,
    );

    _applyCurrentFilter();
    notifyListeners();
  }

  // Filtra necessidades por texto
  void searchNeeds(String query) {
    _searchQuery = query;
    _applyCurrentFilter();
    notifyListeners();
  }

  // Filtra necessidades por título e descrição
  void _applyCurrentFilter() {
    if (_searchQuery.isNotEmpty) {
      _filteredNeeds = _needs
          .where((need) =>
              need.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              need.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    } else {
      _filteredNeeds.clear();
    }
  }

  // Limpa o filtro
  void clearSearch() {
    _searchQuery = '';
    _filteredNeeds.clear();
    notifyListeners();
  }

  // Limpa a mensagem de erro
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
