import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  bool isNotificationOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
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
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: ConstantsColors.whiteShade900,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSettingOption(
              title: 'Editar Perfil',
              onTap: () {
                GoRouter.of(context).pushNamed('editProfilePage');
              },
            ),
            _buildSettingOption(
              title: 'Vincular a Conta',
              onTap: () {
                GoRouter.of(context).pushNamed('linkManagerPage');
              },
            ),
            _buildSettingOption(
              title: 'Notificações',
              icon: isNotificationOn
                  ? Icons.toggle_on
                  : Icons.toggle_off_outlined,
              iconColor: isNotificationOn
                  ? ConstantsColors.blueShade900
                  : ConstantsColors.blueShade900,
              iconSize: 36,
              alignment: MainAxisAlignment.spaceBetween,
              onTap: () {
                setState(() {
                  isNotificationOn = !isNotificationOn;
                });
              },
            ),
            _buildSettingOption(
              title: 'Deletar conta',
              // titleSize: 18,
              textColor: ConstantsColors.redShade800,
              onTap: () {
                GoRouter.of(context).pushNamed('deleteAccountPage');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    double titleSize = 16,
    IconData? icon,
    Color textColor = ConstantsColors.blackShade900,
    Color iconColor = ConstantsColors.blackShade900,
    double iconSize = 28,
    required VoidCallback onTap,
    MainAxisAlignment alignment = MainAxisAlignment.start,
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
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          Expanded(
            child: TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              child: Row(
                mainAxisAlignment: alignment,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: titleSize,
                    ).merge(TextStylesConstants.kpoppinsLight),
                  ),
                  Icon(
                    icon,
                    color: iconColor,
                    size: iconSize,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
