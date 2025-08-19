import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:go_router/go_router.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPage();
}

class _NotificationsPage extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        centerTitle: true,
        backgroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        iconTheme: const IconThemeData(color: ConstantsColors.blueShade900),
        titleTextStyle: TextStylesConstants.kinterSemiBold.merge(
          const TextStyle(
            color: ConstantsColors.blueShade900,
            fontSize: 24,
          ).merge(TextStylesConstants.kpoppinsRegular),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: ConstantsColors.whiteShade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/notification_img.png",
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 40),
              Text(
                'Suas notificações são exibidas aqui',
                style: const TextStyle(
                  color: ConstantsColors.blueShade900,
                  fontSize: 20,
                ).merge(TextStylesConstants.kpoppinsBold),
              ),
              const SizedBox(height: 10),
              Text(
                'Não deixe passar nenhuma oportunidade de fazer o bem.',
                style: const TextStyle(
                  color: ConstantsColors.blueShade900,
                  fontSize: 17,
                ).merge(TextStylesConstants.kpoppinsRegular),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).pushNamed("settingsPage");
                },
                style: TextButton.styleFrom(
                  backgroundColor: ConstantsColors.blueShade900,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Ativar Notificações',
                  style: const TextStyle(
                    color: ConstantsColors.whiteShade900,
                    fontSize: 16,
                  ).merge(TextStylesConstants.kpoppinsMedium),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
