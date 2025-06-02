import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';

class ManagerProfilePage extends StatefulWidget {
  const ManagerProfilePage({Key? key}) : super(key: key);

  @override
  State<ManagerProfilePage> createState() => _ManagerProfilePage();
}

class _ManagerProfilePage extends State<ManagerProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantsColors.whiteShade900,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ConstantsColors.blueShade900,
                    width: 4.0,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                    "https://media.gettyimages.com/id/1317804578/pt/foto/one-businesswoman-headshot-smiling-at-the-camera.jpg?s=612x612&w=0&k=20&c=RXbgBRAoPeDrPXNLXI74Th6Lexbk6PRQ6q0b4rIzEcc=",
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      'Lucia Fontes ',
                      style: TextStylesConstants.kinterSemiBold
                          .merge(const TextStyle(fontSize: 20.0)),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Contato: ',
                      style: TextStylesConstants.kinterBold
                          .merge(const TextStyle(fontSize: 15.0)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone_in_talk_outlined,
                            size: 20.0, color: ConstantsColors.blackShade700),
                        const SizedBox(width: 6),
                        Text(
                          '(71)12345-6789',
                          style: TextStylesConstants.kinterRegular
                              .merge(const TextStyle(fontSize: 15.0)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined,
                            size: 20.0, color: ConstantsColors.blackShade700),
                        const SizedBox(width: 6),
                        Text(
                          'Luciafontes@gmail.com',
                          style: TextStylesConstants.kinterRegular
                              .merge(const TextStyle(fontSize: 15.0)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
