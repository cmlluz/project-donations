import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/utils/firebase_error_translator.dart';
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
  bool showSlowMessage = false;

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
      showSlowMessage = false;
    });

    // Timer para mostrar mensagem se demorar mais de 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && isLoading) {
        setState(() {
          showSlowMessage = true;
        });
      }
    });

    try {
      await firebaseAuth.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        context: context,
      );
      if (mounted) {
        GoRouter.of(context).push('/root');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        final translatedMessage = FirebaseErrorTranslator.translate(e.code);
        errorMessage = translatedMessage.isEmpty
            ? (e.message ?? 'Erro desconhecido ao fazer login')
            : translatedMessage;
      });
    } catch (e) {
      setState(() {
        errorMessage = FirebaseErrorTranslator.translateException(e);
      });
    } finally {
      setState(() {
        isLoading = false;
        showSlowMessage = false;
      });
    }
  }

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
                      'assets/LogoName.png',
                      width: 180,
                      height: 180,
                    ),
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
                      ),
                    ),
                    if (showSlowMessage)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          'Isso está demorando mais do que o esperado...',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
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
                                await firebaseAuth.loginWithGoogle(context);
                                if (mounted) {
                                  GoRouter.of(context).push('/root');
                                }
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  final translatedMessage =
                                      FirebaseErrorTranslator.translate(e.code);
                                  errorMessage =
                                      'Erro ao entrar com Google: ${translatedMessage.isEmpty ? (e.message ?? 'Erro desconhecido') : translatedMessage}';
                                });
                              } catch (e) {
                                setState(() {
                                  errorMessage =
                                      'Erro ao entrar com Google: ${FirebaseErrorTranslator.translateException(e)}';
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
                                await firebaseAuth.loginWithFacebook(context);
                                if (mounted) {
                                  GoRouter.of(context).push('/root');
                                }
                              } catch (e) {
                                setState(() {
                                  errorMessage = 'Erro ao entrar com Facebook: ${FirebaseErrorTranslator.translateException(e)}';
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
