import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/core/routes.dart';

class RemoveAccountPage extends StatefulWidget {
  const RemoveAccountPage({super.key});

  @override
  State<RemoveAccountPage> createState() => _RemoveAccountPage();
}

class _RemoveAccountPage extends State<RemoveAccountPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back_ios),
        //     onPressed: () => Navigator.pop(context),
        //   ),
        // ),
        body: Stack(
      children: [
        SizedBox.expand(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ConstantsColors.blueShade500,
                  ConstantsColors.tealShade200,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Deletar minha conta",
                    style: TextStylesConstants.kpoppinsBold.merge(
                        const TextStyle(
                            fontSize: 32.0,
                            color: ConstantsColors.whiteShade900)),
                  ),
                  const SizedBox(height: 100),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextFields(
                        icon: Icons.email,
                        label: 'Digite seu email',
                        secret: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          CustomTextFields(
                            icon: Icons.lock,
                            label: 'Digite sua senha',
                            secret: true,
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ConstantsColors.redShade900,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                // GoRouter.of(context).pushNamed('loginPage');
                              },
                              child: Text(
                                'Deletar permanentemente',
                                style: const TextStyle(
                                  color: ConstantsColors.whiteShade900,
                                  fontSize: 15,
                                ).merge(TextStylesConstants.kpoppinsMedium),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
