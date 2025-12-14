import 'dart:io';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/image_picker_sheet.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/post_api_service.dart';
import 'package:appdonationsgestor/services/storage_service.dart';
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
  final TextEditingController _descController = TextEditingController();
  bool _isLoading = false;

  final PostApiService _postApiService = PostApiService(ApiClient());
  final StorageService _storageService = StorageService();

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

  Future pickImage(ImageSource source) async {
    final selectedImage = await ImagePicker().pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _selectedImg = File(selectedImage.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImagePickerOptionsSheet(
          onCameraTap: () {
            pickImage(ImageSource.camera);
            Navigator.of(context).pop();
          },
          onGalleryTap: () {
            pickImage(ImageSource.gallery);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> _submitPost() async {
    if (_selectedImg == null || _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Selecione uma imagem e escreva uma descrição.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imageUrl =
          await _storageService.uploadImage(_selectedImg!, 'posts');

      if (imageUrl == null) throw Exception("Falha no upload da imagem");

      final post = await _postApiService.createPost({
        'caption': _descController.text.trim(),
        'imageUrl': imageUrl,
        'favorited': false,
      });

      if (mounted) {
        String feedbackText = post.postStatus == 'DISPONIVEL'
            ? 'Publicação Criada!'
            : 'Publicação enviada para análise';

        GoRouter.of(context).push('/feedback?text1=$feedbackText');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao publicar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.blueShade900,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/root'),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildRequiredLabel('Imagem do Post'),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _showImagePickerOptions,
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
                      child: _selectedImg != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: Image.file(
                                _selectedImg!,
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_search_outlined,
                                  size: 80,
                                  color: ConstantsColors.blueShade900,
                                ),
                                SizedBox(height: 10),
                                Text('Envie a foto aqui'),
                                Text(
                                  'Procurar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ConstantsColors.blueShade900,
                                    decoration: TextDecoration.underline,
                                  ),
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
                TextField(
                  controller: _descController,
                  maxLines: 3,
                  maxLength: 150,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          CustomButton(
                            height: 40,
                            width: 220,
                            text: 'Publicar',
                            color: ConstantsColors.blueShade900,
                            textColor: ConstantsColors.whiteShade700,
                            onPressed: _submitPost,
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancelar',
                              style: TextStylesConstants.kpoppinsSemiBold
                                  .copyWith(color: Colors.grey),
                            ),
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
