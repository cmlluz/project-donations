import 'package:appdonationsgestor/pages/settings_pages/remove_account_page.dart';
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
    return Expanded(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configurações'),
          backgroundColor: ConstantsColors.whiteShade900,
          elevation: 0,
          iconTheme: const IconThemeData(color: ConstantsColors.blueShade900),
          titleTextStyle: TextStylesConstants.kinterSemiBold.merge(
            const TextStyle(
              color: ConstantsColors.blueShade900,
              fontSize: 24,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: ConstantsColors.whiteShade900,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 27),
              _buildSettingOption(
                title: 'Editar Perfil',
                onTap: () {
                  // TODO: Navegar para edição de perfil
                },
              ),
              const SizedBox(height: 27),
              _buildSettingOption(
                title: 'Notificações',
                icon: Icons.message_outlined,
                onTap: () {
                  // TODO: Navegar para notificações
                },
              ),
              const SizedBox(height: 27),
              _buildSettingOption(
                title: 'Sair da conta',
                onTap: () {
                  // TODO: Implementar logout
                },
              ),
              const SizedBox(height: 27),
              _buildSettingOption(
                title: 'Deletar conta',
                textColor: ConstantsColors.redShade800,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RemoveAccountPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    IconData? icon,
    Color textColor = ConstantsColors.blackShade900,
    required VoidCallback onTap,
  }) {
    return Container(
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
              onPressed: onTap,
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ).merge(TextStylesConstants.kpoppinsLight),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 12),
                    Icon(icon, color: textColor, size: 20),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
