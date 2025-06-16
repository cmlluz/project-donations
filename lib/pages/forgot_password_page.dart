import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/components/custom_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.email});

  final String email;
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    try {
      await authService.value.resetPassword(email: emailController.text);
      showSnackBar();
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'This is not working';
    }
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      content: const Text(
        'Por favor, verifique seu email.',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ));
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Recuperar Senha',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ConstantsColors.blackShade700,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Digite seu e-mail para receber um link de recuperação.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ConstantsColors.blackShade700,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFields(
                  icon: Icons.email,
                  label: 'Email',
                  secret: false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstantsColors.blueShade900,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: resetPassword,
                  child: const Text(
                    "Prosseguir",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const CustomButton(
                  text: "Voltar",
                  route: '/',
                  color: ConstantsColors.whiteShade900,
                  textColor: ConstantsColors.blueShade900,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
