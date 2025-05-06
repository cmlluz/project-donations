import 'package:flutter/material.dart';

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
        const Column(
          children: [
            Align(
              child: Text(
                "Lar dos idosos",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "Contato",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Row(
              children: [
                Icon(Icons.phone_in_talk_outlined),
                Opacity(
                    opacity: 0.7,
                    child: Text(
                      "(71)1234-5678",
                      style: TextStyle(fontFamily: 'Poppins'),
                      textAlign: TextAlign.left,
                    ))
              ],
            ),
            Row(
              children: [
                Icon(Icons.email_outlined),
                Opacity(
                    opacity: 0.7,
                    child: Text(
                      "@gmail.com",
                      style: TextStyle(fontFamily: 'Poppins'),
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
