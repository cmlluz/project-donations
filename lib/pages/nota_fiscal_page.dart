import 'dart:io';

import 'package:appdonationsgestor/components/image_picker_sheet.dart';
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
  final TextEditingController customerNameController = TextEditingController();
  final List<File> _selectedImages = [];

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

  @override
  void dispose() {
    customerNameController.dispose();
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
                      controller: customerNameController,
                      keyboardType: TextInputType.text,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 25),
                    _buildRequiredLabel('Imagens da Nota Fiscal'),
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
                                Icons.image_search_outlined,
                                size: 50,
                                color: ConstantsColors.blueShade900,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Envie a imagem da nota aqui',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ConstantsColors.blueShade900
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Imagens enviadas:',
                      style: TextStyle(
                        fontSize: 16,
                        color: ConstantsColors.greyShade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_selectedImages.isNotEmpty)
                      ..._selectedImages.asMap().entries.map((entry) {
                        int index = entry.key;
                        File imageFile = entry.value;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  imageFile,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 15),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.redAccent),
                                onPressed: () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      })
                    else
                      Text(
                        'Nenhuma imagem enviada ainda.',
                        style: TextStylesConstants.kpoppinsRegular
                            .copyWith(color: Colors.grey),
                      ),
                    const SizedBox(height: 50),
                    CustomButton(
                      height: 50,
                      width: double.infinity,
                      text: 'Emitir Nota Fiscal',
                      color: ConstantsColors.blueShade900,
                      textColor: ConstantsColors.whiteShade900,
                      onPressed: () {
                        if (customerNameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('O título/descrição é obrigatório'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        if (_selectedImages.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'É obrigatório adicionar pelo menos uma imagem'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        if (mounted) {
                          GoRouter.of(context)
                              .push('/feedback?text1=Nota Fiscal');
                        }
                      },
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
