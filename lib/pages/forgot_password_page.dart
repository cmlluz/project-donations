import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/components/custom_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

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
                const CustomButton(
                  text: "Prosseguir",
                  route: '/forgotPasswordPage',
                  hasMensage: true,
                  mensage:
                      'Link de recuperação enviado para o e-mail informado.',
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
