import "package:flutter/material.dart";
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

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
                  const CustomTextFields(
                    icon: Icons.person,
                    label: 'Nome',
                    secret: false,
                  ),
                  const SizedBox(height: 20),
                  const CustomTextFields(
                    icon: Icons.email,
                    label: 'Email',
                    secret: false,
                  ),
                  const SizedBox(height: 20),
                  const CustomTextFields(
                    icon: Icons.phone,
                    label: 'Telefone',
                    secret: false,
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
                  const CustomTextFields(
                    icon: Icons.lock,
                    label: 'Senha',
                    secret: true,
                  ),
                  const SizedBox(height: 20),
                  const CustomTextFields(
                    icon: Icons.lock,
                    label: 'Confirme sua Senha',
                    secret: true,
                  ),
                  const SizedBox(height: 20),
                  const CustomButton(
                    text: 'Confirmar',
                    route: '/finalizeRegistrationPage',
                    color: ConstantsColors.blueShade900,
                    textColor: ConstantsColors.whiteShade900,
                  ),
                  const SizedBox(height: 20),
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
    );
  }
}
