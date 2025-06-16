import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final AuthService firebaseAuth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String errorMessage = '';
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await firebaseAuth.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (mounted) {
        GoRouter.of(context).go('/root');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Erro ao tentar fazer login';
      });
    } finally {
      setState(() {
        isLoading = false;
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
                ConstantsColors.tealShade200,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: formKey,
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
                      const SizedBox(height: 20),
                      if (errorMessage.isNotEmpty)
                        Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).go('/forgotPasswordPage');
                        },
                        child: Text(
                          'Esqueci minha senha',
                          style: TextStylesConstants.kformularyText.copyWith(
                            color: ConstantsColors.blueShade900,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.end,
                        ),
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
                                color: ConstantsColors.blueShade900,
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
                            backgroundColor: ConstantsColors.blueShade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: isLoading ? null : signIn,
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
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
                      const Expanded(
                        child: Divider(
                          color: ConstantsColors.greyShade600,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'ou',
                          style: TextStylesConstants.kformularyText.copyWith(
                            color: ConstantsColors.greyShade600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: ConstantsColors.greyShade600,
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
                          onPressed: () async {
                            try {
                              await firebaseAuth.loginWithGoogle();
                              if (mounted) {
                                GoRouter.of(context).go('/root');
                              }
                            } catch (e) {
                              setState(() {
                                errorMessage =
                                    'Erro ao entrar com Google: ${e.toString()}';
                              });
                            }
                          },
                          style: const AuthButtonStyle(
                            buttonType: AuthButtonType.icon,
                          ),
                        ),
                      ),
                      /*  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FacebookAuthButton(
                          onPressed: () {},
                          style: const AuthButtonStyle(
                            buttonType: AuthButtonType.icon,
                          ),
                        ), --> ainda n fiz
                      ), */
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
