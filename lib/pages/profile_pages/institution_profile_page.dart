import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/favorites_api_service.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/profile_components/history_card.dart';
import 'package:appdonationsgestor/components/profile_components/expandable_card.dart';
import 'package:appdonationsgestor/pages/profile_pages/nota_fiscal_detail_page.dart';
import 'package:appdonationsgestor/pages/profile_pages/publications_page.dart';
import 'package:appdonationsgestor/components/profile_components/nota_fiscal_card.dart';
import 'package:appdonationsgestor/pages/post_detail_page.dart';
import 'package:appdonationsgestor/models/post_model.dart';

class InstitutionProfilePage extends StatefulWidget {
  
  final String userId;
  final String userName;
  final String userEmail;
  final String userImageUrl;
  final bool isInitiallyFavorite;

  const InstitutionProfilePage({
    super.key,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userImageUrl,
    this.isInitiallyFavorite = false,
  });

  @override
  State<InstitutionProfilePage> createState() => _InstitutionProfilePageState();
}

class _InstitutionProfilePageState extends State<InstitutionProfilePage> {
  int selectedTab = 0;

  late final FavoriteApiService _favoriteApiService;
  final ApiClient _apiClient = ApiClient();
  late bool _isFavorite;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _favoriteApiService = FavoriteApiService(_apiClient);
    _isFavorite = widget.isInitiallyFavorite;
  }

  void _toggleFavorite() async {
    if (_isLoading) return;

    final newFavoriteState = !_isFavorite;

    setState(() {
      _isLoading = true;
      _isFavorite = newFavoriteState;
    });

    try {
      if (newFavoriteState) {
        await _favoriteApiService.addFavoriteUser(widget.userId);
      } else {
        await _favoriteApiService.removeFavoriteUser(widget.userId);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newFavoriteState
                ? 'Adicionado aos favoritos!'
                : 'Removido dos favoritos.'),
            backgroundColor: ConstantsColors.blueShade900,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFavorite = !newFavoriteState;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar favorito: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  final List<String> posts = [
    "assets/donations.jpg",
    "assets/instituicao.png",
    "assets/donations2.jpg",
    "assets/donations.jpg",
    "assets/instituicao.png",
    "assets/donations2.jpg",
  ];

  final List<PostModel> donations = [
    PostModel(
      id: "1",
      title: "Agasalhos - Doação",
      description:
          "Doação de agasalhos para famílias em situação de vulnerabilidade.",
      quantity: 35,
      imageUrl: "assets/instituicao.png",
      location: "Barbalho, Salvador",
      institution: "Lar dos Idosos",
      institutionImageUrl: "assets/profile.jpg",
      createdAt: DateTime(2025, 8, 12),
      category: "doacao",
    ),
  ];

  final List<Map<String, String>> notasFiscais = [
    {"titulo": "Exemplo de Nota Fiscal", "dataEmissao": "12/08/2025"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade900,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          backgroundColor: ConstantsColors.whiteShade900,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: ConstantsColors.blueShade900),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(widget.userImageUrl),
                    onBackgroundImageError: (_, __) {},
                    child: widget.userImageUrl.isEmpty
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: TextStylesConstants.kpoppinsMedium.merge(
                            const TextStyle(
                              fontSize: 16,
                              color: ConstantsColors.blueShade900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Contato",
                          style: TextStylesConstants.kinterBold.merge(
                            const TextStyle(
                              fontSize: 13,
                              color: ConstantsColors.blueShade900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.email,
                                size: 16, color: ConstantsColors.blueShade900),
                            const SizedBox(width: 4),
                            Text(
                              widget.userEmail,
                              style: TextStylesConstants.kinterRegular.merge(
                                const TextStyle(
                                  fontSize: 13,
                                  color: ConstantsColors.greyShade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(5, -25),
                    child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite
                            ? ConstantsColors.blueShade900
                            : Colors.grey,
                        size: 30,
                      ),
                      onPressed: _isLoading ? null : _toggleFavorite,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Detalhes",
                  style: TextStylesConstants.kpoppinsRegular.merge(
                    const TextStyle(
                      fontSize: 20,
                      color: ConstantsColors.blueShade900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut oil",
                  style: TextStylesConstants.kpoppinsMedium.merge(
                    const TextStyle(
                      fontSize: 14,
                      color: ConstantsColors.greyShade600,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: ConstantsColors.blueShade900),
                ),
                child: Row(
                  children: [
                    _buildTabButton("Publicações", 0),
                    _buildTabButton("Histórico", 1),
                    _buildTabButton("Notas Fiscais", 2),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (selectedTab == 0) _buildPosts(),
              if (selectedTab == 1) _buildHistory(),
              if (selectedTab == 2) _buildNotes(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedTab = index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected ? ConstantsColors.blueShade900 : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : ConstantsColors.blueShade900,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPosts() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PublicationsPage(),
              ),
            );
          },
          child: ExpandableCard(imageUrl: posts[index]),
        );
      },
    );
  }

  Widget _buildHistory() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final post = donations[index];

        return HistoryCard(
          titulo: post.title,
          local: post.location,
          quantidade: post.quantity,
          imagem: post.imageUrl,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(post: post),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotes() {
    return Column(
      children: notasFiscais.map((nota) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: NotaFiscalCard(
            titulo: nota["titulo"]!,
            dataEmissao: nota["dataEmissao"]!,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotaFiscalDetailPage(
                    titulo: nota["titulo"]!,
                    imagePath: "assets/nota_fiscal.png",
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
