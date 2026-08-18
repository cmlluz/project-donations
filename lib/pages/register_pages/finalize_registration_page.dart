import 'package:appdonationsgestor/controllers/user_provider.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/profile_services.dart';
import 'package:appdonationsgestor/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:go_router/go_router.dart';

class FinalizeRegistrationPage extends StatefulWidget {
   final Map<String, dynamic> userData;

  const FinalizeRegistrationPage({
    super.key,
    required this.userData,
  });

  @override
  State<FinalizeRegistrationPage> createState() =>
      _FinalizeRegistrationPageState();
}

class _FinalizeRegistrationPageState extends State<FinalizeRegistrationPage> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController pixKeyController = TextEditingController();

  final ProfileService _profileService = ProfileService();
  final StorageService _storageService = StorageService();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

Future<void> _updateProfile() async {
  setState(() => _isLoading = true);

  try {
    String? uploadedImageUrl;

    if (_image != null) {
      uploadedImageUrl = await _storageService.uploadImage(
        _image!,
        'profile_images',
      );
    }

    final Map<String, dynamic> userData = {
      ...widget.userData,
      "bio": bioController.text.trim(),
      "pixKey": pixKeyController.text.trim(),
    };

    if (uploadedImageUrl != null) {
      userData["profilePictureUrl"] = uploadedImageUrl;
    }

    if (userData.isNotEmpty) {
      await _profileService.updateUserProfileBackend(userData);
    }

    if (mounted) {
      await context.read<UserProvider>().fetchCurrentUser();
    }

    if (mounted) {
      context.go('/confirmedRegistration');
    }

  } catch (e, s) {
    print("ERRO: $e");
    print("STACK: $s");

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao finalizar cadastro: $e'),
          backgroundColor: Colors.red,
        ),
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
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            color: ConstantsColors.whiteShade700,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: ConstantsColors.blueShade900),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 73),
                      Container(
                        width: 140,
                        height: 5,
                        decoration: BoxDecoration(
                          color: ConstantsColors.blueShade900,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Passo 2 de 2',
                    style: TextStyle(
                      color: ConstantsColors.blackShade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Quase lá!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ConstantsColors.blueShade900,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      backgroundColor: ConstantsColors.blueShade900,
                      radius: 60,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.add_a_photo,
                              size: 50, color: ConstantsColors.whiteShade700)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Adicione uma foto de perfil',
                    style: TextStyle(
                      color: ConstantsColors.greyShade600,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFields(
                    icon: Icons.info,
                    controller: bioController,
                    label: 'Biografia',
                    secret: false,
                    keyboardType: TextInputType.text,
                    hintText: 'Conte-nos um pouco sobre você',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFields(
                    controller: pixKeyController,
                    icon: Icons.payment,
                    label: 'Chave PIX',
                    keyboardType: TextInputType.text,
                    secret: false,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Cadastrar',
                    onPressed: _isLoading ? null : _updateProfile,
                    color: ConstantsColors.blueShade900,
                    textColor: ConstantsColors.whiteShade900,
                    width: 190,
                    height: 35,
                  ),
                  const SizedBox(height: 10),
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
      ),
    );
  }
}
