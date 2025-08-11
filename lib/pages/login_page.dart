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

  /*Future<void> signIn() async {
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
        GoRouter.of(context).push('/root');
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            color: ConstantsColors.whiteShade700,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Image.asset(
                      'assets/appLogo.png',
                      width: 100,
                      height: 100,
                    ),
                    const Text(
                      'Colab',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Jacques Francois',
                        color: ConstantsColors.blueShade900,
                      ),
                    ),
                    const Text("Salvador",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Jacques Francois',
                          color: ConstantsColors.blueShade900,
                        )),
                    const SizedBox(height: 40),
                    CustomTextFields(
                      icon: Icons.email,
                      label: 'Email',
                      labelColor: ConstantsColors.whiteShade700,
                      secret: false,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    CustomTextFields(
                      icon: Icons.lock,
                      label: 'Senha',
                      labelColor: ConstantsColors.whiteShade700,
                      secret: true,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    if (errorMessage.isNotEmpty)
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          GoRouter.of(context).push('/forgotPasswordPage');
                        },
                        child: Text(
                          'Esqueci minha senha',
                          style: TextStylesConstants.kformularyText.copyWith(
                            color: ConstantsColors.greyShade600,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstantsColors.blueShade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          GoRouter.of(context).push('/root');
                        },
                        /* 
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
                                'Entrar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                        */
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ConstantsColors.blueShade900.withOpacity(0.0),
                                  ConstantsColors.blueShade900,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('ou entrar com',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: ConstantsColors.blackShade700,
                              )),
                        ),
                        Expanded(
                          child: Container(
                            height: 2.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ConstantsColors.blueShade900,
                                  ConstantsColors.blueShade900.withOpacity(0.0),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
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
                                  GoRouter.of(context).push('/root');
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
                        /*Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: FacebookAuthButton(
                            onPressed: () async {
                              try {
                                await firebaseAuth.loginWithFacebook();
                                if (mounted) {
                                  GoRouter.of(context).push('/root');
                                }
                              } catch (e) {
                                setState(() {
                                  errorMessage =
                                      'Erro ao entrar com Facebook: ${e.toString()}';
                                });
                              }
                            },
                            style: const AuthButtonStyle(
                              buttonType: AuthButtonType.icon,
                            ),
                          ),
                        ),*/
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).push('/userTypePage');
                      },
                      child: const Text(
                        'Não tem conta? Crie uma!',
                        style: TextStyle(
                          color: ConstantsColors.blueShade900,
                          fontSize: 14,
                        ),
                      ),
                    ),
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
