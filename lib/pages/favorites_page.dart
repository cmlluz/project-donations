import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/favorites_api_service.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/favorite_card.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/pages/donation_detail_page.dart';
import 'package:appdonationsgestor/pages/need_detail_page.dart';
import 'package:appdonationsgestor/pages/profile_pages/institution_profile_page.dart';

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
    'Instituições',
    'Necessidades',
    'Doações'
  ];

  late final FavoriteApiService _favoriteApiService;
  final ApiClient _apiClient = ApiClient();

  List<Donation> _favoriteDonations = [];
  List<Need> _favoriteNeeds = [];
  List<Map<String, dynamic>> _favoriteUsers = [];

  List<dynamic> _itensFiltrados = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _favoriteApiService = FavoriteApiService(_apiClient);
    _loadAllFavorites();
    _searchController.addListener(_filtrarFavoritos);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filtrarFavoritos);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllFavorites() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final donationsFuture =
          _favoriteApiService.getFavoriteDonations(page: 0, size: 50);
      final needsFuture =
          _favoriteApiService.getFavoriteNeeds(page: 0, size: 50);
      final usersFuture =
          _favoriteApiService.getFavoriteUsers(page: 0, size: 50);

      final results =
          await Future.wait([donationsFuture, needsFuture, usersFuture]);

      _favoriteDonations = (results[0] as PaginatedResponse<Donation>).content;
      _favoriteNeeds = (results[1] as PaginatedResponse<Need>).content;
      _favoriteUsers =
          (results[2] as PaginatedResponse<Map<String, dynamic>>).content;

      _filtrarFavoritos();
    } catch (e) {
      setState(() {
        _errorMessage = "Erro ao carregar favoritos: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filtrarFavoritos() {
    final categoriaSelecionada = _filtros[_filtroSelecionadoIndex];
    final textoBusca = _searchController.text.toLowerCase();
    List<dynamic> tempItens = [];

    switch (categoriaSelecionada) {
      case 'Instituições':
        tempItens = _favoriteUsers;
        break;
      case 'Necessidades':
        tempItens = _favoriteNeeds;
        break;
      case 'Doações':
        tempItens = _favoriteDonations;
        break;
      case 'Todos':
      default:
        tempItens = [
          ..._favoriteUsers,
          ..._favoriteNeeds,
          ..._favoriteDonations
        ];
    }

    if (textoBusca.isNotEmpty) {
      tempItens = tempItens.where((item) {
        String name = '';
        if (item is Donation) {
          name = item.title;
        } else if (item is Need) {
          name = item.title;
        } else if (item is Map) {
          name = item['name'] ?? '';
        }
        return name.toLowerCase().contains(textoBusca);
      }).toList();
    }

    setState(() {
      _itensFiltrados = tempItens;
    });
  }

  Future<void> _removeItem(dynamic item) async {
    try {
      if (item is Donation) {
        await _favoriteApiService.removeFavoriteDonation(item.id);
        setState(() => _favoriteDonations.remove(item));
      } else if (item is Need) {
        await _favoriteApiService.removeFavoriteNeed(item.id);
        setState(() => _favoriteNeeds.remove(item));
      } else if (item is Map) {
        await _favoriteApiService.removeFavoriteUser(item['firebaseUid']);
        setState(() => _favoriteUsers.remove(item));
      }
      _filtrarFavoritos(); // Atualiza a lista exibida
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao remover favorito: $e')),
        );
      }
    }
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                      ? Center(
                          child: Text(_errorMessage,
                              style: const TextStyle(color: Colors.red)))
                      : _itensFiltrados.isEmpty
                          ? const Center(
                              child: Text('Nenhum favorito encontrado.'))
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              itemCount: _itensFiltrados.length,
                              itemBuilder: (context, index) {
                                final item = _itensFiltrados[index];
                                return _buildFavoriteCard(item);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(dynamic item) {
    String name = 'Nome não encontrado';
    String description = 'Descrição não disponível';
    String imageUrl = 'assets/placeholder.png';
    bool isNetwork = false;
    VoidCallback? onTap;

    if (item is Donation) {
      name = item.title;
      description = item.description;
      // imageUrl = item.imageUrl ?? imageUrl;
      // isNetwork = item.imageUrl != null;
      onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DonationDetailPage(donation: item),
          ),
        );
      };
    } else if (item is Need) {
      name = item.title;
      description = item.description;
      // imageUrl = item.imageUrl ?? imageUrl;
      // isNetwork = item.imageUrl != null;
      onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NeedDetailPage(need: item),
          ),
        );
      };
    } else if (item is Map) {
      name = item['name'] ?? name;
      description = item['email'] ?? description;
      imageUrl = item['profilePictureUrl'] ?? imageUrl;
      isNetwork = item['profilePictureUrl'] != null &&
          item['profilePictureUrl'].isNotEmpty;

      onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InstitutionProfilePage(
              userId: item['firebaseUid'] ?? '',
              userName: item['name'] ?? 'Usuário',
              userEmail: item['email'] ?? 'Email não disponível',
              userImageUrl: item['profilePictureUrl'] ?? '',
              isInitiallyFavorite: true,
            ),
          ),
        );
      };
    }

    return FavoriteCard(
      name: name,
      description: description,
      imageUrl: isNetwork ? imageUrl : 'assets/instituicao.png',
      isNetwork: isNetwork,
      onDelete: () => _removeItem(item),
    );
  }
}
