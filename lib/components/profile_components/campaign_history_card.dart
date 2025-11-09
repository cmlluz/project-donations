import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:intl/intl.dart';

class CampaignHistoryCard extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String local;
  final String? imagem;
  final DateTime? dataInicial;
  final DateTime? dataFinal;
  final VoidCallback onTap;

  const CampaignHistoryCard({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.local,
    this.imagem,
    this.dataInicial,
    this.dataFinal,
    required this.onTap,
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
      child: imagem != null && imagem!.isNotEmpty
          ? Image.network(
              imagem!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: ConstantsColors.greyShade200,
                  child: const Icon(
                    Icons.campaign,
                    size: 40,
                    color: ConstantsColors.blueShade900,
                  ),
                );
              },
            )
          : Container(
              color: ConstantsColors.greyShade200,
              child: const Icon(
                Icons.campaign,
                size: 40,
                color: ConstantsColors.blueShade900,
              ),
            ),
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.3),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    titulo,
                    style: TextStylesConstants.kpoppinsMedium.merge(
                      const TextStyle(
                        color: ConstantsColors.whiteShade900,
                        fontSize: 14,
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: ConstantsColors.whiteShade900,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          local,
                          style: TextStylesConstants.kpoppinsRegular.merge(
                            const TextStyle(
                              color: ConstantsColors.whiteShade900,
                              fontSize: 10,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (dataInicial != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: ConstantsColors.whiteShade900,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _formatDateRange(),
                            style: TextStylesConstants.kpoppinsRegular.merge(
                              const TextStyle(
                                color: ConstantsColors.whiteShade900,
                                fontSize: 10,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateRange() {
    if (dataInicial == null) return '';

    final formatter = DateFormat('dd/MM/yy');
    final inicialStr = formatter.format(dataInicial!);

    if (dataFinal != null) {
      final finalStr = formatter.format(dataFinal!);
      return '$inicialStr - $finalStr';
    }

    return 'Desde $inicialStr';
  }
}
