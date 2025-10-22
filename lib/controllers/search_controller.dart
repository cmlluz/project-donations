import 'package:flutter/material.dart';
import 'package:appdonationsgestor/components/search_item.dart';
import 'package:appdonationsgestor/services/api_services.dart';

class AppSearchController with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<SearchItem> _allItems = [];
  List<SearchItem> get allItems => _allItems;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  SearchCategory _selectedCategory = SearchCategory.todos;
  SearchCategory get selectedCategory => _selectedCategory;

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final needs = await _apiService.getNeeds();
      final donations = await _apiService.getDonations();
      // final posts = await _apiService.getPosts(); // Descomente quando quiser adicionar posts

      _allItems = [
        ...needs.map((n) => SearchItem(
              id: n.id,
              title: n.title,
              description: n.description,
              imageUrl: 'assets/placeholder.png',
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
              imageUrl: 'assets/placeholder.png',
              category: SearchCategory.doacao,
              institution: d.donatorName,
              date: d.date ?? DateTime.now(),
              status: d.status,
              quantity: d.quantity,
            )),
      ];
    } catch (e) {
      print('Erro ao carregar itens: $e');
    }

    _isLoading = false;
    notifyListeners();
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
