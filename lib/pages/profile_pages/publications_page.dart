import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/card_item.dart';
import 'package:appdonationsgestor/pages/edit_post_page.dart'; // 🔹 Certifique-se de criar/importar essa página

class PublicationsPage extends StatefulWidget {
  const PublicationsPage({super.key});

  @override
  State<PublicationsPage> createState() => _PublicationsPageState();
}

class _PublicationsPageState extends State<PublicationsPage> {
  bool isEditing = false; // 🔹 Controla se o modo edição está ativo

  final publications = [
    {
      "title": "Lucia Fontes",
      "subtitle":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor...",
      "avatarUrl": "https://randomuser.me/api/portraits/women/68.jpg",
      "location": "Salvador, Bahia",
      "date": "15 Jun, 2025",
      "imageAsset": "assets/donations.jpg",
    },
    {
      "title": "Lucia Fontes",
      "subtitle": "Outra publicação com texto menor",
      "avatarUrl": "https://randomuser.me/api/portraits/women/68.jpg",
      "location": "Salvador, Bahia",
      "date": "15 Jun, 2025",
      "imageAsset": "assets/donations2.jpg",
    },
    {
      "title": "Lucia Fontes",
      "subtitle":
          "Doações arrecadadas para a comunidade do bairro. Obrigado a todos que ajudaram!",
      "avatarUrl": "https://randomuser.me/api/portraits/women/68.jpg",
      "location": "Salvador, Bahia",
      "date": "15 Jun, 2025",
      "imageAsset": "assets/instituicao.png",
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
        title: Text(
          "Publicações",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: ConstantsColors.blueShade900,
          ).merge(TextStylesConstants.kpoppinsMedium),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isEditing
                  ? Icons.check
                  : Icons.edit, // Alterna entre lápis e check
              color: ConstantsColors.blueShade900,
            ),
            onPressed: () {
              setState(() {
                isEditing = !isEditing; // Ativa/desativa modo edição
              });
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12),
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemCount: publications.length,
        itemBuilder: (context, index) {
          final pub = publications[index];
          return GestureDetector(
            onTap: isEditing
                ? () {
                    // 🔹 Se estiver em modo de edição, abre a tela de edição
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPostPage(postData: pub),
                      ),
                    );
                  }
                : null,
            child: CardItem(
              title: pub["title"]!,
              subtitle: pub["subtitle"],
              avatarUrl: pub["avatarUrl"]!,
              location: pub["location"]!,
              date: pub["date"]!,
              imageAsset: pub["imageAsset"]!,
            ),
          );
        },
      ),
    );
  }
}
