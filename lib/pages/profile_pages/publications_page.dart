import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/card_item.dart';

class PublicationsPage extends StatelessWidget {
  const PublicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12),
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemCount: publications.length,
        itemBuilder: (context, index) {
          final pub = publications[index];
          return CardItem(
            title: pub["title"]!,
            subtitle: pub["subtitle"],
            avatarUrl: pub["avatarUrl"]!,
            location: pub["location"]!,
            date: pub["date"]!,
            imageAsset: pub["imageAsset"]!,
          );
        },
      ),
    );
  }
}
