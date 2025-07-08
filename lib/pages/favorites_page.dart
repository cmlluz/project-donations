import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/components/favorite_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<ItemModel> favoriteItems = [
    ItemModel(
        name: 'Lucia Andrade',
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        imageUrl:
            "https://media.gettyimages.com/id/1317804578/pt/foto/one-businesswoman-headshot-smiling-at-the-camera.jpg?s=612x612&w=0&k=20&c=RXbgBRAoPeDrPXNLXI74Th6Lexbk6PRQ6q0b4rIzEcc="),
    ItemModel(
        name: 'Instituto dos Idosos',
        description: 'Instituto sem fins lucrativos! Apoie essa causa',
        imageUrl: 'assets/instituicao.png'),
    ItemModel(
        name: 'Marcia Vieira',
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        imageUrl:
            "https://media.gettyimages.com/id/1317804578/pt/foto/one-businesswoman-headshot-smiling-at-the-camera.jpg?s=612x612&w=0&k=20&c=RXbgBRAoPeDrPXNLXI74Th6Lexbk6PRQ6q0b4rIzEcc="),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade900,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0, left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Favoritos',
                style: const TextStyle(
                  fontSize: 30,
                  color: ConstantsColors.blackShade900,
                ).merge(TextStylesConstants.kpoppinsBold),
              ),
            ),
          ),
        ),
      ),
      body: favoriteItems.isEmpty
          ? const Center(child: Text('Nenhum usuário favoritado.'))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  final item = favoriteItems[index];
                  return FavoriteCard(
                    name: item.name,
                    description: item.description,
                    imageUrl: item.imageUrl,
                    onDelete: () {
                      setState(() {
                        favoriteItems.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
    );
  }
}

class ItemModel {
  final String name;
  final String description;
  final String imageUrl;

  ItemModel({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}
