import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:appdonationsgestor/controllers/edit_profile_controller.dart';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/controllers/user_provider.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileController(),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email é obrigatório';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value) ? null : 'Email inválido';
  }

  String? _validatePix(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length < 11 && !value.contains('@')) return 'Chave PIX inválida';
    return null;
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<EditProfileController>();
    final userProvider = context.read<UserProvider>();

    try {
      final newImageUrl = await controller.updateProfile();

      if (mounted) {
        userProvider.updateLocalUserData(
          name: controller.nameController.text,
          bio: controller.bioController.text,
          profilePictureUrl: newImageUrl,
        );

        await userProvider.fetchCurrentUser();

        _showSuccessMessage('Perfil atualizado com sucesso!');
        GoRouter.of(context).go('/root');
      }
    } catch (e) {
      _showErrorMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _showSuccessMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EditProfileController>();

    return Scaffold(
      backgroundColor: ConstantsColors.blueShade900,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/root'),
        ),
        title:
            Text('Editar Perfil', style: TextStylesConstants.kformularyTitle),
        backgroundColor: ConstantsColors.blueShade900,
        foregroundColor: ConstantsColors.whiteShade700,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: ConstantsColors.whiteShade700,
          borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
        ),
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildProfileImage(controller),
                      const SizedBox(height: 30),
                      _buildFormFields(controller),
                      const SizedBox(height: 20),
                      _buildActionButtons(controller),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProfileImage(EditProfileController controller) {
    return GestureDetector(
      onTap: () => controller.showImagePickerOptions(context),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: ConstantsColors.blueShade900,
        child: CircleAvatar(
          radius: 60,
          backgroundImage: controller.selectedImage != null
              ? FileImage(controller.selectedImage!)
              : controller.currentProfileImageUrl != null
                  ? NetworkImage(controller.currentProfileImageUrl!)
                  : null,
          child: controller.selectedImage == null &&
                  controller.currentProfileImageUrl == null
              ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
              : null,
        ),
      ),
    );
  }

  Widget _buildFormFields(EditProfileController controller) {
    return Column(
      children: [
        CustomTextFields(
          icon: Icons.person,
          label: 'Nome',
          controller: controller.nameController,
          validator: (value) =>
              value?.isEmpty == true ? 'Nome é obrigatório' : null,
        ),
        const SizedBox(height: 20),
        CustomTextFields(
          icon: Icons.email,
          label: 'Email',
          controller: controller.emailController,
          validator: _validateEmail,
        ),
        const SizedBox(height: 20),
        CustomTextFields(
          icon: Icons.phone,
          label: 'Telefone',
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TelefoneInputFormatter(),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Campo obrigatório';
            if (value.length < 14) return 'Telefone inválido';
            return null;
          },
          hintText: '(71) 99999-9999',
        ),
        const SizedBox(height: 20),
        CustomTextFields(
          icon: Icons.pix,
          label: 'Chave PIX',
          controller: controller.pixController,
          keyboardType: TextInputType.text,
          validator: _validatePix,
        ),
        const SizedBox(height: 20),
        _buildBioField(controller),
      ],
    );
  }

  Widget _buildBioField(EditProfileController controller) {
    return TextFormField(
      controller: controller.bioController,
      keyboardType: TextInputType.multiline,
      minLines: 4,
      maxLines: 6,
      maxLength: 500,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 70),
          child: Icon(Icons.info_outline, color: Colors.grey),
        ),
        labelText: 'Biografia',
        hintText: 'Conte um pouco sobre você...',
        alignLabelWithHint: true,
        filled: true,
        fillColor: ConstantsColors.whiteShade700,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ConstantsColors.blueShade900),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ConstantsColors.blueShade900),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ConstantsColors.blueShade900,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(EditProfileController controller) {
    return Column(
      children: [
        CustomButton(
          height: 50,
          width: 200,
          text: controller.isLoading ? 'Salvando...' : 'Confirmar',
          onPressed: controller.isLoading ? null : _onSave,
          color: ConstantsColors.blueShade900,
          textColor: ConstantsColors.whiteShade700,
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: controller.isLoading
              ? null
              : () => GoRouter.of(context).go('/root'),
          child: Text(
            'Cancelar',
            style: const TextStyle(
              color: ConstantsColors.blueShade900,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ).merge(TextStylesConstants.kpoppinsSemiBold),
          ),
        ),
      ],
    );
  }
}
