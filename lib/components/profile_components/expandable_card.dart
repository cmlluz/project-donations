import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class ExpandableCard extends StatelessWidget {
  final String imageUrl;

  const ExpandableCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: ConstantsColors.greyShade200,
            child: const Center(
              child: CircularProgressIndicator(
                color: ConstantsColors.blueShade900,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: ConstantsColors.greyShade200,
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: ConstantsColors.greyShade200,
            child: const Icon(Icons.image, color: Colors.grey),
          );
        },
      );
    }
  }
}