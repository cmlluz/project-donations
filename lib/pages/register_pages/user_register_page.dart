import "package:flutter/material.dart";
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';

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
                ConstantsColors.mainColor,
                ConstantsColors.navigationColor
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text(
                    'Queremos saber mais sobre você!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(190, 0, 0, 0),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Informe alguns dados importantes para nós',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(190, 0, 0, 0),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 80),
                  CustomTextFields(
                    icon: Icons.person,
                    label: 'Nome',
                    secret: false,
                  ),
                  SizedBox(height: 20),
                  CustomTextFields(
                    icon: Icons.email,
                    label: 'Email',
                    secret: false,
                  ),
                  SizedBox(height: 20),
                  CustomTextFields(
                    icon: Icons.phone,
                    label: 'Telefone',
                    secret: false,
                  ),
                  SizedBox(height: 20),
                  CustomTextFields(
                    icon: Icons.person_4,
                    label: 'CPF',
                    secret: false,
                  ),
                  SizedBox(height: 20),
                  CustomTextFields(
                    icon: Icons.map,
                    label: 'Endereço',
                    secret: false,
                  ),
                  SizedBox(height: 20),
                  CustomTextFields(
                    icon: Icons.lock,
                    label: 'Senha',
                    secret: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextFields(
                    icon: Icons.lock,
                    label: 'Confirme sua Senha',
                    secret: true,
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Confirmar',
                    route: '/finalizeRegistrationPage',
                    color: ConstantsColors.buttonColor,
                    textColor: ConstantsColors.white,
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Voltar',
                    route: '/userTypePage',
                    color: ConstantsColors.white,
                    textColor: ConstantsColors.labelColor,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
