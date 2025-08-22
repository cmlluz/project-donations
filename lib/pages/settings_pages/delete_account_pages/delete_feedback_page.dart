import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class DeleteFeedbackPage extends StatelessWidget {
  const DeleteFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade700,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tudo certo",
                    style: const TextStyle(
                      fontSize: 32,
                      color: ConstantsColors.blueShade900,
                    ).merge(TextStylesConstants.kpoppinsBold),
                  ),
                  const SizedBox(height: 20),
                  Image.asset('assets/checkmark.png'),
                  const SizedBox(height: 20),
                  Text(
                    "Sua conta foi\ndeletada com\nSucesso!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      color: ConstantsColors.greyShade900,
                    ).merge(TextStylesConstants.kpoppinsLight),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: ConstantsColors.blueShade900,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
