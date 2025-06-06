import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserType extends StatelessWidget {
  const UserType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade600,
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            height: 320,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: const BoxDecoration(
              color: ConstantsColors.blueShade900,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),
            child: IconButton(
              onPressed: () {
                GoRouter.of(context).go('/');
              },
              icon: const Icon(Icons.arrow_back,
                  color: ConstantsColors.whiteShade600),
            ),
          ),
          Expanded(
              child: Container(
            color: ConstantsColors.whiteShade600,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 35),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Qual será o seu tipo de conta?',
                    style: TextStyle(
                      color: ConstantsColors.blueShade900,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Courrier',
                    ),
                  ),
                ),
                CustomButton(
                    height: 50,
                    width: 300,
                    text: 'Pessoa Física',
                    route: '/userRegisterPage'),
                SizedBox(height: 20),
                CustomButton(
                    height: 50,
                    width: 300,
                    text: 'Instituição',
                    route: '/institutionRegisterPage'),
                SizedBox(height: 20),
                CustomButton(
                    height: 50,
                    width: 300,
                    text: 'Gestor',
                    route: '/gestorRegisterPage'),
                SizedBox(height: 20),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
