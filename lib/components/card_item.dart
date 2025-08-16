import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    this.onTap,
    required this.title,
    this.subtitle,
    required this.avatarUrl,
    required this.location,
    required this.date,
    required this.imageAsset,
  });

  final VoidCallback? onTap;
  final String title;
  final String? subtitle;
  final String avatarUrl;
  final String location;
  final String date;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 4), // deslocamento x e y
            blurRadius: 4, // desfoque
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Material(
          color: ConstantsColors.whiteShade900,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(avatarUrl),
                          ),
                          const SizedBox(width: 9),
                          Text(
                            title,
                            style: const TextStyle(
                              color: ConstantsColors.blueShade900,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ).merge(TextStylesConstants.kinterRegular),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/location_icon.png",
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$location, $date",
                            style: const TextStyle(
                              color: ConstantsColors.greyShade500,
                              fontSize: 10,
                            ).merge(TextStylesConstants.kinterRegular),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Subtitle com limite de 2 linhas e reticências
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 27.0, top: 15.0, bottom: 15.0, right: 13.0),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                        color: ConstantsColors.blueShade900,
                        fontSize: 14,
                      ).merge(TextStylesConstants.kpoppinsMedium),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                // Imagem principal
                Container(
                  height: 230.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    image: DecorationImage(
                      image: AssetImage(imageAsset),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
