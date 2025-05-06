import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';

class ManagerProfilePage extends StatefulWidget {
  const ManagerProfilePage({Key? key}) : super(key: key);

  @override
  State<ManagerProfilePage> createState() => _ManagerProfilePage();
}

class _ManagerProfilePage extends State<ManagerProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://media.gettyimages.com/id/1317804578/pt/foto/one-businesswoman-headshot-smiling-at-the-camera.jpg?s=612x612&w=0&k=20&c=RXbgBRAoPeDrPXNLXI74Th6Lexbk6PRQ6q0b4rIzEcc=",
                  ),
                  radius: 70,
                ),
              ),
              SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nome: ',
                          style: TextStylesConstants.kTitleProfile,
                        ),
                        Text(
                          'Lucia Fontes ',
                          style: TextStylesConstants.kformularyText,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'E-mail: ',
                          style: TextStylesConstants.kTitleProfile,
                        ),
                        Text(
                          'Luciafontes@gmail.com',
                          style: TextStylesConstants.kformularyText,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Telefone: ',
                          style: TextStylesConstants.kTitleProfile,
                        ),
                        Text(
                          '(71)12345-6789',
                          style: TextStylesConstants.kformularyText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
