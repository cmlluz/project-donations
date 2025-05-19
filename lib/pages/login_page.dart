import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
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
                Color.fromARGB(255, 92, 147, 166),
                Color.fromRGBO(175, 223, 216, 1),
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
                const SizedBox(height: 80),
                CustomTextFields(
                  icon: Icons.email,
                  label: 'Email',
                  secret: false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    CustomTextFields(
                      icon: Icons.lock,
                      label: 'Senha',
                      secret: true,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).go('/userTypePage');
                          },
                          child: const Text(
                            'Não tem uma conta? Crie uma!',
                            style: TextStyle(
                              color: ConstantsColors.labelColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstantsColors.labelColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          GoRouter.of(context).go('/root');
                        },
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade600,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'ou',
                        style: TextStylesConstants.kformularyText.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade600,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GoogleAuthButton(
                        onPressed: () {},
                        style: AuthButtonStyle(
                          buttonType: AuthButtonType.icon,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FacebookAuthButton(
                        onPressed: () {},
                        style: AuthButtonStyle(
                          buttonType: AuthButtonType.icon,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
