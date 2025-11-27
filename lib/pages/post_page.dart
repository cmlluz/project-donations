import 'dart:io';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/image_picker_sheet.dart';
import 'package:appdonationsgestor/controllers/post_controller.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:dotted_border/dotted_border.dart';
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
  final PostController _controller = PostController();
  String mensagem = '';
  final TextEditingController _descController = TextEditingController();

  Widget _buildRequiredLabel(String text) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: ConstantsColors.greyShade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Text(
          ' *',
          style: TextStyle(
            fontSize: 15,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future pickImageFromGallery(ImageSource source) async {
    final selectedImage = await ImagePicker().pickImage(source: source);

    setState(() {
      if (selectedImage != null) {
        _selectedImg = File(selectedImage.path);
      }
    });
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImagePickerOptionsSheet(
          onCameraTap: () {
            pickImageFromGallery(ImageSource.camera);
            Navigator.of(context).pop();
          },
          onGalleryTap: () {
            pickImageFromGallery(ImageSource.gallery);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  bool _validateRequiredFields() {
    if (_selectedImg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma imagem para o post.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira uma descrição para o post.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> publicar() async {
    if (!_validateRequiredFields()) {
      return;
    }

    String authorUid = AuthService().currentUser?.uid ?? '';
    String token = await AuthService().currentUser?.getIdToken() ?? '';
    String imageUrl = _controller.crtlPic.text;
    String caption = _descController.text.trim();
    bool favorited = false;

    String resultado = await _controller.publicarPost(
      authorUid: authorUid,
      imageUrl: imageUrl,
      caption: caption,
      favorited: favorited,
      token: token,
    );
    setState(() {
      mensagem = resultado;
    });
  }

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
        title: Text(
          'Criar Publicação',
          style: TextStylesConstants.kformularyTitle,
        ),
        backgroundColor: ConstantsColors.blueShade900,
        foregroundColor: ConstantsColors.whiteShade700,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: ConstantsColors.whiteShade700,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildRequiredLabel('Imagem do Post'),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _showImagePickerOptions();
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(25.0),
                  color: ConstantsColors.blueShade900,
                  dashPattern: const [5, 5],
                  strokeWidth: 2,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(1, 91, 124, 0.05),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _selectedImg != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Image.file(
                                  _selectedImg!,
                                  width: 350,
                                  height: 220,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                children: [
                                  const Icon(
                                    Icons.image_search_outlined,
                                    size: 80,
                                    color: ConstantsColors.blueShade900,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Envie a foto aqui',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: ConstantsColors.greyShade600
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  const Text(
                                    'Procurar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ConstantsColors.blueShade900,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildRequiredLabel('Descrição'),
              ),
              const SizedBox(height: 10),
              Material(
                elevation: 2,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: ConstantsColors.whiteShade700,
                child: TextField(
                  controller: _descController,
                  maxLines: 3,
                  maxLength: 150,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelStyle: TextStyle(color: ConstantsColors.whiteShade700),
                    hintText: 'Escreva uma descrição para o post',
                    hintStyle: TextStyle(
                      color: ConstantsColors.greyShade600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        width: 1,
                        color:
                            ConstantsColors.blueShade900, // Cor da borda padrão
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        width: 1.5,
                        // Cor da borda quando o usuário clica no campo
                        color: ConstantsColors.blueShade900,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    height: 40,
                    width: 220,
                    text: 'Publicar',
                    color: ConstantsColors.blueShade900,
                    textColor: ConstantsColors.whiteShade700,
                    onPressed: () {
                      if (_validateRequiredFields()) {
                        // publicar();
                        GoRouter.of(context).push('/feedback?text1=Publicação');
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: const TextStyle(
                          color: ConstantsColors.greyShade600,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ).merge(TextStylesConstants.kpoppinsSemiBold),
                      ),
                    ),
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
