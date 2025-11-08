import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:go_router/go_router.dart';

class FavoriteCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final VoidCallback onDelete;
  final VoidCallback? onTap; 
  final bool isNetwork;

  const FavoriteCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.onDelete,
    this.onTap, 
    this.isNetwork = true,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;
    if (isNetwork && imageUrl.startsWith('http')) {
      backgroundImage = NetworkImage(imageUrl);
    } else {
      backgroundImage = AssetImage(imageUrl.isEmpty ? 'assets/placeholder.png' : imageUrl);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ConstantsColors.blueShade900,
              width: 1,
            ),
          ),
          width: 330,
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: backgroundImage,
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: null, 
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 14,
                              color: ConstantsColors.blueShade900,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: onDelete,
                          icon: const Icon(
                            Icons.delete,
                            color: ConstantsColors.redShade800,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                          fontSize: 12, color: ConstantsColors.blueShade900),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}