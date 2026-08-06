import 'package:flutter/material.dart';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/donation_api_service.dart';

class DonationController with ChangeNotifier {
  late final DonationApiService _donationApiService;
  final ApiClient _apiClient = ApiClient();

  List<Donation> _donations = [];
  List<Donation> _filteredDonations = [];

  List<Donation> get donations =>
      _filteredDonations.isEmpty ? _donations : _filteredDonations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  DonationController() {
    _donationApiService = DonationApiService(_apiClient);
  }

  // Carrega todas as doações
  Future<void> loadDonations({bool notify = true}) async {
    _isLoading = true;
    _errorMessage = '';
    if (notify) notifyListeners();

    try {
      _donations = await _donationApiService.getDonations();
      _filteredDonations.clear();
    } catch (e) {
      _errorMessage = 'Erro ao carregar doações: $e';
      print('Erro no DonationController: $e');
    } finally {
      _isLoading = false;
      if (notify) notifyListeners();
    }
  }

  // Carrega apenas doações do usuário atual
  Future<void> loadMyDonations({bool notify = true}) async {
    _isLoading = true;
    _errorMessage = '';
    if (notify) notifyListeners();

    try {
      _donations = await _donationApiService.getMyDonations();
      _filteredDonations.clear();
    } catch (e) {
      _errorMessage = 'Erro ao carregar minhas doações: $e';
      print('Erro no DonationController (getMyDonations): $e');
    } finally {
      _isLoading = false;
      if (notify) notifyListeners();
    }
  }

  // Cria uma nova doação
  Future<bool> createDonation(Map<String, dynamic> donationData) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final newDonation =
          await _donationApiService.createDonation(donationData);
      // Adiciona à lista local para atualizar cache
      _donations.insert(0, newDonation);
      _applyCurrentFilter();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao criar doação: $e';
      print('Erro ao criar doação: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateDonationStatus(int donationId, String postStatus) {
    final index =
        _donations.indexWhere((donation) => donation.id == donationId);
    if (index == -1) return;

    final currentDonation = _donations[index];
    _donations[index] = Donation(
      id: currentDonation.id,
      title: currentDonation.title,
      description: currentDonation.description,
      date: currentDonation.date,
      category: currentDonation.category,
      quantity: currentDonation.quantity,
      postStatus: postStatus,
      donatorName: currentDonation.donatorName,
      donatorUid: currentDonation.donatorUid,
      imageUrl: currentDonation.imageUrl,
      isFavorite: currentDonation.isFavorite,
    );

    _applyCurrentFilter();
    notifyListeners();
  }

  // Filtra doações por texto
  void searchDonations(String query) {
    _searchQuery = query;
    _applyCurrentFilter();
    notifyListeners();
  }

  // Filtra doações por título e descrição
  void _applyCurrentFilter() {
    if (_searchQuery.isNotEmpty) {
      _filteredDonations = _donations
          .where((donation) =>
              donation.title
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              donation.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    } else {
      _filteredDonations.clear();
    }
  }

  // Limpa o filtro
  void clearSearch() {
    _searchQuery = '';
    _filteredDonations.clear();
    notifyListeners();
  }

  // Limpa a mensagem de erro
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
