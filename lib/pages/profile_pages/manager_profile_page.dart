import 'package:appdonationsgestor/controllers/user_provider.dart';
import 'package:appdonationsgestor/controllers/campaign_controller.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/donation_api_service.dart';
import 'package:appdonationsgestor/services/api_services/needs_api_service.dart';
import 'package:appdonationsgestor/models/campaign_model.dart';
import 'package:appdonationsgestor/components/profile_components/campaign_history_card.dart';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/pages/donation_detail_page.dart';
import 'package:appdonationsgestor/pages/need_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/pages/profile_pages/publications_page.dart';
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
  bool showDonations = false;

  final ApiClient _apiClient = ApiClient();
  late final DonationApiService _donationApiService;
  late final NeedApiService _needApiService;
  late final CampaignController _campaignController;

  Future<Map<String, dynamic>>? _historyFuture;

  final List<String> posts = [
    "assets/donations.jpg",
    "assets/instituicao.png",
    "assets/donations2.jpg",
    "assets/donations.jpg",
    "assets/instituicao.png",
    "assets/donations2.jpg",
    "assets/donations.jpg",
    "assets/instituicao.png",
  ];

  @override
  void initState() {
    super.initState();
    _donationApiService = DonationApiService(_apiClient);
    _needApiService = NeedApiService(_apiClient);
    _campaignController =
        Provider.of<CampaignController>(context, listen: false);

    // Listener para atualizar o histórico quando campanhas mudarem
    _campaignController.addListener(_refreshHistory);

    _loadHistory();
  }

  void _loadHistory() {
    _historyFuture = _fetchHistoryItems();
    setState(() {});
  }

  void _refreshHistory() {
    if (mounted) {
      _loadHistory();
    }
  }

  Future<Map<String, dynamic>> _fetchHistoryItems() async {
    try {
      List<Donation> donations = [];
      List<Need> needs = [];
      List<Campaign> campaigns = [];

      // Carregar doações com tratamento de erro individual
      try {
        donations = await _donationApiService.getMyDonations();
      } catch (e) {
        print("Erro ao carregar doações: $e");
        donations = [];
      }

      // Carregar necessidades com tratamento de erro individual
      try {
        needs = await _needApiService.getMyNeeds();
      } catch (e) {
        print("Erro ao carregar necessidades: $e");
        needs = [];
      }

      // Usar campanhas do controller (já carregadas e atualizadas automaticamente)
      campaigns = _campaignController.campaigns;

      // Se a lista estiver vazia, tentar carregar
      if (campaigns.isEmpty) {
        try {
          await _campaignController.loadMyCampaigns(notify: false);
          campaigns = _campaignController.campaigns;
        } catch (e) {
          print("Erro ao carregar campanhas: $e");
          campaigns = [];
        }
      }

      return {'donations': donations, 'needs': needs, 'campaigns': campaigns};
    } catch (e) {
      print("Erro geral ao carregar histórico: $e");
      // Retornar listas vazias em caso de erro geral
      return {
        'donations': <Donation>[],
        'needs': <Need>[],
        'campaigns': <Campaign>[]
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.currentUser;

    final bool isManager =
        user?.role == 'ROLE_ADMIN' || user?.role == 'ROLE_INSTITUTION';

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
                      : "Esta instituição ainda não adicionou uma descrição.",
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
                  color: ConstantsColors.blueShade900.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showDonations = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !showDonations
                                ? ConstantsColors.blueShade900
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              "Publicações",
                              style: TextStylesConstants.kpoppinsMedium.merge(
                                TextStyle(
                                  color: !showDonations
                                      ? Colors.white
                                      : ConstantsColors.blueShade900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showDonations = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: showDonations
                                ? ConstantsColors.blueShade900
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              "Histórico",
                              style: TextStylesConstants.kpoppinsMedium.merge(
                                TextStyle(
                                  color: showDonations
                                      ? Colors.white
                                      : ConstantsColors.blueShade900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (!showDonations)
                GridView.builder(
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
                )
              else
                _buildHistory(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return Consumer<CampaignController>(
      builder: (context, campaignController, child) {
        return FutureBuilder<Map<String, dynamic>>(
          future: _historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(
                    color: ConstantsColors.blueShade900,
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: ConstantsColors.redShade800,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Erro ao carregar histórico: ${snapshot.error}",
                        textAlign: TextAlign.center,
                        style: TextStylesConstants.kpoppinsMedium.merge(
                          const TextStyle(
                            color: ConstantsColors.redShade800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadHistory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstantsColors.blueShade900,
                        ),
                        child: const Text(
                          "Tentar novamente",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Esse usuário não registrou nenhuma doação, necessidade ou campanha.",
                    textAlign: TextAlign.center,
                    style: TextStylesConstants.kpoppinsMedium.merge(
                      const TextStyle(
                        color: ConstantsColors.greyShade600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }

            final List<Donation> donations = snapshot.data!['donations'] ?? [];
            final List<Need> needs = snapshot.data!['needs'] ?? [];
            final List<Campaign> campaigns = snapshot.data!['campaigns'] ?? [];
            final allItems = [...donations, ...needs, ...campaigns];

            if (allItems.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.history,
                        size: 48,
                        color: ConstantsColors.greyShade500,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Esse usuário não registrou nenhuma doação, necessidade ou campanha.",
                        textAlign: TextAlign.center,
                        style: TextStylesConstants.kpoppinsMedium.merge(
                          const TextStyle(
                            color: ConstantsColors.greyShade600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
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
              itemCount: allItems.length,
              itemBuilder: (context, index) {
                try {
                  if (index >= allItems.length) {
                    return const SizedBox.shrink();
                  }

                  final item = allItems[index];

                  if (item is Donation) {
                    return HistoryCard(
                      titulo: item.title,
                      local: "Local não informado",
                      quantidade: item.quantity,
                      imagem: null,
                      onTap: () {
                        try {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DonationDetailPage(
                                donation: item,
                                isOwnerView: true,
                              ),
                            ),
                          );
                        } catch (e) {
                          print("Erro ao navegar para detalhes da doação: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Erro ao abrir detalhes da doação"),
                              backgroundColor: ConstantsColors.redShade800,
                            ),
                          );
                        }
                      },
                    );
                  } else if (item is Need) {
                    return HistoryCard(
                      titulo: item.title,
                      local: "Local não informado",
                      quantidade: item.quantity,
                      imagem: null,
                      onTap: () {
                        try {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NeedDetailPage(
                                need: item,
                                isOwnerView: true,
                              ),
                            ),
                          );
                        } catch (e) {
                          print(
                              "Erro ao navegar para detalhes da necessidade: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Erro ao abrir detalhes da necessidade"),
                              backgroundColor: ConstantsColors.redShade800,
                            ),
                          );
                        }
                      },
                    );
                  } else if (item is Campaign) {
                    return CampaignHistoryCard(
                      titulo: item.titulo,
                      descricao: item.descricao,
                      local: item.localizacao.isNotEmpty
                          ? item.localizacao
                          : "Local não informado",
                      imagem: item.urlImagem,
                      dataInicial: item.dataInicial,
                      dataFinal: item.dataFinal,
                      onTap: () {
                        try {
                          GoRouter.of(context)
                              .push('/campaignDetails/${item.id}');
                        } catch (e) {
                          print(
                              "Erro ao navegar para detalhes da campanha: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Erro ao abrir detalhes da campanha"),
                              backgroundColor: ConstantsColors.redShade800,
                            ),
                          );
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                } catch (e) {
                  print(
                      "Erro ao construir item do histórico no índice $index: $e");
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ConstantsColors.greyShade200,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: ConstantsColors.greyShade500,
                      ),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // Remove o listener antes de fazer dispose
    _campaignController.removeListener(_refreshHistory);
    super.dispose();
  }
}
