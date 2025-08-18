import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/menu_button.dart';

class ImagePickerOptionsSheet extends StatelessWidget {
  // A classe recebe as funções a serem executadas
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const ImagePickerOptionsSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    // O conteúdo da sua função foi movido para cá
    return Container(
      decoration: const BoxDecoration(
        color: ConstantsColors.whiteShade700,
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MenuButton(
                icon: Icons.camera_alt,
                label: 'Abrir Câmera',
                // Agora ele chama a função que foi passada
                onTap: onCameraTap,
              ),
              MenuButton(
                icon: Icons.photo_library,
                label: 'Galeria',
                // Agora ele chama a função que foi passada
                onTap: onGalleryTap,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
