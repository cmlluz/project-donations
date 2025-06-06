import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';

class ProfileInfoComponent extends StatelessWidget {
  const ProfileInfoComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 3.0),
          child: Material(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  'assets/instituicao.png',
                  height: 160,
                  width: 170,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Align(
              child: Text(
                "Lar dos idosos",
                style: const TextStyle(
                  fontSize: 15,
                ).merge(TextStylesConstants.kpoppinsBold),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "Contato",
                style: const TextStyle(
                  fontSize: 12,
                ).merge(TextStylesConstants.kpoppinsBlack),
              ),
            ),
            const Row(
              children: [
                Icon(Icons.phone_in_talk_outlined),
                Opacity(
                    opacity: 0.7,
                    child: Text(
                      "(71)1234-5678",
                      style: TextStylesConstants.kpoppinsRegular,
                      textAlign: TextAlign.left,
                    ))
              ],
            ),
            const Row(
              children: [
                Icon(Icons.email_outlined),
                Opacity(
                    opacity: 0.7,
                    child: Text(
                      "@gmail.com",
                      style: TextStylesConstants.kpoppinsRegular,
                      textAlign: TextAlign.left,
                    ))
              ],
            ),
          ],
        )
      ],
    );
  }
}
