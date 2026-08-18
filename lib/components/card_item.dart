import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class CardItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? avatarUrl;
  final String date;
  final String imageAsset;
  final VoidCallback? onTap;

  const CardItem({
    Key? key,
    required this.title,
    this.subtitle,
    this.avatarUrl,
    required this.date,
    required this.imageAsset,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget displayImage;
    if (imageAsset.startsWith('http')) {
      displayImage = Image.network(
        imageAsset,
        height: 200.0,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200.0,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(
                color: ConstantsColors.blueShade900,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          height: 200.0,
          color: Colors.grey[300],
          child: const Center(
              child: Icon(Icons.broken_image, color: Colors.grey, size: 40)),
        ),
      );
    } else {
      displayImage = Image.asset(
        imageAsset,
        height: 200.0,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 200.0,
          color: Colors.grey[300],
          child: const Icon(Icons.image, color: Colors.grey, size: 40),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (avatarUrl != null && avatarUrl!.isNotEmpty)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(avatarUrl!),
                    onBackgroundImageError: (_, __) {},
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStylesConstants.kpoppinsSemiBold.merge(
                      const TextStyle(
                        fontSize: 15,
                        color: ConstantsColors.blueShade900,
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (subtitle != null && subtitle!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, left: 4, right: 4),
                child: Text(
                  subtitle!,
                  style: TextStylesConstants.kpoppinsMedium.merge(
                    const TextStyle(
                      fontSize: 14,
                      color: ConstantsColors.blueShade900,
                      height: 1.4,
                    ),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: displayImage,
            ),
          ],
        ),
      ),
    );
  }
}
