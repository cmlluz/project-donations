import 'dart:io';
import 'package:appdonationsgestor/components/custom_button.dart';
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
      backgroundColor: ConstantsColors.blueShade900,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: ConstantsColors.blueShade900,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(50),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      GoRouter.of(context).go('/');
                    },
                    icon: const Icon(Icons.arrow_back,
                        color: ConstantsColors.whiteShade600),
                  ),
                  Text(
                    'Criar Publicação',
                    style: const TextStyle(
                      color: ConstantsColors.whiteShade600,
                      fontSize: 18,
                    ).merge(TextStylesConstants.kpoppinsBold),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: ConstantsColors.whiteShade900,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(35.0),
                ),
              ),
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
                        margin: const EdgeInsets.only(
                            top: 30, bottom: 30, left: 20, right: 20),
                        alignment: Alignment.center,
                        width: 400,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: ConstantsColors.greyShade300,
                            width: 2,
                          ),
                          image: _selectedImg == null
                              ? const DecorationImage(
                                  image: AssetImage('assets/tigre.webp'),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image:
                                      FileImage(_selectedImg!) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Descreva a postagem:",
                      style: const TextStyle(
                        fontSize: 16,
                        color: ConstantsColors.blueShade900,
                      ).merge(TextStylesConstants.kpoppinsBold),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      icon: Icons.description,
                      label: 'Legenda',
                      hintText: 'Escreva uma descrição para o post',
                      secret: false,
                      controller: _controller.crtlDesc,
                      keyboardType: TextInputType.text,
                      labelColor: ConstantsColors.greyShade200,
                    ),
                    const SizedBox(height: 20),
                    const CustomButton(
                      height: 45,
                      width: 180,
                      text: 'Publicar',
                      route: '/root',
                      color: ConstantsColors.blueShade900,
                      textColor: ConstantsColors.whiteShade900,
                      hasMensage: true,
                      mensage: 'Publicado com sucesso!',
                    ),
                    const SizedBox(height: 10),
                    const CustomButton(
                        text: 'Cancelar',
                        route: '/popupMenuState',
                        color: ConstantsColors.greyShade200,
                        textColor: ConstantsColors.blueShade900,
                        height: 45,
                        width: 180),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
