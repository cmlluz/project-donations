import 'dart:io';
import 'package:appdonationsgestor/components/donation_item_component.dart';
import 'package:appdonationsgestor/components/image_picker_sheet.dart';
import 'package:appdonationsgestor/controllers/post_type_controller.dart';
import 'package:appdonationsgestor/controllers/product_registration_controller.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/donation_api_service.dart';
import 'package:appdonationsgestor/services/api_services/needs_api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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

  // 1. Declare os serviços, mas NÃO os inicialize aqui
  final ApiClient _apiClient = ApiClient();
  late final NeedApiService _needsApiService;
  late final DonationApiService _donationApiService;
  final StorageService _storageService = StorageService();

  File? _selectedImg;
  bool _isLoading = false;

  // 2. Inicialize os serviços dependentes no initState
  @override
  void initState() {
    super.initState();
    _needsApiService = NeedApiService(_apiClient);
    _donationApiService = DonationApiService(_apiClient);
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
      String? imageUrl;
      if (_selectedImg != null) {
        try {
          imageUrl =
              await _storageService.uploadImage(_selectedImg!, 'post_images');
        } catch (e) {
          print("Erro no upload da imagem: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erro ao fazer upload da imagem: $e. Usando imagem padrão.')),
          );
          imageUrl = 'assets/donations.jpg';
        }
      }

      final itemName = _controller.crtlItemName.text;
      final description = _controller.crtlDesc.text;
      final category = _controller.selectedValueCategory.value!;
      final quantity = int.tryParse(_controller.crtlQtd.text) ?? 0;
      final postType = _controller1.selectedValueCategory.value!;

      if (postType == 'Necessidade') {
        await _needsApiService.createNeed({
          'title': itemName,
          'description': description,
          'quantity': quantity,
          'category': category.toUpperCase(),
          'status': 'PENDENTE',
          'date': DateTime.now().toIso8601String().split('T').first,
          'imageUrl': imageUrl,
        });
        if (mounted) GoRouter.of(context).push('/feedback?text1=Necessidade');
      } else if (postType == 'Doação') {
        await _donationApiService.createDonation({
          'title': itemName,
          'description': description,
          'quantity': quantity,
          'category': category.toUpperCase(),
          'date': DateTime.now().toIso8601String().split('T').first,
          'status': 'PENDENTE',
          'imageUrl': imageUrl,
        });
        if (mounted) GoRouter.of(context).push('/feedback?text1=Doação');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao publicar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
