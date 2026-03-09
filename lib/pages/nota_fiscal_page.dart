import 'dart:io';
import 'package:appdonationsgestor/components/image_picker_sheet.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/nota_fiscal_api_service.dart';
import 'package:appdonationsgestor/services/storage_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class NotaFiscalPage extends StatefulWidget {
  const NotaFiscalPage({super.key});

  @override
  State<NotaFiscalPage> createState() => _NotaFiscalPageState();
}

class _NotaFiscalPageState extends State<NotaFiscalPage> {
  final TextEditingController titleController = TextEditingController();

  // Lista para suportar múltiplas imagens
  final List<File> _selectedImages = [];
  bool _isLoading = false;

  final NotaFiscalApiService _apiService = NotaFiscalApiService(ApiClient());
  final StorageService _storageService = StorageService();

  Widget _buildRequiredLabel(String text) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: ConstantsColors.blueShade900,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Text(
          ' *',
          style: TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showImagePickerOptions() {
    if (_selectedImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Máximo de 5 imagens permitido.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImagePickerOptionsSheet(
          onCameraTap: () {
            _pickImage(ImageSource.camera);
            Navigator.of(context).pop();
          },
          onGalleryTap: () {
            _pickImage(ImageSource.gallery);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage =
        await ImagePicker().pickImage(source: source, imageQuality: 80);

    if (pickedImage != null) {
      setState(() {
        _selectedImages.add(File(pickedImage.path));
      });
    }
  }

  Future<void> _submitNotaFiscal() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título/descrição é obrigatório')),
      );
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos uma imagem da nota')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      List<String> uploadedUrls = [];

      for (var imageFile in _selectedImages) {
        final url =
            await _storageService.uploadImage(imageFile, 'notas_fiscais');
        if (url != null) {
          uploadedUrls.add(url);
        } else {
          throw Exception("Falha no upload de uma das imagens");
        }
      }

      await _apiService.createNotaFiscal({
        'titulo': titleController.text.trim(),
        'imageUrls': uploadedUrls,
      });

      if (mounted) {
        GoRouter.of(context).push('/feedback?text1=Nota Fiscal');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar nota: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.blueShade900,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Criar Nota Fiscal',
          style: TextStylesConstants.kformularyTitle,
        ),
        backgroundColor: ConstantsColors.blueShade900,
        foregroundColor: ConstantsColors.whiteShade700,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: ConstantsColors.whiteShade700,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35.0)),
              ),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRequiredLabel('Título/Descrição'),
                    const SizedBox(height: 10),
                    CustomTextFields(
                      icon: Icons.description_outlined,
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 25),
                    _buildRequiredLabel('Imagens da Nota Fiscal (Max 5)'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(20.0),
                        color: ConstantsColors.blueShade900.withOpacity(0.5),
                        dashPattern: const [6, 6],
                        strokeWidth: 2,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(1, 91, 124, 0.05),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_a_photo_outlined,
                                size: 40,
                                color: ConstantsColors.blueShade900,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Toque para adicionar fotos',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ConstantsColors.blueShade900
                                      .withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_selectedImages.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: FileImage(_selectedImages[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImages.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close,
                                          size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 50),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            height: 50,
                            width: double.infinity,
                            text: 'Emitir Nota Fiscal',
                            color: ConstantsColors.blueShade900,
                            textColor: ConstantsColors.whiteShade900,
                            onPressed: _submitNotaFiscal,
                          ),
                    const SizedBox(height: 12),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
