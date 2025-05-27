import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
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
                        onPressed: () {
                          // ir para a página de edição de perfil
                        },
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
