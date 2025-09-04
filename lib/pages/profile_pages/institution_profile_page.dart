import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/profile_components/donation_card.dart';
import 'package:appdonationsgestor/components/profile_components/expandable_card.dart';
import 'package:appdonationsgestor/pages/settings_pages/settings_page.dart';
import 'package:appdonationsgestor/pages/profile_pages/nota_fiscal_detail_page.dart';
import 'package:appdonationsgestor/components/profile_components/nota_fiscal_card.dart';
import 'package:appdonationsgestor/pages/post_detail_page.dart';
import 'package:appdonationsgestor/models/post_model.dart';

class InstitutionProfilePage extends StatefulWidget {
  const InstitutionProfilePage({super.key});

  @override
  State<InstitutionProfilePage> createState() => _InstitutionProfilePageState();
}

class _InstitutionProfilePageState extends State<InstitutionProfilePage> {
  int selectedTab = 0;

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
  ];

  final List<Map<String, String>> notasFiscais = [
    {"titulo": "Exemplo de Nota Fiscal", "dataEmissao": "12/08/2025"},
    {
      "titulo": "Nota Fiscal para o Instituto Doação",
      "dataEmissao": "20/08/2025"
    },
    {
      "titulo": "Nota Fiscal para o Instituto Necessidade",
      "dataEmissao": "25/08/2025"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade900,
      appBar: AppBar(
        backgroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: ConstantsColors.blueShade900),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: ConstantsColors.blueShade900),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header perfil ---
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/profile.jpg"),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lar dos Idosos",
                          style: TextStylesConstants.kpoppinsMedium.merge(
                            const TextStyle(
                              fontSize: 18,
                              color: ConstantsColors.blueShade900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.phone,
                                size: 16, color: ConstantsColors.blueShade900),
                            const SizedBox(width: 4),
                            Text("(71)1234-5678",
                                style: TextStylesConstants.kinterRegular),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.email,
                                size: 16, color: ConstantsColors.blueShade900),
                            const SizedBox(width: 4),
                            Text("lardosidosos@email.com",
                                style: TextStylesConstants.kinterRegular),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Detalhes",
                style: TextStylesConstants.kpoppinsRegular.merge(
                  const TextStyle(
                    fontSize: 20,
                    color: ConstantsColors.blueShade900,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua...",
                style: TextStylesConstants.kpoppinsMedium.merge(
                  const TextStyle(
                    fontSize: 14,
                    color: ConstantsColors.greyShade600,
                    height: 1.5,
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
                    _buildTabButton("Doações", 1),
                    _buildTabButton("Notas Fiscais", 2),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (selectedTab == 0) _buildPosts(),
              if (selectedTab == 1) _buildDonations(),
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
        return ExpandableCard(imageUrl: posts[index]);
      },
    );
  }

  Widget _buildDonations() {
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

        return DonationCard(
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
