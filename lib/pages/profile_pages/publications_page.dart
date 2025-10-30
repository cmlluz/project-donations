import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/card_item.dart';

class PublicationsPage extends StatefulWidget {
  const PublicationsPage({super.key});

  @override
  State<PublicationsPage> createState() => _PublicationsPageState();
}

class _PublicationsPageState extends State<PublicationsPage> {
  bool isEditing = false; // modo de edição
  int? editingIndex; // qual post está sendo editado
  late TextEditingController _subtitleController;

  final List<Map<String, dynamic>> publications = [
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
  void initState() {
    super.initState();
    _subtitleController = TextEditingController();
  }

  @override
  void dispose() {
    _subtitleController.dispose();
    super.dispose();
  }

  void startEditing(int index) {
    setState(() {
      editingIndex = index;
      _subtitleController.text = publications[index]["subtitle"];
    });
  }

  void saveEditing() {
    if (editingIndex != null) {
      setState(() {
        publications[editingIndex!]["subtitle"] = _subtitleController.text;
        editingIndex = null;
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Alterações salvas com sucesso!"),
          backgroundColor: ConstantsColors.blueShade900,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() => isEditing = false);
    }
  }

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
              isEditing ? Icons.check : Icons.edit,
              color: ConstantsColors.blueShade900,
            ),
            onPressed: () {
              if (isEditing) {
                saveEditing();
              } else {
                setState(() => isEditing = true);
              }
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
          final isThisBeingEdited = isEditing && editingIndex == index;

          return GestureDetector(
            onTap: isEditing ? () => startEditing(index) : null,
            child: Stack(
              children: [
                CardItem(
                  title: pub["title"]!,
                  subtitle: isThisBeingEdited
                      ? null 
                      : pub["subtitle"],
                  avatarUrl: pub["avatarUrl"]!,
                  location: pub["location"]!,
                  date: pub["date"]!,
                  imageAsset: pub["imageAsset"]!,
                ),

                if (isThisBeingEdited)
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      color: Colors.white.withOpacity(0.9),
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _subtitleController,
                        maxLines: 2,
                        style: TextStylesConstants.kpoppinsRegular.merge(
                          const TextStyle(
                            color: ConstantsColors.blueShade900,
                            fontSize: 15,
                          ),
                        ),
                        decoration: InputDecoration(
                          hintText: "Editar subtítulo...",
                          filled: true,
                          fillColor: ConstantsColors.greyShade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: ConstantsColors.blueShade900,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ConstantsColors.blueShade900,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
