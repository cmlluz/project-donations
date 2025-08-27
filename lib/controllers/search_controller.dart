import 'package:flutter/foundation.dart';
import 'package:appdonationsgestor/components/search_item.dart';

class AppSearchController extends ChangeNotifier {
  List<SearchItem> _allItems = [];
  String _searchQuery = '';
  SearchCategory _selectedCategory = SearchCategory.todos;
  bool _isLoading = false;

  // Getters
  List<SearchItem> get allItems => _allItems;
  String get searchQuery => _searchQuery;
  SearchCategory get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  List<SearchItem> get filteredItems {
    var filtered = _allItems;

    if (_selectedCategory != SearchCategory.todos) {
      filtered =
          filtered.where((item) => item.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((item) =>
              item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  // Methods
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateCategory(SearchCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      _allItems = _getMockData();
    } catch (e) {
      // Handle error
      debugPrint('Error loading items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<SearchItem> _getMockData() {
    return [
      SearchItem(
        id: '1',
        title: 'Doação de Roupas',
        description: 'Roupas em bom estado para famílias carentes',
        imageUrl: 'assets/donations.jpg',
        category: SearchCategory.doacao,
        createdAt: DateTime.now(),
        location: 'Centro, Salvador',
        institution: 'Doador Anônimo',
        institutionImageUrl: 'assets/profile.jpg',
      ),
      SearchItem(
        id: '2',
        title: 'Instituto dos Idosos',
        description: 'Cuidados especializados para a terceira idade',
        imageUrl: 'assets/instituicao.png',
        category: SearchCategory.instituicao,
        createdAt: DateTime.now(),
        location: 'Barbalho, Salvador',
        institution: 'Instituto dos Idosos São Francisco',
        institutionImageUrl: 'assets/instituicao.png',
      ),
      SearchItem(
        id: '3',
        title: 'Necessidade de Alimentos',
        description: 'Alimentos não perecíveis para comunidades carentes',
        imageUrl: 'assets/donations2.jpg',
        category: SearchCategory.necessidade,
        createdAt: DateTime.now(),
        location: 'Liberdade, Salvador',
        institution: 'Casa da Esperança',
        institutionImageUrl: 'assets/instituicao.png',
      ),
      SearchItem(
        id: '4',
        title: 'Doação de Brinquedos',
        description: 'Brinquedos em bom estado para crianças carentes',
        imageUrl: 'assets/donations.jpg',
        category: SearchCategory.doacao,
        createdAt: DateTime.now(),
        location: 'Pelourinho, Salvador',
        institution: 'Família Solidária',
        institutionImageUrl: 'assets/profile.jpg',
      ),
      SearchItem(
        id: '5',
        title: 'Necessidade de Agasalhos para Idosos',
        description:
            'Precisamos de agasalhos para os idosos devido às baixas temperaturas',
        imageUrl: 'assets/donations2.jpg',
        category: SearchCategory.necessidade,
        createdAt: DateTime.now(),
        location: 'Barbalho, Salvador',
        institution: 'Lar dos Idosos São Francisco',
        institutionImageUrl: 'assets/instituicao.png',
      ),
      SearchItem(
        id: '6',
        title: 'Instituto Casa de Apoio à Criança',
        description:
            'Instituição que atende crianças em situação de risco social',
        imageUrl: 'assets/instituicao.png',
        category: SearchCategory.instituicao,
        createdAt: DateTime.now(),
        location: 'Federação, Salvador',
        institution: 'Casa de Apoio à Criança',
        institutionImageUrl: 'assets/instituicao.png',
      ),
      SearchItem(
        id: '7',
        title: 'Necessidade de Material Escolar',
        description:
            'Cadernos, lápis e materiais escolares para crianças carentes',
        imageUrl: 'assets/donations.jpg',
        category: SearchCategory.necessidade,
        createdAt: DateTime.now(),
        location: 'Subúrbio, Salvador',
        institution: 'Escola Comunitária',
        institutionImageUrl: 'assets/instituicao.png',
      ),
      SearchItem(
        id: '8',
        title: 'Doação de Livros Infantis',
        description: 'Doação de livros infantis em bom estado',
        imageUrl: 'assets/donations2.jpg',
        category: SearchCategory.doacao,
        createdAt: DateTime.now(),
        location: 'Barra, Salvador',
        institution: 'Biblioteca Comunitária',
        institutionImageUrl: 'assets/profile.jpg',
      ),
    ];
  }
}
