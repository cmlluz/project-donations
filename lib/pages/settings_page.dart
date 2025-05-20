import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 27),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ConstantsColors.black,
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
                        child: const Text(
                          'Editar Perfil',
                          style: TextStyle(
                              color: ConstantsColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
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
                      color: ConstantsColors.black,
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
                        child: const Row(
                          mainAxisSize: MainAxisSize
                              .min, // Para o row ter o tamanho do conteúdo
                          children: [
                            Text(
                              'Notificações',
                              style: TextStyle(
                                color: ConstantsColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 12), // Espaço entre texto e ícone
                            Icon(
                              Icons.message_outlined,
                              color: ConstantsColors.black,
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
                      color: ConstantsColors.black,
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
                        child: const Text(
                          'Sair da conta',
                          style: TextStyle(
                              color: ConstantsColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.left,
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
                      color: ConstantsColors.black,
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
                        child: const Text(
                          'Deletar conta',
                          style: TextStyle(
                              color: ConstantsColors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
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
