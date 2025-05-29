import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/pages/login_page.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPage();
}

class _UserRegisterPage extends State<UserRegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
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

    try {
      await authService.value.createAccount(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      GoRouter.of(context).go('/root');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Ocorreu um erro ao registrar';
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
                Color.fromARGB(255, 214, 212, 212),
                ConstantsColors.mainColor,
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
                    const SizedBox(height: 20),
                    const Text(
                      'Queremos saber mais sobre você!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(190, 0, 0, 0),
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Informe alguns dados importantes para nós',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(190, 0, 0, 0),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 80),
                    CustomTextFields(
                      icon: Icons.person,
                      label: 'Nome',
                      secret: false,
                      controller: nameController,
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
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      icon: Icons.phone,
                      label: 'Telefone',
                      secret: false,
                      controller: phoneNumberController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    const CustomTextFields(
                      icon: Icons.person_4,
                      label: 'CPF',
                      secret: false,
                    ),
                    const SizedBox(height: 20),
                    const CustomTextFields(
                      icon: Icons.map,
                      label: 'Endereço',
                      secret: false,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      icon: Icons.lock,
                      label: 'Senha',
                      secret: true,
                      controller: passwordController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      icon: Icons.lock,
                      label: 'Confirme sua Senha',
                      secret: true,
                      controller: confirmPasswordController,
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstantsColors.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          registerUser();
                        }
                      },
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        GoRouter.of(context).go('/');
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: ConstantsColors.mainColor,
                          fontSize: 18,
                        ),
                      ),
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
