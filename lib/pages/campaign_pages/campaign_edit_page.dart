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

class CampaignEditPage extends StatefulWidget {
  const CampaignEditPage({super.key});

  @override
  State<CampaignEditPage> createState() => _CampaignEditPageState();
}

class _CampaignEditPageState extends State<CampaignEditPage> {
  File? _selectedImg;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
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

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alterações salvas com sucesso!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ConstantsColors.blueShade900,
      ),
    );
    GoRouter.of(context).pop();
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
          'Editar Campanha',
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
              // Realizar uma possível checagem se já passou da data
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
                text: 'Salvar Alterações',
                color: ConstantsColors.blueShade900,
                textColor: ConstantsColors.whiteShade700,
                width: double.infinity,
                height: 45,
                onPressed: _saveChanges,
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
