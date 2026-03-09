import 'dart:ui';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? route;
  final VoidCallback? onTap;
  final bool isNetworkImage;
  final double? width;
  final double? height;
  final String? chavePix;
  final String? phoneNumber;
  final String? institutionEmail;
  final String? publicationDate;

  const ImageCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.route,
    this.onTap,
    this.isNetworkImage = false,
    this.width,
    this.height,
    this.chavePix,
    this.phoneNumber,
    this.institutionEmail,
    this.publicationDate,
  });

  // Factory constructors for different use cases
  factory ImageCard.donation({
    required String imageUrl,
    required String title,
    required String location,
    required String donationId,
    bool isNetworkImage = false,
  }) {
    return ImageCard(
      imageUrl: imageUrl,
      title: title,
      route: '/donation/$donationId',
      isNetworkImage: isNetworkImage,
    );
  }

  factory ImageCard.institution({
    required String imageUrl,
    required String name,
    required String phoneNumber,
    required String chavePix,
    required String institutionEmail,
    required String institutionId,
    bool isNetworkImage = false,
  }) {
    return ImageCard(
      imageUrl: imageUrl,
      title: name,
      chavePix: chavePix,
      phoneNumber: phoneNumber,
      institutionEmail: institutionEmail,
      route: '/institution/$institutionId',
      isNetworkImage: isNetworkImage,
    );
  }

  factory ImageCard.need({
    required String imageUrl,
    required String description,
    required String publicationDate,
    required String needId,
    bool isNetworkImage = false,
  }) {
    return ImageCard(
      imageUrl: imageUrl,
      title: description,
      publicationDate: publicationDate,
      route: '/need/$needId',
      isNetworkImage: isNetworkImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Material(
        elevation: 15,
        borderRadius: BorderRadius.circular(15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: SizedBox(
            width: width,
            height: height,
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
      child: isNetworkImage
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(
                    color: ConstantsColors.blueShade900,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorWidget();
              },
            )
          : Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorWidget();
              },
            ),
    );
  }

  Widget _buildErrorWidget() {
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
              color: ConstantsColors.blueShade900.withOpacity(0.38),
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
                  title,
                  style: TextStylesConstants.kpoppinsMedium.merge(
                    const TextStyle(
                      fontSize: 13.0,
                      color: Colors.white,
                    ),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
    } else if (route != null && route!.isNotEmpty) {
      GoRouter.of(context).push(route!);
    }
  }
}
