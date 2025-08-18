import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class RegistrationConfirmedPage extends StatelessWidget {
  const RegistrationConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tudo Certo!',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: ConstantsColors.blueShade900)),
            const SizedBox(height: 20),
            const Image(image: AssetImage('assets/confirmed.png')),
            const SizedBox(height: 20),
            const Text(
              'Cadastro concluído',
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Poppins-SemiBold',
                  color: ConstantsColors.greyShade600),
              textAlign: TextAlign.center,
            ),
            const Text(
              'com sucesso!',
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Poppins-SemiBold',
                  color: ConstantsColors.greyShade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),
            CustomButton(
              text: 'Entrar',
              width: 190,
              onPressed: () {
                GoRouter.of(context).go('/root');
              },
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () => GoRouter.of(context).go('/'),
                child: Text(
                  'Voltar',
                  style: const TextStyle(
                    color: ConstantsColors.greyShade900,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ).merge(TextStylesConstants.kpoppinsSemiBold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
