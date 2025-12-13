import 'package:appdonationsgestor/controllers/favorite_controller.dart';
import 'package:appdonationsgestor/controllers/campaign_controller.dart';
import 'package:appdonationsgestor/models/campaign_model.dart';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/models/nota_fiscal_model.dart';
import 'package:appdonationsgestor/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/profile_components/history_card.dart';
import 'package:appdonationsgestor/components/profile_components/expandable_card.dart';
import 'package:appdonationsgestor/pages/profile_pages/nota_fiscal_detail_page.dart';
import 'package:appdonationsgestor/components/profile_components/nota_fiscal_card.dart';
import 'package:appdonationsgestor/pages/post_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:appdonationsgestor/services/profile_services.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/donation_api_service.dart';
import 'package:appdonationsgestor/services/api_services/needs_api_service.dart';
import 'package:appdonationsgestor/services/api_services/nota_fiscal_api_service.dart';
import 'package:appdonationsgestor/services/api_services/post_api_service.dart';

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
  late bool _isFavorite;
  bool _isLoading = false;
  late final CampaignController _campaignController;

  final ProfileService _profileService = ProfileService();
  late final DonationApiService _donationApiService;
  late final NeedApiService _needApiService;
  late final NotaFiscalApiService _notaFiscalApiService;
  late final PostApiService _postApiService;

  List<Campaign> _institutionCampaigns = [];
  List<dynamic> _institutionHistory = [];
  List<NotaFiscal> _notasFiscais = [];
  List<PostModel> _posts = [];
  Map<String, dynamic>? _fullUserProfile;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _isFavorite = Provider.of<FavoriteController>(context, listen: false)
        .isUserFavorite(widget.userId);

    final apiClient = ApiClient();
    _donationApiService = DonationApiService(apiClient);
    _needApiService = NeedApiService(apiClient);
    _notaFiscalApiService = NotaFiscalApiService(apiClient);
    _postApiService = PostApiService(apiClient);
    _campaignController = CampaignController();

    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoadingData = true);
    try {
      _fullUserProfile = await _profileService.getUserById(widget.userId);

      await _campaignController.loadCampaignsByAuthor(widget.userId,
          notify: false);
      _institutionCampaigns = _campaignController.campaigns;

      final donations =
          await _donationApiService.getDonationsByAuthor(widget.userId);
      final needs = await _needApiService.getNeedsByAuthor(widget.userId);
      final notas = await _notaFiscalApiService.getNotasByAuthor(widget.userId);
      final posts = await _postApiService.getPostsByAuthor(widget.userId);

      _institutionHistory = [...donations, ...needs];
      _notasFiscais = notas;
      _posts = posts;
    } catch (e) {
      print("Erro ao carregar dados da instituição: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoadingData = false);
      }
    }
  }

  void _toggleFavorite() async {
    if (_isLoading) return;

    final newFavoriteState = !_isFavorite;
    final favController =
        Provider.of<FavoriteController>(context, listen: false);

    final userMap = {
      'firebaseUid': widget.userId,
      'name': _fullUserProfile?['name'] ?? widget.userName,
      'email': _fullUserProfile?['email'] ?? widget.userEmail,
      'profilePictureUrl':
          _fullUserProfile?['profilePictureUrl'] ?? widget.userImageUrl,
    };

    setState(() {
      _isLoading = true;
      _isFavorite = newFavoriteState;
    });

    try {
      if (newFavoriteState) {
        await favController.addFavoriteUser(userMap);
      } else {
        await favController.removeFavoriteUser(userMap);
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

  @override
  Widget build(BuildContext context) {
    final name = _fullUserProfile?['name'] ?? widget.userName;
    final email = _fullUserProfile?['email'] ?? widget.userEmail;
    final bio = _fullUserProfile?['bio'] ??
        "Esta instituição ainda não adicionou uma descrição.";
    final profileUrl =
        _fullUserProfile?['profilePictureUrl'] ?? widget.userImageUrl;

    ImageProvider profileImage;
    if (profileUrl != null &&
        profileUrl.isNotEmpty &&
        profileUrl.startsWith('http')) {
      profileImage = NetworkImage(profileUrl);
    } else {
      profileImage = const AssetImage("assets/profile.jpg");
    }

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
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 40.0, top: 10), 
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: profileImage,
                                onBackgroundImageError: (_, __) {},
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      name,
                                      style: TextStylesConstants.kpoppinsMedium
                                          .merge(
                                        const TextStyle(
                                          fontSize: 18, 
                                          color: ConstantsColors.blueShade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Contato",
                                      style:
                                          TextStylesConstants.kinterBold.merge(
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
                                            size: 16,
                                            color:
                                                ConstantsColors.blueShade900),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            email,
                                            style: TextStylesConstants
                                                .kinterRegular
                                                .merge(
                                              const TextStyle(
                                                fontSize: 13,
                                                color: ConstantsColors
                                                    .greyShade800,
                                              ),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isFavorite
                                  ? ConstantsColors.blueShade900
                                  : Colors.grey,
                              size: 32,
                            ),
                            onPressed: _isLoading ? null : _toggleFavorite,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
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
                        bio,
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
                          _buildTabButton("Campanhas", 2),
                          _buildTabButton("Notas Fiscais", 3),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (selectedTab == 0) _buildPosts(),
                    if (selectedTab == 1) _buildHistory(),
                    if (selectedTab == 2) _buildInstitutionCampaigns(),
                    if (selectedTab == 3) _buildNotes(),
                    const SizedBox(height: 30),
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
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPosts() {
    if (_posts.isEmpty) {
      return const Center(child: Text("Nenhuma publicação encontrada."));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(post: post),
              ),
            );
          },
          child: ExpandableCard(imageUrl: post.imageUrl),
        );
      },
    );
  }

  Widget _buildHistory() {
    if (_institutionHistory.isEmpty) {
      return const Center(
          child: Text("Nenhuma doação ou necessidade encontrada."));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: _institutionHistory.length,
      itemBuilder: (context, index) {
        final item = _institutionHistory[index];

        String title = '';
        String location = 'Local não informado';
        int quantity = 0;
        String? imageUrl;

        if (item is Donation) {
          title = item.title;
          quantity = item.quantity;
        } else if (item is Need) {
          title = item.title;
          quantity = item.quantity;
        }

        return HistoryCard(
          titulo: title,
          local: location,
          quantidade: quantity,
          imagem: imageUrl,
          onTap: () {},
        );
      },
    );
  }

  Widget _buildNotes() {
    if (_notasFiscais.isEmpty) {
      return const Center(child: Text("Nenhuma nota fiscal encontrada."));
    }

    return Column(
      children: _notasFiscais.map((nota) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: NotaFiscalCard(
            titulo: nota.titulo,
            dataEmissao:
                "${nota.dataEmissao.day}/${nota.dataEmissao.month}/${nota.dataEmissao.year}",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotaFiscalDetailPage(
                    titulo: nota.titulo,
                    imageUrls: nota.imageUrls, 
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInstitutionCampaigns() {
    if (_institutionCampaigns.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Esta instituição ainda não possui campanhas.',
            style: TextStyle(
              fontSize: 16,
              color: ConstantsColors.blueShade900,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: _institutionCampaigns.length,
      itemBuilder: (context, index) {
        final campaign = _institutionCampaigns[index];

        return HistoryCard(
          titulo: campaign.titulo,
          local: campaign.localizacao,
          quantidade: 0,
          imagem: campaign.urlImagem.isNotEmpty
              ? campaign.urlImagem
              : "assets/donations.jpg",
          onTap: () {
            GoRouter.of(context).push('/campaignDetails/${campaign.id}');
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _campaignController.dispose();
    super.dispose();
  }
}