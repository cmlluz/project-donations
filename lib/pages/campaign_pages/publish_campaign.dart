import 'dart:io';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/components/image_picker_sheet.dart';
import 'package:appdonationsgestor/controllers/campaign_controller.dart';
import 'package:appdonationsgestor/services/storage_service.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PublishCampaignPage extends StatefulWidget {
  const PublishCampaignPage({super.key});

  @override
  State<PublishCampaignPage> createState() => _PublishCampaignPageState();
}

class _PublishCampaignPageState extends State<PublishCampaignPage> {
  File? _selectedImg;
  bool _isLoading = false;
  DateTime? _startDate;
  DateTime? _endDate;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

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

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ??
          _startDate?.add(const Duration(days: 1)) ??
          DateTime.now().add(const Duration(days: 1)),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _confirm() async {
    if (_titleController.text.trim().isEmpty) {
      _showError('O título é obrigatório');
      return;
    }

    if (_descController.text.trim().isEmpty) {
      _showError('A descrição é obrigatória');
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      _showError('A localização é obrigatória');
      return;
    }

    if (_startDate == null) {
      _showError('A data inicial é obrigatória');
      return;
    }

    if (_endDate == null) {
      _showError('A data final é obrigatória');
      return;
    }

    if (_selectedImg == null) {
      _showError('A imagem da campanha é obrigatória');
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      _showError('A data final não pode ser anterior à data inicial');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;

      if (_selectedImg != null) {
        final storageService = StorageService();
        imageUrl =
            await storageService.uploadImage(_selectedImg!, 'campaign_images');
      }

      final campaignData = {
        'titulo': _titleController.text.trim(),
        'descricao': _descController.text.trim(),
        'localizacao': _locationController.text.trim(),
        'urlImagem': imageUrl ?? '',
        if (_startDate != null)
          'dataInicial': _startDate!.toIso8601String().split('T')[0],
        if (_endDate != null)
          'dataFinal': _endDate!.toIso8601String().split('T')[0],
      };

      final success =
          await context.read<CampaignController>().createCampaign(campaignData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Campanha publicada com sucesso!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: ConstantsColors.blueShade900,
          ),
        );
        GoRouter.of(context).go('/root');
      } else {
        final errorMessage = context.read<CampaignController>().errorMessage;
        _showError(errorMessage.isNotEmpty
            ? errorMessage
            : 'Erro ao publicar campanha');
      }
    } catch (e) {
      _showError('Erro inesperado: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
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
              Align(
                alignment: Alignment.centerLeft,
                child: _buildRequiredLabel('Imagem da Campanha'),
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
                                'Envie a imagem da campanha',
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
              Align(
                alignment: Alignment.centerLeft,
                child: _buildRequiredLabel('Título'),
              ),
              const SizedBox(height: 5),
              CustomTextFields(
                labelColor: ConstantsColors.whiteShade700,
                controller: _titleController,
                secret: false,
                icon: Icons.title_outlined,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildRequiredLabel('Descrição'),
              ),
              const SizedBox(height: 5),
              CustomTextFields(
                labelColor: ConstantsColors.whiteShade700,
                controller: _descController,
                secret: false,
                icon: Icons.description_outlined,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildRequiredLabel('Localização'),
              ),
              const SizedBox(height: 5),
              CustomTextFields(
                labelColor: ConstantsColors.whiteShade700,
                controller: _locationController,
                secret: false,
                icon: Icons.location_on_outlined,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRequiredLabel('Data Inicial'),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: _selectStartDate,
                          child: AbsorbPointer(
                            child: CustomTextFields(
                              labelColor: ConstantsColors.whiteShade700,
                              controller: _startDateController,
                              secret: false,
                              icon: Icons.calendar_today,
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRequiredLabel('Data Final'),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: _selectEndDate,
                          child: AbsorbPointer(
                            child: CustomTextFields(
                              labelColor: ConstantsColors.whiteShade700,
                              controller: _endDateController,
                              secret: false,
                              icon: Icons.calendar_month,
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ConstantsColors.blueShade900,
                        ),
                      ),
                    )
                  : CustomButton(
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
