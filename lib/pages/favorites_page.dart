import 'package:appdonationsgestor/controllers/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/favorite_card.dart';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/models/campaign_model.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/pages/donation_detail_page.dart';
import 'package:appdonationsgestor/pages/need_detail_page.dart';
import 'package:appdonationsgestor/pages/profile_pages/institution_profile_page.dart';
import 'package:provider/provider.dart';

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
    'Campanhas',
    'Instituições',
    'Necessidades',
    'Doações'
  ];
  //Adicionar lógica pra campanha

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  Future<void> _removeItem(BuildContext context, dynamic item) async {
    final controller = context.read<FavoriteController>();
    try {
      if (item is Donation) {
        await controller.removeFavoriteDonation(item);
      } else if (item is Need) {
        await controller.removeFavoriteNeed(item);
      } else if (item is Campaign) {
        await controller.removeFavoriteCampaign(item);
      } else if (item is Map) {
        await controller.removeFavoriteUser(item['firebaseUid']);
      }
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
    return Consumer<FavoriteController>(
      builder: (context, controller, child) {
        final List<dynamic> itensFiltrados;
        final categoriaSelecionada = _filtros[_filtroSelecionadoIndex];
        final textoBusca = _searchController.text.toLowerCase();
        List<dynamic> tempItens = [];

        switch (categoriaSelecionada) {
          case 'Campanhas':
            tempItens = controller.favoriteCampaigns;
            break;
          case 'Instituições':
            tempItens = controller.favoriteUsers;
            break;
          case 'Necessidades':
            tempItens = controller.favoriteNeeds;
            break;
          case 'Doações':
            tempItens = controller.favoriteDonations;
            break;
          case 'Todos':
          default:
            tempItens = [
              ...controller.favoriteUsers,
              ...controller.favoriteNeeds,
              ...controller.favoriteDonations,
              ...controller.favoriteCampaigns
            ];
        }

        if (textoBusca.isNotEmpty) {
          itensFiltrados = tempItens.where((item) {
            String name = '';
            if (item is Donation) {
              name = item.title;
            } else if (item is Need) {
              name = item.title;
            } else if (item is Campaign) {
              name = item.titulo;
            } else if (item is Map) {
              name = item['name'] ?? '';
            }
            return name.toLowerCase().contains(textoBusca);
          }).toList();
        } else {
          itensFiltrados = tempItens;
        }

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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
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
                          },
                        );
                      }),
                    ),
                  ),
                ),
                Expanded(
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : controller.errorMessage.isNotEmpty
                          ? Center(
                              child: Text(controller.errorMessage,
                                  style: const TextStyle(color: Colors.red)))
                          : itensFiltrados.isEmpty
                              ? const Center(
                                  child: Text('Nenhum favorito encontrado.'))
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  itemCount: itensFiltrados.length,
                                  itemBuilder: (context, index) {
                                    final item = itensFiltrados[index];
                                    return _buildFavoriteCard(item);
                                  },
                                ),
                ),
              ],
            ),
          ),
        );
      },
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
      onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NeedDetailPage(need: item),
          ),
        );
      };
    } else if (item is Campaign) {
      name = item.titulo;
      description = item.descricao;
      imageUrl =
          item.urlImagem.isNotEmpty ? item.urlImagem : 'assets/donations.jpg';
      isNetwork = item.urlImagem.isNotEmpty;
      onTap = () {
        GoRouter.of(context).push('/campaignDetails/${item.id}');
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
      onDelete: () => _removeItem(context, item),
      onTap: onTap,
    );
  }
}
