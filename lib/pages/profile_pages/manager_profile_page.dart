import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/profile_components/donation_card.dart';
import 'package:appdonationsgestor/components/profile_components/expandable_card.dart';

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

  final List<Map<String, dynamic>> donations = [
    {
      "titulo": "Agasalhos - Doação",
      "local": "Barbalho, Salvador",
      "quantidade": "5",
      "imagem": "assets/instituicao.png"
    },
    {
      "titulo": "Vestuário - Doação",
      "local": "Rio Vermelho, Salvador",
      "quantidade": "12",
      "imagem": "assets/donations.jpg"
    },
    {
      "titulo": "Sapatos - Doação",
      "local": "Pituba, Salvador",
      "quantidade": "7",
      "imagem": "assets/donations2.jpg"
    },
    {
      "titulo": "Livros - Doação",
      "local": "Barra, Salvador",
      "quantidade": "15",
      "imagem": "assets/donations.jpg"
    },
    {
      "titulo": "Cobertores - Doação",
      "local": "Liberdade, Salvador",
      "quantidade": "8",
      "imagem": "assets/instituicao.png"
    },
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
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                      "assets/profile.jpg",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lucia Fontes",
                          style: TextStylesConstants.kpoppinsMedium.merge(
                            const TextStyle(
                              fontSize: 16,
                              color: ConstantsColors.blueShade900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Contato",
                          style: TextStylesConstants.kinterBold.merge(
                            const TextStyle(
                              fontSize: 13,
                              color: ConstantsColors.blueShade900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone,
                                size: 16, color: ConstantsColors.blueShade900),
                            const SizedBox(width: 4),
                            Text(
                              "(71)1234-5678",
                              style: TextStylesConstants.kinterRegular.merge(
                                const TextStyle(
                                  fontSize: 13,
                                  color: ConstantsColors.greyShade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.email,
                                size: 16, color: ConstantsColors.blueShade900),
                            const SizedBox(width: 4),
                            Text(
                              "luciafontes@gmail.com",
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
                        Navigator.pushNamed(context, '/settings');
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
                              "Doações",
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
                        print('Publicação clicada: ${posts[index]}');
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
                    return DonationCard(
                      titulo: donations[index]["titulo"],
                      local: donations[index]["local"],
                      quantidade: donations[index]["quantidade"],
                      imagem: donations[index]["imagem"],
                      onTap: () {
                        print('Doação clicada: ${donations[index]["titulo"]}');
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
