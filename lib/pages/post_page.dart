import 'dart:io';

import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/controllers/post_controller.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  File? _selectedImg;

  Future pickImageFromGallery() async {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (selectedImage != null) {
        _selectedImg = File(selectedImage.path);
      }
    });
  }

  final PostController _controller = PostController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/popupMenuState');
          },
        ),
        title: const Text(
          'Criar publicação',
          style: TextStylesConstants.kformularyTitle,
        ),
        backgroundColor: const Color.fromARGB(255, 3, 32, 106),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  pickImageFromGallery();
                },
                child: Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    image: _selectedImg == null
                        ? const DecorationImage(
                            image: AssetImage('assets/tigre.webp'),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: FileImage(_selectedImg!) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Descreva a postagem:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFields(
                  icon: Icons.description,
                  label: 'Descrição do post',
                  secret: false,
                  controller: _controller.crtlDesc,
                  keyboardType: TextInputType.text),
              const SizedBox(height: 20),
              Container(
                width: 200.0,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // confirmar a postagem
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstantsColors.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
