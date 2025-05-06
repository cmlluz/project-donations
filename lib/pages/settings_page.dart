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
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // ir para a página de edição de perfil
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ConstantsColors.CorPrinciapal,
                        side: BorderSide(
                          color: ConstantsColors.CorPrinciapal,
                          width: 2.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Editar Perfil',
                        style: TextStyle(
                            color: ConstantsColors.CorPrinciapal, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // ir para a página de alteração de senha
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ConstantsColors.CorPrinciapal,
                        side: BorderSide(
                          color: ConstantsColors.CorPrinciapal,
                          width: 2.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Alterar Senha',
                        style: TextStyle(
                            color: ConstantsColors.CorPrinciapal, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Sair da conta
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(
                          color: Colors.red.shade700,
                          width: 2.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Sair da Conta',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
