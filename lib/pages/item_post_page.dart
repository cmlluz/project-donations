import 'dart:io';
import 'package:appdonationsgestor/components/donation_item_component.dart';
import 'package:appdonationsgestor/components/image_picker_sheet.dart';
import 'package:appdonationsgestor/controllers/post_type_controller.dart';
import 'package:appdonationsgestor/controllers/product_registration_controller.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appdonationsgestor/services/api_services.dart';
import 'package:appdonationsgestor/services/storage_service.dart';

class ItemPostPage extends StatefulWidget {
  const ItemPostPage({super.key});

  @override
  State<ItemPostPage> createState() => _ItemPostPageState();
}

class _ItemPostPageState extends State<ItemPostPage> {
  final ProductRegistrationController _controller =
      ProductRegistrationController();
  final PostTypeController _controller1 = PostTypeController();
  final ApiService _apiService = ApiService();
  final StorageService _storageService =
      StorageService(); // Instancie o StorageService

  File? _selectedImg;
  bool _isLoading = false;

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

  void _submitPost() async {
    if (_controller.crtlItemName.text.isEmpty ||
        _controller.crtlDesc.text.isEmpty ||
        _selectedImg == null ||
        _controller.selectedValueCategory.value == null ||
        _controller.crtlQtd.text.isEmpty ||
        _controller1.selectedValueCategory.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Por favor, preencha todos os campos e selecione uma imagem.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? imageUrl = r'C:\Users\kkjun\DonationApp\assets\donations.jpg';
      if (_selectedImg != null) {
        imageUrl = await _storageService.uploadImage(_selectedImg!,
            'post_images'); // CORRIGIR DEPOIS, PELO EMULADOR NÃO GERA URL DE IMAGEM
      }

      final itemName = _controller.crtlItemName.text;
      final description = _controller.crtlDesc.text;
      final category = _controller.selectedValueCategory.value!;
      final quantity = int.tryParse(_controller.crtlQtd.text) ?? 0;
      final postType = _controller1.selectedValueCategory.value!;

      if (postType == 'Necessidade') {
        await _apiService.createNeed({
          'title': itemName,
          'description': description,
          'quantity': quantity,
          'category': category.toUpperCase(),
          'status': 'PENDENTE',
          'date': DateTime.now().toIso8601String().split('T').first,
          'imageUrl': imageUrl,
        });
        GoRouter.of(context).push('/feedback?text1=Necessidade');
      } else if (postType == 'Doação') {
        await _apiService.createDonation({
          'title': itemName,
          'description': description,
          'quantity': quantity,
          'category': category.toUpperCase(),
          'status': 'PENDENTE',
          'imageUrl': imageUrl, 
        });
        GoRouter.of(context).push('/feedback?text1=Doação');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao publicar: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/root');
          },
        ),
        title: Text(
          'Criar novo anúncio',
          style: TextStylesConstants.kformularyTitle,
        ),
        backgroundColor: ConstantsColors.blueShade900,
        foregroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: ConstantsColors.blueShade900,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                color: ConstantsColors.whiteShade700,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
              ),
              padding: const EdgeInsets.all(30.0),
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: DonationItemComponent(
                  productRegistrationController: _controller,
                  postTypeController: _controller1,
                  onPickImage: _showImagePickerOptions,
                  selectedImg: _selectedImg,
                  onSubmit: _submitPost,
                ),
              ),
            ),
    );
  }
}
