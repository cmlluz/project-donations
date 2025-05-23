import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';

class UserType extends StatelessWidget {
  const UserType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 209, 214),
      body: Column(
        children: [
          Container(
            height: 320,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: const BoxDecoration(
              color: ConstantsColors.labelColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),
          ),
          Expanded(
              child: Container(
            color: const Color.fromARGB(255, 209, 209, 214),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 35),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Qual será o seu tipo de conta?',
                    style: TextStyle(
                      color: ConstantsColors.labelColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Courrier',
                    ),
                  ),
                ),
                CustomButton(text: 'Pessoa Física', route: '/userRegisterPage'),
                SizedBox(height: 20),
                CustomButton(
                    text: 'Instituição', route: '/institutionRegisterPage'),
                SizedBox(height: 20),
                CustomButton(text: 'Gestor', route: '/gestorRegisterPage'),
                SizedBox(height: 20),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
