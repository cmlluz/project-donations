import 'dart:ui';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostCard extends StatelessWidget {
  final String imageUrl;
  final String label;

  const PostCard({
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
        elevation: 0,
        borderRadius: BorderRadius.circular(15.0),
        child: ClipRRect(
          child: Stack(
            children: [
              Image.asset(
                imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
