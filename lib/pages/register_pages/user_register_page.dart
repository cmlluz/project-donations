import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:appdonationsgestor/utils/firebase_error_translator.dart';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:go_router/go_router.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPage();
}

class _UserRegisterPage extends State<UserRegisterPage> {
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
  bool _isLoading = false;

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
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'As senhas não coincidem';
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userData = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "address": addressController.text.trim(),
        "cpfOrCnpj": cpfCnpjController.text.trim(),
        "role": "ROLE_USER",
      };

      await authService.value.createAccount(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        context: context,
        userData: userData,
      );

      if (mounted) {
        GoRouter.of(context).push('/finalizeRegistrationPage');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        final translatedMessage = FirebaseErrorTranslator.translate(e.code);
        errorMessage = translatedMessage.isEmpty
            ? (e.message ?? 'Ocorreu um erro ao registrar. Tente novamente.')
            : translatedMessage;
      });
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
          decoration: const BoxDecoration(color: ConstantsColors.whiteShade700),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
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
                        const SizedBox(width: 75),
                        Container(
                          width: 70,
                          height: 5,
                          decoration: BoxDecoration(
                            color: ConstantsColors.blueShade900,
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        Container(
                          width: 70,
                          height: 5,
                          decoration: BoxDecoration(
                            color: ConstantsColors.greyShade300,
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Passo 1 de 2',
                      style: TextStyle(
                        color: ConstantsColors.blackShade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Criar conta',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ConstantsColors.blueShade900,
                        fontSize: 30,
                      ).merge(TextStylesConstants.kpoppinsBlack),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Informe alguns dados importantes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ConstantsColors.blackShade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomTextFields(
                      icon: Icons.person,
                      label: 'Nome',
                      secret: false,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 15),
                    CustomTextFields(
                      icon: Icons.person_4,
                      label: 'CPF',
                      secret: false,
                      controller: cpfCnpjController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    CustomTextFields(
                      icon: Icons.map,
                      label: 'Endereço',
                      secret: false,
                      controller: addressController,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 15),
                    CustomTextFields(
                      icon: Icons.lock,
                      label: 'Confirme sua Senha',
                      secret: true,
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 15),
                    if (errorMessage.isNotEmpty)
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    CustomButton(
                      text: 'Confirmar',
                      color: ConstantsColors.blueShade900,
                      textColor: ConstantsColors.whiteShade900,
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (formKey.currentState?.validate() ?? false) {
                                registerUser();
                              }
                            },
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
