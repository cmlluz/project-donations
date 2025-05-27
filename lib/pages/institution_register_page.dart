import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class InstitutionRegisterPage extends StatefulWidget {
  const InstitutionRegisterPage({super.key});

  @override
  State<InstitutionRegisterPage> createState() => _InstitutionRegisterPage();
}

class _InstitutionRegisterPage extends State<InstitutionRegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
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
                  const SizedBox(height: 20),
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
                  CustomTextFields(
                    icon: Icons.apartment,
                    label: 'CNPJ',
                    secret: false,
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFields(
                    icon: Icons.phone,
                    label: 'Telefone',
                    secret: false,
                    controller: phoneController,
                    keyboardType: TextInputType.number,
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
                  ),
                  const SizedBox(height: 20),
                  CustomTextFields(
                    icon: Icons.lock,
                    label: 'Confirme a senha',
                    secret: true,
                    controller: confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantsColors.blueShade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      GoRouter.of(context).go('/institutionProfilePage');
                    },
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(
                        color: ConstantsColors.whiteShade900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantsColors.whiteShade900,
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
                        color: ConstantsColors.blueShade900,
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
    );
  }
}
