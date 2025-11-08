import 'package:flutter/material.dart';

class ExpandableCard extends StatelessWidget {
  final String imageUrl;

  const ExpandableCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
