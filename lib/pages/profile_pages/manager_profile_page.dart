import 'package:appdonationsgestor/controllers/user_provider.dart';
import 'package:appdonationsgestor/controllers/campaign_controller.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/donation_api_service.dart';
import 'package:appdonationsgestor/services/api_services/needs_api_service.dart';
import 'package:appdonationsgestor/services/api_services/post_api_service.dart';
import 'package:appdonationsgestor/services/api_services/nota_fiscal_api_service.dart';
import 'package:appdonationsgestor/models/campaign_model.dart';
import 'package:appdonationsgestor/components/profile_components/campaign_history_card.dart';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/models/post_model.dart';
import 'package:appdonationsgestor/models/nota_fiscal_model.dart';
import 'package:appdonationsgestor/pages/donation_detail_page.dart';
import 'package:appdonationsgestor/pages/need_detail_page.dart';
import 'package:appdonationsgestor/pages/post_detail_page.dart';
import 'package:appdonationsgestor/pages/profile_pages/nota_fiscal_detail_page.dart';
import 'package:appdonationsgestor/components/profile_components/nota_fiscal_card.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/profile_components/history_card.dart';
import 'package:appdonationsgestor/components/profile_components/expandable_card.dart';
import 'package:appdonationsgestor/pages/settings_pages/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ManagerProfilePage extends StatefulWidget {
  const ManagerProfilePage({super.key});

  @override
  State<ManagerProfilePage> createState() => _ManagerProfilePageState();
}

class _ManagerProfilePageState extends State<ManagerProfilePage> {
  int selectedTab = 0;

  final ApiClient _apiClient = ApiClient();
  late final DonationApiService _donationApiService;
  late final NeedApiService _needApiService;
  late final PostApiService _postApiService;
  late final NotaFiscalApiService _notaFiscalApiService;
  late final CampaignController _campaignController;

  Future<Map<String, dynamic>>? _historyFuture;

  List<Donation>? _cachedDonations;
  List<Need>? _cachedNeeds;
  List<PostModel>? _cachedPosts;
  List<NotaFiscal>? _cachedNotasFiscais;
  String? _cachedUserId;

  @override
  void initState() {
    super.initState();
    _donationApiService = DonationApiService(_apiClient);
    _needApiService = NeedApiService(_apiClient);
    _postApiService = PostApiService(_apiClient);
    _notaFiscalApiService = NotaFiscalApiService(_apiClient);
    _campaignController =
        Provider.of<CampaignController>(context, listen: false);

    _campaignController.addListener(_refreshHistory);

    _loadHistory();
  }

  void _loadHistory() {
    _historyFuture = _fetchHistoryItems();
    setState(() {});
  }

  void _refreshHistory() {
    if (mounted) {
      _clearCache();
      _loadHistory();
    }
  }

  bool _isCampaignCacheValid() {
    final userProvider = context.read<UserProvider>();
    final currentUserId = userProvider.currentUser?.firebaseUid;

    if (currentUserId == null || _campaignController.campaigns.isEmpty) {
      return false;
    }

    return _cachedUserId == currentUserId;
  }

  void _clearCache() {
    _cachedDonations = null;
    _cachedNeeds = null;
    _cachedPosts = null;
    _cachedNotasFiscais = null;
    _cachedUserId = null;
  }

