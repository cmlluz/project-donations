// import 'package:appdonationsgestor/pages/settings_pages/remove_account_page.dart';
// import 'package:appdonationsgestor/pages/settings_pages/edit_profile_page.dart';
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
  bool isNotificationOn = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                GoRouter.of(context).pushNamed('editProfilePage');
              },
            ),
            const SizedBox(height: 27),
            _buildSettingOption(
              title: 'Notificações',
              icon: isNotificationOn
                  ? Icons.toggle_on
                  : Icons.toggle_off_outlined,
              iconColor: isNotificationOn
                  ? ConstantsColors.blueShade900
                  : ConstantsColors.blueShade900,
              iconSize: 32,
              alignment: MainAxisAlignment.spaceBetween,
              onTap: () {
                setState(() {
                  isNotificationOn = !isNotificationOn;
                });
              },
            ),
            const SizedBox(height: 27),
            _buildSettingOption(
              title: 'Sair da conta',
              onTap: () {
                logout();
              },
            ),
            const SizedBox(height: 27),
            _buildSettingOption(
              title: 'Deletar conta',
              textColor: ConstantsColors.redShade800,
              onTap: () {
                GoRouter.of(context).pushNamed('removeAccountPage');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          Expanded(
            child: TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
              ),
              child: Row(
                mainAxisAlignment: alignment,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ).merge(TextStylesConstants.kpoppinsLight),
                  ),
                  Icon(
                    icon,
                    color: iconColor,
                    size: iconSize, // ← controla o tamanho do ícone
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
