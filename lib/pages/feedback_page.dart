import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class FeedbackPage extends StatefulWidget {
  final String text1;
  const FeedbackPage({super.key, required this.text1});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    final bool isAnalise = widget.text1.toLowerCase().contains("análise");
    String title =
        isAnalise ? widget.text1 : '${widget.text1} enviada com sucesso!';
    String subtitle = isAnalise
        ? 'Sua publicação foi enviada para nossos gestores e será revisada em breve.'
        : 'Você pode visualizar no seu perfil na aba "${widget.text1}"';

    return Scaffold(
      backgroundColor: ConstantsColors.blueShade900,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp,
              color: ConstantsColors.whiteShade700),
          onPressed: () {
            GoRouter.of(context).go('/root');
          },
        ),
        backgroundColor: ConstantsColors.blueShade900,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: ConstantsColors.whiteShade700,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/confirmed.png')),
            const SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: ConstantsColors.blueShade900)),
            const SizedBox(height: 20),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: ConstantsColors.greyShade600,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 100),
            CustomButton(
              text: 'Voltar ao início',
              width: 250,
              onPressed: () {
                GoRouter.of(context).go('/root');
              },
            ),
            const SizedBox(height: 10),
            if (!isAnalise)
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Criar nova ${widget.text1}',
                    style: const TextStyle(
                      color: ConstantsColors.greyShade600,
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
