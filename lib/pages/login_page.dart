import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:appdonationsgestor/controllers/favorite_controller.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/utils/firebase_error_translator.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:appdonationsgestor/controllers/user_provider.dart';

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

  Future<void> _refreshFavorites() async {
    final favoriteController = context.read<FavoriteController>();
    favoriteController.clearFavorites();
    await favoriteController.loadFavorites();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  // LOGIN EMAIL/SENHA
  Future<void> signIn() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      showSlowMessage = false;
    });

    // MENSAGEM DE DEMORA
    Future.delayed(
      const Duration(seconds: 5),
      () {
        if (mounted && isLoading) {
          setState(() {
            showSlowMessage = true;
          });
        }
      },
    );

    try {
      await firebaseAuth.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // CARREGA DADOS DO USUÁRIO
      await context.read<UserProvider>().fetchCurrentUser();
      await _refreshFavorites();

      if (mounted) {
        GoRouter.of(context).go('/root');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Senha incorreta.';
          break;

        case 'user-not-found':
          message = 'O email inserido não existe.';
          break;

        case 'invalid-email':
          message = 'Email inválido.';
          break;

        case 'too-many-requests':
          message = 'Muitas tentativas. Tente novamente mais tarde.';
          break;

        default:
          message = FirebaseErrorTranslator.translate(
            e.code,
          );

          if (message.isEmpty) {
            message = e.message ?? 'Erro ao fazer login.';
          }
      }

      setState(() {
        errorMessage = message;
      });
    } catch (e) {
      if (!mounted) return;

      // Verifica se é erro de conexão ou outro erro durante o carregamento de dados
      String errorMsg = FirebaseErrorTranslator.translateException(e);
      if (errorMsg.isEmpty) {
        errorMsg = 'Erro de conexão. Verifique sua internet e tente novamente.';
      }

      setState(() {
        errorMessage = errorMsg;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          showSlowMessage = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await firebaseAuth.loginWithGoogle(context);

      if (mounted && result != null) {
        final bool isNewUser = result['isNewUser'] as bool;

        if (isNewUser) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Bem-vindo! Conta criada automaticamente com o Google.'),
              backgroundColor: ConstantsColors.blueShade900,
            ),
          );
        }

        await context.read<UserProvider>().fetchCurrentUser();
        await _refreshFavorites();

        if (mounted) {
          GoRouter.of(context).push('/root');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          final translatedMessage = FirebaseErrorTranslator.translate(e.code);
          errorMessage =
              'Erro ao entrar com Google: ${translatedMessage.isEmpty ? (e.message ?? 'Erro desconhecido') : translatedMessage}';
        });
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = FirebaseErrorTranslator.translateException(e);
        if (errorMsg.isEmpty) {
          errorMsg =
              'Erro de conexão. Verifique sua internet e tente novamente.';
        }

        setState(() {
          errorMessage = 'Erro ao entrar com Google: $errorMsg';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
                    const SizedBox(
                      height: 40,
                    ),

                    // LOGO
                    Image.asset(
                      'assets/LogoName.png',
                      width: 180,
                      height: 180,
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    // EMAIL
                    CustomTextFields(
                      icon: Icons.email,
                      label: 'Email',
                      labelColor: ConstantsColors.whiteShade700,
                      secret: false,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // SENHA
                    CustomTextFields(
                      icon: Icons.lock,
                      label: 'Senha',
                      labelColor: ConstantsColors.whiteShade700,
                      secret: true,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    // ERRO
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // ESQUECI SENHA
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          GoRouter.of(context).push(
                            '/forgotPasswordPage',
                          );
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

                    const SizedBox(
                      height: 10,
                    ),

                    // BOTÃO LOGIN
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstantsColors.blueShade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
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

                    // MENSAGEM DEMORA
                    if (showSlowMessage)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                        ),
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

                    const SizedBox(
                      height: 20,
                    ),

                    // DIVISOR
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ConstantsColors.blueShade900.withOpacity(
                                    0.0,
                                  ),
                                  ConstantsColors.blueShade900,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          child: Text(
                            'ou entrar com',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: ConstantsColors.blackShade700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ConstantsColors.blueShade900,
                                  ConstantsColors.blueShade900.withOpacity(
                                    0.0,
                                  ),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // GOOGLE LOGIN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          child: GoogleAuthButton(
                            // --- USA A NOVA FUNÇÃO ---
                            onPressed: isLoading ? null : _handleGoogleSignIn,
                            style: const AuthButtonStyle(
                              buttonType: AuthButtonType.icon,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // CADASTRO
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).push(
                          '/userTypePage',
                        );
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
