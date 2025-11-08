import 'package:appdonationsgestor/pages/campaign_pages/campaign_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/models/post_model.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/popup.dart';
import 'package:appdonationsgestor/pages/item_edit_page.dart';

class CampaignDetailsPage extends StatefulWidget {
  final PostModel post;
  final String? currentUser;

  const CampaignDetailsPage({
    super.key,
    required this.post,
    this.currentUser,
  });

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final bool isAuthor = true; // TODO: substituir depois pela lógica real

    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade700,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    post.imageUrl,
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: ConstantsColors.blueShade900,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: ConstantsColors.whiteShade900,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Se for o autor: editar e excluir; senão: favoritar
                if (isAuthor)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: ConstantsColors.blueShade900,
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: ConstantsColors.whiteShade900,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CampaignEditPage(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          backgroundColor: Colors.red.shade700,
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: ConstantsColors.whiteShade900,
                            ),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Dialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 24),
                                  child: Popup(
                                    title: "Excluir campanha",
                                    subtitle:
                                        "Tem certeza de que deseja excluir esta campanha?",
                                    confirmText: "Excluir",
                                    cancelText: "Cancelar",
                                    confirmButtonColor: Colors.redAccent,
                                  ),
                                ),
                              );

                              if (confirmed == true) {
                                Navigator.of(context).pop(true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Campanha excluída com sucesso!",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: ConstantsColors.blackShade900,
                                      ).merge(
                                          TextStylesConstants.kinterRegular),
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor:
                                        ConstantsColors.blueShade400,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: isFavorite
                          ? ConstantsColors.blueShade900
                          : Colors.grey.withOpacity(0.5),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(post.institutionImageUrl),
                radius: 22,
              ),
              title: Text(
                post.institution,
                style: TextStylesConstants.kpoppinsSemiBold.merge(
                  const TextStyle(
                    color: ConstantsColors.blueShade900,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                post.title,
                style: const TextStyle(
                  fontSize: 20,
                  color: ConstantsColors.blueShade900,
                  fontWeight: FontWeight.bold,
                ).merge(TextStylesConstants.kpoppinsSemiBold),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                post.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: ConstantsColors.greyShade600,
                  height: 1.5,
                ).merge(TextStylesConstants.kpoppinsMedium),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: ConstantsColors.blueShade900, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    post.location,
                    style: const TextStyle(
                      fontSize: 14,
                      color: ConstantsColors.greyShade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined,
                    color: ConstantsColors.blueShade900, size: 18),
                const SizedBox(width: 6),
                Text(
                  '27/07/2025 a 27/08/2025', // substituir quando vier do backend
                  style: const TextStyle(
                    fontSize: 14,
                    color: ConstantsColors.greyShade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (!isAuthor)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstantsColors.blueShade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Interesse registrado! Contamos com a sua presença.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                        backgroundColor: ConstantsColors.blueShade400,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    "Quero Participar",
                    style: TextStylesConstants.kpoppinsMedium.merge(
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
