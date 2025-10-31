import 'package:flutter/material.dart';
import 'package:appdonationsgestor/models/post_model.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class CampaignDetailsPage extends StatefulWidget {
  final PostModel post;

  const CampaignDetailsPage({super.key, required this.post});

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

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
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: ConstantsColors.blueShade900,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: ConstantsColors.whiteShade900),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Botão de favoritar
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
                  '27/07/2025 a 27/08/2025', 
                  // importar do back
                  style: const TextStyle(
                    fontSize: 14,
                    color: ConstantsColors.greyShade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
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
                  // tem alguma ação pra fazer aqui? além de um "Contamos com a sua presença"

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text(
                  //       "Interesse registrado! A instituição entrará em contato.",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(fontSize: 15),
                  //     ),
                  //     backgroundColor: ConstantsColors.blueShade400,
                  //     behavior: SnackBarBehavior.floating,
                  //   ),
                  // );
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
