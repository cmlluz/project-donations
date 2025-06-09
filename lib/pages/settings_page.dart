import 'package:appdonationsgestor/auth/app_data.dart';
import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  void logout() async {
    try {
      await authService.value.signOut();
      AppData.navBarCurrentIndexNotifier.value = 0;
      AppData.onboardingCurrentIndexNotifier.value = 0;
      if (context.mounted) {
        context.go('/');
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  void deleteAccount() async {
    try {
      await authService.value.deleteAccount(
          email: emailController.text, password: passwordController.text);
      AppData.navBarCurrentIndexNotifier.value = 0;
      AppData.onboardingCurrentIndexNotifier.value = 0;
      if (context.mounted) {
        context.go('/');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantsColors.whiteShade900,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 27),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ConstantsColors.blackShade900,
                      width: 1.0,
                    ),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // ir para a página de edição de perfil
                        },
                        style: TextButton.styleFrom(
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(
                          'Editar Perfil',
                          style: const TextStyle(
                            color: ConstantsColors.blackShade900,
                            fontSize: 16,
                          ).merge(TextStylesConstants.kpoppinsLight),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 27),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ConstantsColors.blackShade900,
                      width: 1.0,
                    ),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // ir para a página de edição de perfil
                        },
                        style: TextButton.styleFrom(
                          alignment: Alignment.centerLeft,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Para o row ter o tamanho do conteúdo
                          children: [
                            Text(
                              'Notificações',
                              style: const TextStyle(
                                color: ConstantsColors.blackShade900,
                                fontSize: 16,
                              ).merge(TextStylesConstants.kpoppinsLight),
                            ),
                            const SizedBox(
                                width: 12), // Espaço entre texto e ícone
                            const Icon(
                              Icons.message_outlined,
                              color: ConstantsColors.blackShade900,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 27),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ConstantsColors.blackShade900,
                      width: 1.0,
                    ),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: logout,
                        style: TextButton.styleFrom(
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(
                          'Sair da conta',
                          style: const TextStyle(
                            color: ConstantsColors.blackShade900,
                            fontSize: 16,
                          ).merge(TextStylesConstants.kpoppinsLight),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 27),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ConstantsColors.blackShade900,
                      width: 1.0,
                    ),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // ir para a página de edição de perfil
                        },
                        style: TextButton.styleFrom(
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(
                          'Deletar conta',
                          style: const TextStyle(
                            color: ConstantsColors.redShade800,
                            fontSize: 16,
                          ).merge(TextStylesConstants.kpoppinsLight),
                          textAlign: TextAlign.left,
                        ),
                      ),
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
