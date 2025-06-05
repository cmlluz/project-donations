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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/root');
          },
        ),
        title: const Text(
          'Criar Publicação',
          style: TextStylesConstants.kformularyTitle,
        ),
        backgroundColor: ConstantsColors.blueShade900,
        foregroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: ConstantsColors.whiteShade900,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  pickImageFromGallery();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
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
                            image: FileImage(_selectedImg!) as ImageProvider,
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    height: 50,
                    width: 150,
                    text: 'Publicar',
                    route: '/root',
                    color: ConstantsColors.blueShade900,
                    textColor: ConstantsColors.whiteShade900,
                    hasMensage: true,
                    mensage: 'Publicado com sucesso!',
                  ),
                  SizedBox(width: 20),
                  CustomButton(
                    height: 50,
                    width: 150,
                    text: 'Voltar',
                    route: '/root',
                    color: ConstantsColors.whiteShade900,
                    textColor: ConstantsColors.blueShade900,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
