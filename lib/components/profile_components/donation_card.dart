import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class DonationCard extends StatelessWidget {
  final String titulo;
  final String local;
  final int? quantidade;
  final String imagem;
  final VoidCallback? onTap;

  const DonationCard({
    super.key,
    required this.titulo,
    required this.local,
    required this.quantidade,
    required this.imagem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: SizedBox(
            child: Stack(
              children: [
                _buildImage(),
                _buildOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Positioned.fill(
      child: Image.asset(
        imagem,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  'Imagem não encontrada',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverlay() {
    return Positioned(
      bottom: 10,
      left: 5,
      right: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: ConstantsColors.blueShade900,
              boxShadow: [
                BoxShadow(
                  color: ConstantsColors.blueShade900.withOpacity(0.6),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titulo,
                  style: TextStylesConstants.kpoppinsMedium.merge(
                    const TextStyle(
                      fontSize: 13.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "Qtd: $quantidade | $local",
                        style: TextStylesConstants.kpoppinsRegular.merge(
                          const TextStyle(
                            fontSize: 11.0,
                            color: Colors.white,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
