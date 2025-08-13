import 'dart:io';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
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

  Future pickImageFromGallery() async {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (selectedImage != null) {
        _selectedImg = File(selectedImage.path);
      }
    });
  }

  /*Future<void> publicar() async {
    String authorUid = authService.value.currentUser?.uid ?? '';
    String token = await authService.value.currentUser?.getIdToken() ?? '';
    String imageUrl = _controller.crtlPic.text;
    String caption = _controller.crtlDesc.text;
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
  } */

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
      body: SingleChildScrollView(
        child: Container(
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
                GestureDetector(
                  onTap: () {
                    pickImageFromGallery();
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(25.0),
                    color: ConstantsColors.blueShade900,
                    dashPattern: const [5, 5],
                    strokeWidth: 2,
                    child: Container(
                      alignment: Alignment.center,
                      width: 350,
                      height: 250,
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
                                    height: 250,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Column(
                                  children: [
                                    Icon(
                                      Icons.image_search_outlined,
                                      size: 80,
                                      color: ConstantsColors.blueShade900,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Clique para selecionar uma imagem',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: ConstantsColors.blueShade900,
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Descrição",
                    style: TextStyle(
                      fontSize: 15,
                      color: ConstantsColors.greyShade600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Material(
                  elevation: 2,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: ConstantsColors.whiteShade700,
                  child: TextField(
                    maxLines: 3,
                    maxLength: 150,
                    decoration: InputDecoration(
                      counterText: '',
                      labelStyle:
                          TextStyle(color: ConstantsColors.whiteShade700),
                      hintText: 'Escreva uma descrição para o post',
                      hintStyle: TextStyle(
                        color: ConstantsColors.greyShade600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 1,
                          color: ConstantsColors
                              .blueShade900, // Cor da borda padrão
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
                        // publicar();
                        // if (mensagem.isNotEmpty) {
                        GoRouter.of(context).push('/feedback?text1=Publicação');
                        // }
                      },
                    ),
                    const SizedBox(height: 10),
                    const CustomButton(
                      height: 40,
                      width: 220,
                      text: 'Cancelar',
                      route: '/root',
                      color: ConstantsColors.whiteShade700,
                      textColor: ConstantsColors.greyShade600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
