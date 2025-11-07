import 'package:appdonationsgestor/controllers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/pages/profile_pages/publications_page.dart';
import 'package:appdonationsgestor/components/profile_components/history_card.dart';
import 'package:appdonationsgestor/components/profile_components/expandable_card.dart';
import 'package:appdonationsgestor/pages/settings_pages/settings_page.dart';
import 'package:appdonationsgestor/pages/post_detail_page.dart';
import 'package:appdonationsgestor/models/post_model.dart';
import 'package:provider/provider.dart';

class ManagerProfilePage extends StatefulWidget {
  const ManagerProfilePage({super.key});

  @override
  State<ManagerProfilePage> createState() => _ManagerProfilePageState();
}

class _ManagerProfilePageState extends State<ManagerProfilePage> {
  bool showDonations = false;

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
    PostModel(
      id: "2",
      title: "Vestuário - Doação",
      description: "Doação de roupas variadas para pessoas em situação de rua.",
      quantity: 50,
      imageUrl: "assets/donations.jpg",
      location: "Rio Vermelho, Salvador",
      institution: "Lar dos Idosos",
      institutionImageUrl: "assets/profile.jpg",
      createdAt: DateTime(2025, 8, 20),
      category: "doacao",
    ),
    PostModel(
      id: "3",
      title: "Sapatos - Doação",
      description: "Distribuição de sapatos para comunidades carentes.",
      quantity: 20,
      imageUrl: "assets/donations2.jpg",
      location: "Pituba, Salvador",
      institution: "Lar dos Idosos",
      institutionImageUrl: "assets/profile.jpg",
      createdAt: DateTime(2025, 8, 25),
      category: "doacao",
    ),
    PostModel(
      id: "4",
      title: "Cobertores - Doação",
      description:
          "Cobertores arrecadados para distribuição durante o inverno.",
      quantity: 15,
      imageUrl: "assets/instituicao.png",
      location: "Liberdade, Salvador",
      institution: "Lar dos Idosos",
      institutionImageUrl: "assets/profile.jpg",
      createdAt: DateTime(2025, 8, 30),
      category: "doacao",
    ),
    PostModel(
      id: "5",
      title: "Cobertores - Necessidade",
      description:
          "Cobertores arrecadados para distribuição durante o inverno.",
      quantity: 15,
      imageUrl: "assets/instituicao.png",
      location: "Liberdade, Salvador",
      institution: "Lar dos Idosos",
      institutionImageUrl: "assets/profile.jpg",
      createdAt: DateTime(2025, 8, 30),
      category: "necessidade",
    ),
  ];

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
                  user?.bio ??
                      "Esta instituição ainda não adicionou uma descrição.",
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
                GridView.builder(
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
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
