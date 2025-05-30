import 'dart:ui'; // necessário para BackdropFilter
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final String label;

  const ImageCard({
    super.key,
    required this.imageUrl,
    this.label = 'Instituição',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/institutionProfilePage');
      },
      child: Material(
        elevation: 15,
        borderRadius: BorderRadius.circular(15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            children: [
              // Imagem de fundo
              Image.asset(
                imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image);
                },
              ),

              // Texto com background blur + drop shadow
              Positioned(
                bottom: 10,
                left: 5,
                right: 5,
                child: ClipRRect(
                  // necessário para aplicar o blur apenas ao container
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ConstantsColors.blueShade900.withOpacity(0.38),
                        boxShadow: [
                          BoxShadow(
                            color:
                                ConstantsColors.blueShade900.withOpacity(0.6),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Agasalhos",
                            style: TextStylesConstants.kpoppinsMedium.merge(
                              const TextStyle(
                                  fontSize: 13.0, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_pin,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "Barbalho, Salvador",
                                style:
                                    TextStylesConstants.kpoppinsRegular.merge(
                                  const TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
