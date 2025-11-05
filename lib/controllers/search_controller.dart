import 'package:flutter/material.dart';
import 'package:appdonationsgestor/components/search_item.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/needs_api_service.dart';
import 'package:appdonationsgestor/services/api_services/donation_api_service.dart';
import 'package:appdonationsgestor/services/api_services/favorites_api_service.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/models/donation_model.dart';

class AppSearchController with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  late final NeedApiService _needsApiService;
  late final DonationApiService _donationApiService;
  late final FavoriteApiService _favoriteApiService;

  List<SearchItem> _allItems = [];
  List<SearchItem> get allItems => _allItems;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  SearchCategory _selectedCategory = SearchCategory.todos;
  SearchCategory get selectedCategory => _selectedCategory;

  AppSearchController() {
    _needsApiService = NeedApiService(_apiClient);
    _donationApiService = DonationApiService(_apiClient);
    _favoriteApiService = FavoriteApiService(_apiClient);
  }

  Future<void> loadItems() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      final needsFuture = _needsApiService.getNeeds();
      final donationsFuture = _donationApiService.getDonations();
      final favDonationIdsFuture = _favoriteApiService.getFavoriteDonationIds();
      final favNeedIdsFuture = _favoriteApiService.getFavoriteNeedIds();

      final List<dynamic> results = await Future.wait([
        needsFuture,
        donationsFuture,
        favDonationIdsFuture,
        favNeedIdsFuture
      ]);

      final List<Need> needs = results[0] as List<Need>;
      final List<Donation> donations = results[1] as List<Donation>;
      final Set<int> favDonationIds = results[2] as Set<int>;
      final Set<int> favNeedIds = results[3] as Set<int>;

      for (var n in needs) {
        n.isFavorite = favNeedIds.contains(n.id);
      }
      for (var d in donations) {
        d.isFavorite = favDonationIds.contains(d.id);
      }

      _allItems = [
        ...needs.map((n) => SearchItem(
              id: n.id,
              title: n.title,
              description: n.description,
              imageUrl: 'assets/donations.png',
              category: SearchCategory.necessidade,
              institution: n.authorName,
              date: n.date ?? DateTime.now(),
              status: n.status,
              quantity: n.quantity,
            )),
        ...donations.map((d) => SearchItem(
              id: d.id,
              title: d.title,
              description: d.description,
              imageUrl: 'assets/donations.png',
              category: SearchCategory.doacao,
              institution: d.donatorName,
              date: d.date ?? DateTime.now(),
              status: d.status,
              quantity: d.quantity,
            )),
      ];
    } catch (e) {
      print('Erro ao carregar itens no AppSearchController: $e');
      _allItems = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateCategory(SearchCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
