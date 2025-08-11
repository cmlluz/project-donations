import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/favorite_card.dart';

class ItemModel {
  final String name;
  final String description;
  final String imageUrl;
  final String category;

  ItemModel({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
  });
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final TextEditingController _searchController = TextEditingController();
  int _filtroSelecionadoIndex = 0;
  final List<String> _filtros = [
    'Todos',
    'Doadores',
    'Instituições',
    'Necessidades',
    'Doações'
  ];

  final List<ItemModel> _todosOsFavoritos = [
    ItemModel(
        name: 'Lucia Andrade',
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
        imageUrl:
            "https://media.gettyimages.com/id/1317804578/pt/foto/one-businesswoman-headshot-smiling-at-the-camera.jpg?s=612x612&w=0&k=20&c=RXbgBRAoPeDrPXNLXI74Th6Lexbk6PRQ6q0b4rIzEcc=",
        category: 'Doadores'),
    ItemModel(
        name: 'Instituto dos Idosos',
        description: 'Instituto sem fins lucrativos! Apoie essa causa',
        imageUrl: 'assets/instituicao.png',
        category: 'Instituições'),
    ItemModel(
        name: 'Marcia Vieira',
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
        imageUrl:
            "https://media.gettyimages.com/id/1317804578/pt/foto/one-businesswoman-headshot-smiling-at-the-camera.jpg?s=612x612&w=0&k=20&c=RXbgBRAoPeDrPXNLXI74Th6Lexbk6PRQ6q0b4rIzEcc=",
        category: 'Doadores'),
  ];

  List<ItemModel> _itensFiltrados = [];

  @override
  void initState() {
    super.initState();
    _itensFiltrados = _todosOsFavoritos;
    _searchController.addListener(_filtrarFavoritos);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filtrarFavoritos);
    _searchController.dispose();
    super.dispose();
  }

  void _filtrarFavoritos() {
    List<ItemModel> tempItens = [];
    final categoriaSelecionada = _filtros[_filtroSelecionadoIndex];
    final textoBusca = _searchController.text.toLowerCase();

    if (categoriaSelecionada == 'Todos') {
      tempItens = _todosOsFavoritos;
    } else {
      tempItens = _todosOsFavoritos.where((item) {
        return item.category == categoriaSelecionada;
      }).toList();
    }

    if (textoBusca.isNotEmpty) {
      tempItens = tempItens.where((item) {
        return item.name.toLowerCase().contains(textoBusca);
      }).toList();
    }

    setState(() {
      _itensFiltrados = tempItens;
    });
  }

  Widget _buildFilterChip({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? ConstantsColors.blueShade900
                    : ConstantsColors.blackShade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            if (isSelected)
              Container(
                height: 2,
                width: 25,
                color: ConstantsColors.blueShade900,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade700,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Favoritos',
                style: TextStyle(
                  fontSize: 30,
                  color: ConstantsColors.blueShade900,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'O que você busca?',
                  suffixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: ConstantsColors.blueShade900,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: ConstantsColors.blueShade900,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: ConstantsColors.whiteShade700,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 60,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: List.generate(_filtros.length, (index) {
                    return _buildFilterChip(
                      text: _filtros[index],
                      isSelected: _filtroSelecionadoIndex == index,
                      onTap: () {
                        setState(() {
                          _filtroSelecionadoIndex = index;
                        });
                        _filtrarFavoritos();
                      },
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              child: _itensFiltrados.isEmpty
                  ? const Center(child: Text('Nenhum favorito encontrado.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: _itensFiltrados.length,
                      itemBuilder: (context, index) {
                        final item = _itensFiltrados[index];
                        return FavoriteCard(
                          // Seu card customizado
                          name: item.name,
                          description: item.description,
                          imageUrl: item.imageUrl,
                          onDelete: () {
                            setState(() {
                              _todosOsFavoritos.removeWhere((originalItem) =>
                                  originalItem.name == item.name);
                              _itensFiltrados.removeAt(index);
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
