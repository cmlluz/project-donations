import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/auth_api_service.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() =>
      _DeleteAccountPage();
}

class _DeleteAccountPage
    extends State<DeleteAccountPage> {
  final TextEditingController
      passwordController =
      TextEditingController();

  String errorMessage = '';

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void continueToConfirmation() {
    if (passwordController.text
        .trim()
        .isEmpty) {
      setState(() {
        errorMessage =
            'Digite sua senha.';
      });

      return;
    }

    setState(() {
      errorMessage = '';
    });

    final email =
        authService
            .value
            .currentUser
            ?.email;

    if (email == null) {
      setState(() {
        errorMessage =
            'Usuário não encontrado.';
      });

      return;
    }

    GoRouter.of(context).pushNamed(
      'confirmDeletionPage',
      extra: {
        'email': email,
        'password':
            passwordController.text.trim(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ConstantsColors.whiteShade900,

      appBar: AppBar(
        backgroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color:
                ConstantsColors.blueShade900,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Segurança',
          style: const TextStyle(
            color:
                ConstantsColors.blueShade900,
            fontSize: 24,
          ).merge(
            TextStylesConstants
                .kinterSemiBold,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.all(12.0),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              const SizedBox(
                height: 10,
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),

                child: Text(
                  "Para confirmar sua identidade, por favor, insira a senha da sua conta.",
                  style:
                      TextStylesConstants
                          .kpoppinsMedium
                          .merge(
                    const TextStyle(
                      fontSize: 16.0,
                      color:
                          ConstantsColors
                              .greyShade800,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [
                  CustomTextFields(
                    icon: Icons.lock,
                    label: 'Senha',
                    controller:
                        passwordController,
                    keyboardType:
                        TextInputType
                            .visiblePassword,
                    secret: true,
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        10,
                      ),
                      borderSide:
                          const BorderSide(
                        color:
                            ConstantsColors
                                .blueShade900,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  if (errorMessage
                      .isNotEmpty)
                    Text(
                      errorMessage,
                      style:
                          const TextStyle(
                        color: Colors.red,
                      ),
                    ),

                  const SizedBox(
                    height: 30,
                  ),

                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(
                        200.0,
                        40.0,
                      ),

                      backgroundColor:
                          ConstantsColors
                              .blueShade900,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          15,
                        ),
                      ),
                    ),

                    onPressed:
                        continueToConfirmation,

                    child: Text(
                      'Confirmar',
                      style:
                          const TextStyle(
                            color:
                                ConstantsColors
                                    .whiteShade900,
                            fontSize: 18,
                          ).merge(
                        TextStylesConstants
                            .kpoppinsSemiBold,
                      ),
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