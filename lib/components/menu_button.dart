import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ConstantsColors.whiteShade700,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: ConstantsColors.blueShade900,
                width: 1,
              ),
            ),
            child: Icon(icon, size: 40, color: ConstantsColors.blueShade900),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                    fontSize: 12, color: ConstantsColors.blueShade900)
                .merge(TextStylesConstants.kinterRegular),
          ),
        ],
      ),
    );
  }
}
