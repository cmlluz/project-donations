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

class CampaignEditPage extends StatefulWidget {
  final String campaignId;

  const CampaignEditPage({
    super.key,
    required this.campaignId,
  });

  @override
  State<CampaignEditPage> createState() => _CampaignEditPageState();
}

class _CampaignEditPageState extends State<CampaignEditPage> {
  File? _selectedImg;
  bool _isLoading = false;
  bool _isInitialized = false;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _currentImageUrl;

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

  @override
  void initState() {
    super.initState();
    _loadCampaignData();
  }

  Future<void> _loadCampaignData() async {
    final campaignController = context.read<CampaignController>();
    await campaignController.loadCampaignById(widget.campaignId);

    final campaign = campaignController.selectedCampaign;
    if (campaign != null) {
      setState(() {
        _titleController.text = campaign.titulo;
        _descController.text = campaign.descricao;
        _locationController.text = campaign.localizacao;
        _currentImageUrl = campaign.urlImagem;

        if (campaign.dataInicial != null) {
          _startDate = campaign.dataInicial;
          _startDateController.text =
              DateFormat('dd/MM/yyyy').format(campaign.dataInicial!);
        }

        if (campaign.dataFinal != null) {
          _endDate = campaign.dataFinal;
          _endDateController.text =
              DateFormat('dd/MM/yyyy').format(campaign.dataFinal!);
        }

        _isInitialized = true;
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

  Future<void> _saveChanges() async {
    // Validações básicas
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

    // Validação de datas
    if (_startDate != null && _endDate != null) {
      if (_endDate!.isBefore(_startDate!)) {
        _showError('A data final não pode ser anterior à data inicial');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl = _currentImageUrl;

      // Upload da nova imagem se foi selecionada
      if (_selectedImg != null) {
        final storageService = StorageService();
        final uploadedUrl =
            await storageService.uploadImage(_selectedImg!, 'campaign_images');
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      // Prepara os dados da campanha
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

      // Atualiza a campanha
      final success = await context
          .read<CampaignController>()
          .updateCampaign(widget.campaignId, campaignData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alterações salvas com sucesso!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: ConstantsColors.blueShade900,
          ),
        );
        GoRouter.of(context).pop();
      } else {
        final errorMessage = context.read<CampaignController>().errorMessage;
        _showError(errorMessage.isNotEmpty
            ? errorMessage
            : 'Erro ao salvar alterações');
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

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.image_outlined,
          size: 60,
          color: ConstantsColors.blueShade900,
        ),
        const SizedBox(height: 10),
        const Text(
          'Envie a imagem aqui',
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
    );
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
        child: !_isInitialized
            ? const Center(
                child: CircularProgressIndicator(
                  color: ConstantsColors.blueShade900,
                ),
              )
            : SingleChildScrollView(
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
                              : _currentImageUrl != null &&
                                      _currentImageUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: Image.network(
                                        _currentImageUrl!,
                                        width: 350,
                                        height: 160,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return _buildImagePlaceholder();
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color:
                                                  ConstantsColors.blueShade900,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : _buildImagePlaceholder(),
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
                    // Realizar uma possível checagem se já passou da data
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _selectStartDate,
                            child: AbsorbPointer(
                              child: CustomTextFields(
                                labelColor: ConstantsColors.whiteShade700,
                                controller: _startDateController,
                                secret: false,
                                icon: Icons.calendar_today,
                                keyboardType: TextInputType.datetime,
                                hintText: 'Data inicial',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: _selectEndDate,
                            child: AbsorbPointer(
                              child: CustomTextFields(
                                labelColor: ConstantsColors.whiteShade700,
                                controller: _endDateController,
                                secret: false,
                                icon: Icons.calendar_month,
                                keyboardType: TextInputType.datetime,
                                hintText: 'Data final',
                              ),
                            ),
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

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }
}