  Future<Map<String, dynamic>> _fetchHistoryItems() async {
    try {
      final userProvider = context.read<UserProvider>();
      final currentUserId = userProvider.currentUser?.firebaseUid;

      if (currentUserId == null) {
        return {
          'donations': <Donation>[],
          'needs': <Need>[],
          'campaigns': <Campaign>[],
          'posts': <PostModel>[],
          'notasFiscais': <NotaFiscal>[]
        };
      }

      List<Donation> donations = [];
      List<Need> needs = [];
      List<Campaign> campaigns = [];
      List<PostModel> posts = [];
      List<NotaFiscal> notasFiscais = [];

      if (_cachedDonations != null && _cachedUserId == currentUserId) {
        donations = _cachedDonations!;
      } else {
        try {
          donations = await _donationApiService.getMyDonations();
          _cachedDonations = donations;
        } catch (e) {
          print("Erro ao carregar doações: $e");
        }
      }

      if (_cachedNeeds != null && _cachedUserId == currentUserId) {
        needs = _cachedNeeds!;
      } else {
        try {
          needs = await _needApiService.getMyNeeds();
          _cachedNeeds = needs;
        } catch (e) {
          print("Erro ao carregar necessidades: $e");
        }
      }

      if (_cachedPosts != null && _cachedUserId == currentUserId) {
        posts = _cachedPosts!;
      } else {
        try {
          posts = await _postApiService.getPostsByAuthor(currentUserId);
          _cachedPosts = posts;
        } catch (e) {
          print("Erro ao carregar posts: $e");
        }
      }

      if (_cachedNotasFiscais != null && _cachedUserId == currentUserId) {
        notasFiscais = _cachedNotasFiscais!;
      } else {
        try {
          notasFiscais =
              await _notaFiscalApiService.getNotasByAuthor(currentUserId);
          _cachedNotasFiscais = notasFiscais;
        } catch (e) {
          print("Erro ao carregar notas fiscais: $e");
        }
      }

      if (_campaignController.campaigns.isNotEmpty && _isCampaignCacheValid()) {
        campaigns = _campaignController.campaigns;
      } else {
        try {
          await _campaignController.loadMyCampaigns(notify: false);
          campaigns = _campaignController.campaigns;
        } catch (e) {
          print("Erro ao carregar campanhas: $e");
        }
      }

      _cachedUserId = currentUserId;

      return {
        'donations': donations,
        'needs': needs,
        'campaigns': campaigns,
        'posts': posts,
        'notasFiscais': notasFiscais
      };
    } catch (e) {
      print("Erro geral ao carregar histórico: $e");
      return {
        'donations': <Donation>[],
        'needs': <Need>[],
        'campaigns': <Campaign>[],
        'posts': <PostModel>[],
        'notasFiscais': <NotaFiscal>[]
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.currentUser;

    final bool isManager =
        user?.role == 'ROLE_ADMIN' || user?.role == 'ROLE_GESTOR';

    ImageProvider? profileImage;
    if (user?.profilePictureUrl != null &&
        user!.profilePictureUrl!.isNotEmpty) {
      profileImage = NetworkImage(user.profilePictureUrl!);
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
            onPressed: () => Navigator.of(context).pop(),
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
                    backgroundImage: profileImage,
                    backgroundColor: Colors.grey.shade200,
                    child: (profileImage == null)
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: ConstantsColors.greyShade600,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              user?.name ?? "Usuário",
                              style: TextStylesConstants.kpoppinsMedium.merge(
                                const TextStyle(
                                  fontSize: 16,
                                  color: ConstantsColors.blueShade900,
                                ),
                              ),
                            ),
                            if (isManager) ...[
                              const SizedBox(width: 5),
                              Image.asset(
                                'assets/icons/verifiedIcon.png',
                                height: 18,
                                width: 18,
                              ),
                            ],
                          ],
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
                              user?.email ?? "email@exemplo.com",
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
                      icon: const Icon(Icons.settings_outlined,
                          color: ConstantsColors.blueShade900, size: 30),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()),
                        );
                      },
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
                  (user?.bio != null && user!.bio!.isNotEmpty)
                      ? user.bio!
                      : "Este usuário ainda não adicionou uma descrição.",
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPosts() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<PostModel> posts = snapshot.data!['posts'] ?? [];

        if (posts.isEmpty) {
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
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailPage(post: posts[index]),
                  ),
                );
              },
              child: ExpandableCard(imageUrl: posts[index].imageUrl),
            );
          },
        );
      },
    );
  }

  Widget _buildHistory() {
    return Consumer<CampaignController>(
      builder: (context, campaignController, child) {
        return FutureBuilder<Map<String, dynamic>>(
          future: _historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Erro: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("Nenhum histórico encontrado."));
            }

            final List<Donation> donations = snapshot.data!['donations'] ?? [];
            final List<Need> needs = snapshot.data!['needs'] ?? [];
            final List<Campaign> campaigns = snapshot.data!['campaigns'] ?? [];
            final allItems = [...donations, ...needs, ...campaigns];

            if (allItems.isEmpty) {
              return const Center(child: Text("Nenhum histórico encontrado."));
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
              itemCount: allItems.length,
              itemBuilder: (context, index) {
                final item = allItems[index];

                if (item is Donation) {
                  return HistoryCard(
                    titulo: item.title,
                    quantidade: item.quantity,
                    imagem: item.imageUrl, // CORREÇÃO: Passando a URL
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DonationDetailPage(
                            donation: item,
                            isOwnerView: true,
                          ),
                        ),
                      );
                    },
                  );
                } else if (item is Need) {
                  return HistoryCard(
                    titulo: item.title,
                    quantidade: item.quantity,
                    imagem: item.imageUrl, // CORREÇÃO: Passando a URL
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NeedDetailPage(
                            need: item,
                            isOwnerView: true,
                          ),
                        ),
                      );
                    },
                  );
                } else if (item is Campaign) {
                  return CampaignHistoryCard(
                    titulo: item.titulo,
                    descricao: item.descricao,
                    imagem: item.urlImagem,
                    dataInicial: item.dataInicial,
                    dataFinal: item.dataFinal,
                    onTap: () {
                      GoRouter.of(context).push('/campaignDetails/${item.id}');
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        );
      },
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

  Widget _buildNotes() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Erro: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Nenhuma nota fiscal encontrada."));
        }

        final List<NotaFiscal> notasFiscais =
            snapshot.data!['notasFiscais'] ?? [];

        if (notasFiscais.isEmpty) {
          return const Center(child: Text("Nenhuma nota fiscal encontrada."));
        }

        return Column(
          children: notasFiscais.map((nota) {
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
      },
    );
  }

  @override
  void dispose() {
    _campaignController.removeListener(_refreshHistory);
    super.dispose();
  }
}
