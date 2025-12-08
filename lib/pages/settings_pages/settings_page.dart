import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  bool isNotificationOn = false;
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = false;

  void _toggleNotifications(bool value) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (value) {
        await _notificationService.initNotifications();
        setState(() {
          isNotificationOn = true;
        });
      } else {
        await _notificationService.deleteToken();
        setState(() {
          isNotificationOn = false;
        });
      }
    } catch (e) {
      print("Erro ao alterar notificações: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Falha ao atualizar status de notificação.")));
      }
      setState(() {
        isNotificationOn = !value;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ConstantsColors.blackShade900,
                    width: 1.0,
                  ),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notificações',
                    style: TextStyle(
                      color: ConstantsColors.blackShade900,
                      fontSize: 16,
                    ).merge(TextStylesConstants.kpoppinsLight),
                  ),
                  _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Switch(
                          value: isNotificationOn,
                          onChanged: _toggleNotifications,
                          activeColor: ConstantsColors.blueShade900,
                        ),
                ],
              ),
            ),
            _buildSettingOption(
              title: 'Deletar conta',
              textColor: ConstantsColors.redShade800,
              onTap: () {
                GoRouter.of(context).pushNamed('deleteAccountPage');
              },
            ),
            const SizedBox(height: 40),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: ConstantsColors.blackShade900,
                    fontFamily: 'Poppins',
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Ajude-nos a melhorar! ',
                    ),
                    const TextSpan(
                      text: 'Compartilhe sua experiência respondendo ',
                    ),
                    TextSpan(
                      text: 'nossa breve pesquisa',
                      style: const TextStyle(
                        color: ConstantsColors.blueShade900,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          const String urlString =
                              'https://forms.gle/snivNUUfxobCHHSz9';
                          final Uri url = Uri.parse(urlString);

                          try {
                            bool canLaunch = await canLaunchUrl(url);

                            if (canLaunch) {
                              bool launched = await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );

                              if (!launched) {
                                launched = await launchUrl(
                                  url,
                                  mode: LaunchMode.platformDefault,
                                );
                              }

                              if (!launched && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Não foi possível abrir o formulário'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            } else {
                              try {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erro ao abrir link: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erro: $e'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            }
                          }
                        },
                    ),
                    const TextSpan(
                      text: '. Sua opinião é muito importante! 💙',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    double titleSize = 16,
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: titleSize,
                ).merge(TextStylesConstants.kpoppinsLight),
              ),
              Icon(Icons.chevron_right, color: textColor.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }
}
