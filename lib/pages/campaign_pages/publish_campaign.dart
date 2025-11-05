import 'dart:io';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/components/image_picker_sheet.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class PublishCampaignPage extends StatefulWidget {
  const PublishCampaignPage({super.key});

  @override
  State<PublishCampaignPage> createState() => _PublishCampaignPageState();
}

class _PublishCampaignPageState extends State<PublishCampaignPage> {
  File? _selectedImg;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _selectedImg = File(pickedImage.path);
      });
    }
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

  void _confirm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Campanha publicada com sucesso!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ConstantsColors.blueShade900,
      ),
    );
    GoRouter.of(context).go('/root');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text(
          'Divulgar Campanha',
          style: TextStylesConstants.kformularyTitle,
        ),
        backgroundColor: ConstantsColors.blueShade900,
        foregroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: ConstantsColors.blueShade900,
      body: Container(
        decoration: const BoxDecoration(
          color: ConstantsColors.whiteShade700,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        padding: const EdgeInsets.all(30.0),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(1, 91, 124, 0.05),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: _selectedImg != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Image.file(
                              _selectedImg!,
                              width: 350,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_outlined,
                                size: 60,
                                color: ConstantsColors.blueShade900,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Envie a imagem da nota aqui',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ConstantsColors.blueShade900,
                                ),
                              ),
                              const Text(
                                'Procurar',
                                style: TextStyle(
                                  fontSize: 14,
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
              const SizedBox(height: 25),
              CustomTextFields(
                labelColor: ConstantsColors.whiteShade700,
                controller: _titleController,
                secret: false,
                icon: Icons.title_outlined,
                keyboardType: TextInputType.text,
                hintText: 'Título',
              ),
              const SizedBox(height: 15),
              CustomTextFields(
                labelColor: ConstantsColors.whiteShade700,
                controller: _descController,
                secret: false,
                icon: Icons.description_outlined,
                keyboardType: TextInputType.multiline,
                hintText: 'Descrição',
              ),
              const SizedBox(height: 15),
              CustomTextFields(
                labelColor: ConstantsColors.whiteShade700,
                controller: _locationController,
                secret: false,
                icon: Icons.location_on_outlined,
                keyboardType: TextInputType.text,
                hintText: 'Localização',
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFields(
                      labelColor: ConstantsColors.whiteShade700,
                      controller: _startDateController,
                      secret: false,
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.datetime,
                      hintText: 'Data inicial',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CustomTextFields(
                      labelColor: ConstantsColors.whiteShade700,
                      controller: _endDateController,
                      secret: false,
                      icon: Icons.calendar_month,
                      keyboardType: TextInputType.datetime,
                      hintText: 'Data final',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Confirmar',
                color: ConstantsColors.blueShade900,
                textColor: ConstantsColors.whiteShade700,
                width: double.infinity,
                height: 45,
                onPressed: _confirm,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => GoRouter.of(context).pop(),
                child: Text(
                  'Cancelar',
                  style: const TextStyle(
                    color: ConstantsColors.greyShade600,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ).merge(TextStylesConstants.kpoppinsSemiBold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
