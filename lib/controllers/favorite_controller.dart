import 'package:flutter/material.dart';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/favorites_api_service.dart';

class FavoriteController with ChangeNotifier {
  late final FavoriteApiService _favoriteApiService;
  final ApiClient _apiClient = ApiClient();

  List<Donation> _favoriteDonations = [];
  List<Need> _favoriteNeeds = [];
  List<Map<String, dynamic>> _favoriteUsers = [];

  List<Donation> get favoriteDonations => _favoriteDonations;
  List<Need> get favoriteNeeds => _favoriteNeeds;
  List<Map<String, dynamic>> get favoriteUsers => _favoriteUsers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  FavoriteController() {
    _favoriteApiService = FavoriteApiService(_apiClient);
    loadFavorites(); // Carrega os favoritos quando o app inicia
  }

  Future<void> loadFavorites({bool notify = true}) async {
    _isLoading = true;
    _errorMessage = '';
    if (notify) notifyListeners();

    try {
      final donationsFuture =
          _favoriteApiService.getFavoriteDonations(page: 0, size: 200);
      final needsFuture =
          _favoriteApiService.getFavoriteNeeds(page: 0, size: 200);
      final usersFuture =
          _favoriteApiService.getFavoriteUsers(page: 0, size: 200);

      final results =
          await Future.wait([donationsFuture, needsFuture, usersFuture]);

      _favoriteDonations = (results[0] as PaginatedResponse<Donation>).content;
      _favoriteNeeds = (results[1] as PaginatedResponse<Need>).content;
      _favoriteUsers =
          (results[2] as PaginatedResponse<Map<String, dynamic>>).content;
    } catch (e) {
      _errorMessage = "Erro ao carregar favoritos: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavoriteDonation(Donation donation) async {
    try {
      await _favoriteApiService.addFavoriteDonation(donation.id);
      _favoriteDonations.add(donation); // Atualização otimista
      notifyListeners();
    } catch (e) {
      print("Erro ao adicionar favorito: $e");
      rethrow;
    }
  }

  Future<void> removeFavoriteDonation(Donation donation) async {
    try {
      await _favoriteApiService.removeFavoriteDonation(donation.id);
      _favoriteDonations.removeWhere((d) => d.id == donation.id);
      notifyListeners();
    } catch (e) {
      print("Erro ao remover favorito: $e");
      rethrow;
    }
  }

  Future<void> addFavoriteNeed(Need need) async {
    try {
      await _favoriteApiService.addFavoriteNeed(need.id);
      _favoriteNeeds.add(need);
      notifyListeners();
    } catch (e) {
      print("Erro ao adicionar favorito: $e");
      rethrow;
    }
  }

  Future<void> removeFavoriteNeed(Need need) async {
    try {
      await _favoriteApiService.removeFavoriteNeed(need.id);
      _favoriteNeeds.removeWhere((n) => n.id == need.id);
      notifyListeners();
    } catch (e) {
      print("Erro ao remover favorito: $e");
      rethrow;
    }
  }

  Future<void> addFavoriteUser(Map<String, dynamic> user) async {
    try {
      await _favoriteApiService.addFavoriteUser(user['firebaseUid']);
      _favoriteUsers.add(user);
      notifyListeners();
    } catch (e) {
      print("Erro ao adicionar favorito: $e");
      rethrow;
    }
  }

  Future<void> removeFavoriteUser(Map<String, dynamic> user) async {
    try {
      await _favoriteApiService.removeFavoriteUser(user['firebaseUid']);
      _favoriteUsers
          .removeWhere((u) => u['firebaseUid'] == user['firebaseUid']);
      notifyListeners();
    } catch (e) {
      print("Erro ao remover favorito: $e");
      rethrow;
    }
  }

  // Verifica se um item já está favoritado (para as páginas de detalhe)
  bool isDonationFavorite(int id) {
    return _favoriteDonations.any((d) => d.id == id);
  }

  bool isNeedFavorite(int id) {
    return _favoriteNeeds.any((n) => n.id == id);
  }

  bool isUserFavorite(String uid) {
    return _favoriteUsers.any((u) => u['firebaseUid'] == uid);
  }
}
