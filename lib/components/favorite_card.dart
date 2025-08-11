import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:go_router/go_router.dart';

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

class FavoriteCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final VoidCallback onDelete;

  const FavoriteCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          GoRouter.of(context).push('/institutionProfilePage');
        },
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
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
