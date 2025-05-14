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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
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
                ConstantsColors.CorPrinciapal,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.6, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                CustomTextFields(
                  icon: Icons.person,
                  label: 'Nome',
                  secret: false,
                ),
                const SizedBox(height: 20),
                CustomTextFields(
                  icon: Icons.email,
                  label: 'Email',
                  secret: false,
                ),
                const SizedBox(height: 20),
                CustomTextFields(
                  icon: Icons.lock,
                  label: 'Senha',
                  secret: true,
                ),
                const SizedBox(height: 20),
                CustomTextFields(
                  icon: Icons.lock,
                  label: 'Confirme sua Senha',
                  secret: true,
                ),
                CustomTextFields(
                  icon: Icons.phone,
                  label: 'Telefone',
                  secret: false,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para registrar o usuário
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstantsColors.CorPrinciapal.withValues(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    child: Text('Registrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
