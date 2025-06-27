import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:go_router/go_router.dart';

class InstitutionRegisterPage extends StatefulWidget {
  const InstitutionRegisterPage({super.key});

  @override
  State<InstitutionRegisterPage> createState() => _InstitutionRegisterPage();
}

class _InstitutionRegisterPage extends State<InstitutionRegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfCnpjController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  void dispose() {
    nameController.dispose();
    cpfCnpjController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void registerUser() async {
    try {
      await authService.value.createAccount(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (mounted) {
        GoRouter.of(context).go('/finalizeRegistrationPage');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          errorMessage = 'A senha deve ter pelo menos 8 caracteres.';
        } else if (passwordController.text != confirmPasswordController.text) {
          errorMessage = 'As senhas não coincidem';
        } else if (e.code == 'email-already-in-use') {
          errorMessage =
              'Este e-mail já está em uso. Tente outro ou faça login.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'O formato do e-mail é inválido.';
        } else {
          errorMessage =
              e.message ?? 'Ocorreu um erro ao registrar. Tente novamente.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ConstantsColors.blueShade500,
                ConstantsColors.tealShade200
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      'Queremos saber mais sobre você!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ConstantsColors.blackShade700,
                        fontSize: 28,
                      ).merge(TextStylesConstants.kpoppinsBlack),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Informe alguns dados importantes para nós',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ConstantsColors.blackShade700,
                        fontSize: 18,
                      ).merge(TextStylesConstants.kpoppinsLight),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      icon: Icons.person,
                      label: 'Nome da instituição',
                      secret: false,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      icon: Icons.email,
                      label: 'Email',
                      secret: false,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      icon: Icons.apartment,
                      label: 'CNPJ',
                      secret: false,
                      controller: cpfCnpjController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      icon: Icons.phone,
                      label: 'Telefone',
                      secret: false,
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      icon: Icons.map,
                      label: 'Endereço',
                      secret: false,
                      controller: addressController,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      icon: Icons.lock,
                      label: 'Senha',
                      secret: true,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      icon: Icons.lock,
                      label: 'Confirme a senha',
                      secret: true,
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    if (errorMessage.isNotEmpty)
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    CustomButton(
                      text: 'Confirmar',
                      route: '/finalizeRegistrationPage',
                      color: ConstantsColors.blueShade900,
                      textColor: ConstantsColors.whiteShade900,
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          registerUser();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    const CustomButton(
                      text: 'Voltar',
                      route: '/userTypePage',
                      color: ConstantsColors.whiteShade900,
                      textColor: ConstantsColors.blueShade900,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
