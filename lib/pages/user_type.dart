import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';

class UserType extends StatelessWidget {
  const UserType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade700,
      body: Column(
        children: [
          ClipPath(
            clipper: WaveClipperTwo(flip: true),
            child: Container(
              alignment: Alignment.topLeft,
              height: 370,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/Man donating coin in charity box.png'),
                  fit: BoxFit.cover,
                ),
                color: ConstantsColors.blueShade900,
              ),
              child: IconButton(
                onPressed: () {
                  GoRouter.of(context).go('/');
                },
                icon: const Icon(Icons.arrow_back,
                    color: ConstantsColors.whiteShade600),
              ),
            ),
          ),
          Expanded(
              child: Container(
            color: ConstantsColors.whiteShade700,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 35),
                  child: SizedBox(
                    width: 280,
                    child: Text(
                      textAlign: TextAlign.center,
                      'Qual será o seu tipo de conta?',
                      style: TextStyle(
                        color: ConstantsColors.blueShade900,
                        fontSize: 32,
                        fontFamily: 'Poppins-Bold',
                      ),
                    ),
                  ),
                ),
                CustomButton(
                    height: 50,
                    width: 300,
                    text: 'Pessoa Física',
                    route: '/userRegisterPage'),
                SizedBox(height: 15),
                CustomButton(
                    height: 50,
                    width: 300,
                    text: 'Instituição',
                    route: '/institutionRegisterPage'),
                SizedBox(height: 15),
                CustomButton(
                    height: 50,
                    width: 300,
                    text: 'Gestor',
                    route: '/gestorRegisterPage'),
                SizedBox(height: 40),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
