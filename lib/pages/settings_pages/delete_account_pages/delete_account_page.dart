import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;
  bool isGoogleUser = false;

  @override
  void initState() {
    super.initState();
    _checkProvider();
  }

  void _checkProvider() {
    final user = authService.value.currentUser;
    if (user != null) {
      final providers = user.providerData.map((e) => e.providerId).toList();
      if (providers.contains('google.com')) {
        setState(() {
          isGoogleUser = true;
        });
      }
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

Future<void> _validateEmailPassword(String email, String password) async {
  if (password.isEmpty) {
    setState(() {
      errorMessage = 'Digite sua senha.';
      isLoading = false;
    });
    return;
  }

  try {
    bool isPasswordCorrect = await authService.value.verifyPassword(email, password);

    if (!isPasswordCorrect) {
      setState(() {
        errorMessage = 'Senha incorreta. Tente novamente.';
        isLoading = false;
      });
      return;
    }

    _navigateToConfirmation(email, password);
  } catch (e) {
    setState(() {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
    });
  }
}

  Future<void> _validateGoogleAccount(User user) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut(); 
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          errorMessage = 'Validação com o Google cancelada.';
          isLoading = false;
        });
        return;
      }

      if (googleUser.email != user.email) {
        setState(() {
          errorMessage = 'A conta Google selecionada não corresponde à conta logada no app.';
          isLoading = false;
        });
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await user.reauthenticateWithCredential(credential);

      _navigateToConfirmation(user.email!, null);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
          errorMessage = 'Credenciais inválidas do Google.';
        } else {
          errorMessage = e.message ?? 'Falha na validação com o Google.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao conectar com o Google. Tente novamente.';
      });
    }
  }

  void _navigateToConfirmation(String email, String? password) {
    if (mounted) {
      GoRouter.of(context).pushNamed(
        'confirmDeletionPage',
        extra: {
          'email': email,
          'password': password,
        },
      );
    }
  }

  Future<void> continueToConfirmation() async {
    final user = authService.value.currentUser;
    final email = user?.email;

    if (user == null || email == null) {
      setState(() {
        errorMessage = 'Usuário não encontrado.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    if (isGoogleUser) {
      await _validateGoogleAccount(user);
    } else {
      await _validateEmailPassword(email, passwordController.text.trim());
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade900,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ConstantsColors.blueShade900,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Excluir conta',
          style: const TextStyle(
            color: ConstantsColors.blueShade900,
            fontSize: 24,
          ).merge(TextStylesConstants.kinterSemiBold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  isGoogleUser
                      ? "Para confirmar sua identidade, precisamos que você valide sua conta do Google."
                      : "Para confirmar sua identidade, por favor, insira a senha da sua conta.",
                  textAlign: TextAlign.center,
                  style: TextStylesConstants.kpoppinsMedium.merge(
                    const TextStyle(
                      fontSize: 16.0,
                      color: ConstantsColors.greyShade800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (!isGoogleUser) ...[
                CustomTextFields(
                  icon: Icons.lock,
                  label: 'Senha',
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  secret: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: ConstantsColors.blueShade900,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(220.0, 45.0),
                  backgroundColor: ConstantsColors.blueShade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: isLoading ? null : continueToConfirmation,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isGoogleUser) ...[
                            const Icon(Icons.g_mobiledata, color: Colors.white, size: 28),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            isGoogleUser ? 'Validar com Google' : 'Confirmar',
                            style: const TextStyle(
                              color: ConstantsColors.whiteShade900,
                              fontSize: 18,
                            ).merge(TextStylesConstants.kpoppinsSemiBold),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}