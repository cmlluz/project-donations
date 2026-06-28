import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/components/terms_checkbox.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/utils/firebase_error_translator.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class InstitutionRegisterPage extends StatefulWidget {
  const InstitutionRegisterPage({super.key});

  @override
  State<InstitutionRegisterPage> createState() =>
      _InstitutionRegisterPage();
}

class _InstitutionRegisterPage
    extends State<InstitutionRegisterPage> {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController cpfCnpjController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController addressController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController
      confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  String errorMessage = '';

  bool _isLoading = false;

  bool _acceptedTerms = false;

  String? _termsError;

  @override
  void dispose() {
    nameController.dispose();
    cpfCnpjController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  void registerUser() async {
    // VALIDAR SENHAS
    if (passwordController.text !=
        confirmPasswordController.text) {
      setState(() {
        errorMessage =
            'As senhas não coincidem';
      });

      return;
    }

    // VALIDAR TERMOS
    if (!_acceptedTerms) {
      setState(() {
        _termsError =
            'Os termos precisam ser aceitos para prosseguir';
      });

      return;
    }

    setState(() {
      _isLoading = true;
      _termsError = null;
      errorMessage = '';
    });

    try {
      // NORMALIZA O NOME
      final normalizedName = nameController.text
          .trim()
          .split(' ')
          .where((word) => word.isNotEmpty)
          .map(
            (word) =>
                word[0].toUpperCase() +
                word.substring(1).toLowerCase(),
          )
          .join(' ');

      final userData = {
        "name": normalizedName,
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "address":
            addressController.text.trim(),
        "cpfOrCnpj":
            cpfCnpjController.text.trim(),
        "role": "ROLE_INSTITUTION",
      };

      // CRIAR CONTA FIREBASE
      final credential =
          await authService.value.createAccount(
        email: emailController.text.trim(),
        password:
            passwordController.text.trim(),
      );

      // ATUALIZAR DISPLAY NAME
      await credential.user?.updateDisplayName(
        normalizedName,
      );

      // RECARREGAR USUÁRIO
      await credential.user?.reload();

      // SALVAR NO BACKEND
      // await apiService.createUser(userData);

      if (mounted) {
        GoRouter.of(context).push(
          '/finalizeRegistrationPage',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        final translatedMessage =
            FirebaseErrorTranslator.translate(
          e.code,
        );

        errorMessage =
            translatedMessage.isEmpty
                ? (e.message ??
                    'Ocorreu um erro ao registrar.')
                : translatedMessage;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e
            .toString()
            .replaceAll(
              'Exception: ',
              '',
            );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            color:
                ConstantsColors.whiteShade700,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // TOPO
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color:
                                ConstantsColors
                                    .blueShade900,
                          ),
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pop();
                          },
                        ),

                        const SizedBox(
                          width: 75,
                        ),

                        Container(
                          width: 70,
                          height: 5,
                          decoration:
                              BoxDecoration(
                            color:
                                ConstantsColors
                                    .blueShade900,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              25,
                            ),
                          ),
                        ),

                        Container(
                          width: 70,
                          height: 5,
                          decoration:
                              BoxDecoration(
                            color:
                                ConstantsColors
                                    .greyShade300,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              25,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Text(
                      'Passo 1 de 2',
                      style: TextStyle(
                        color:
                            ConstantsColors
                                .blackShade700,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w400,
                        fontFamily:
                            'Poppins',
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // TÍTULO
                    Text(
                      'Criar conta',
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                            color:
                                ConstantsColors
                                    .blueShade900,
                            fontSize: 30,
                          ).merge(
                        TextStylesConstants
                            .kpoppinsBlack,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    const Text(
                      'Informe alguns dados importantes',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            ConstantsColors
                                .blackShade700,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w400,
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    // NOME
                    CustomTextFields(
                      icon: Icons.person,
                      label:
                          'Nome da Instituição',
                      secret: false,
                      controller:
                          nameController,
                      keyboardType:
                          TextInputType.name,
                      validator: (
                        value,
                      ) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Campo obrigatório';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // EMAIL
                    CustomTextFields(
                      icon: Icons.email,
                      label:
                          'Email do responsável',
                      secret: false,
                      controller:
                          emailController,
                      keyboardType:
                          TextInputType
                              .emailAddress,
                      validator: (
                        value,
                      ) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Campo obrigatório';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // TELEFONE
                    CustomTextFields(
                      icon: Icons.phone,
                      label: 'Telefone',
                      secret: false,
                      controller:
                          phoneController,
                      keyboardType:
                          TextInputType
                              .number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                      validator: (
                        value,
                      ) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Campo obrigatório';
                        }

                        if (value.length <
                            14) {
                          return 'Telefone inválido';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // CNPJ
                    CustomTextFields(
                      icon:
                          Icons.person_4,
                      label: 'CNPJ',
                      secret: false,
                      controller:
                          cpfCnpjController,
                      keyboardType:
                          TextInputType
                              .number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly,
                        CnpjInputFormatter(),
                      ],
                      validator: (
                        value,
                      ) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Campo obrigatório';
                        }

                        if (!CNPJValidator
                            .isValid(
                          value,
                        )) {
                          return 'CNPJ inválido';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // ENDEREÇO
                    CustomTextFields(
                      icon: Icons.map,
                      label: 'Endereço',
                      secret: false,
                      controller:
                          addressController,
                      keyboardType:
                          TextInputType
                              .text,
                      validator: (
                        value,
                      ) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Campo obrigatório';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // SENHA
                    CustomTextFields(
                      icon: Icons.lock,
                      label: 'Senha',
                      secret: true,
                      controller:
                          passwordController,
                      keyboardType:
                          TextInputType
                              .visiblePassword,
                      validator: (
                        value,
                      ) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Campo obrigatório';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // CONFIRMAR SENHA
                    CustomTextFields(
                      icon: Icons.lock,
                      label:
                          'Confirme sua Senha',
                      secret: true,
                      controller:
                          confirmPasswordController,
                      keyboardType:
                          TextInputType
                              .visiblePassword,
                      validator: (
                        value,
                      ) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Campo obrigatório';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // TERMOS
                    TermsCheckbox(
                      value:
                          _acceptedTerms,
                      onChanged: (
                        value,
                      ) {
                        setState(() {
                          _acceptedTerms =
                              value ??
                                  false;

                          if (_acceptedTerms) {
                            _termsError =
                                null;
                          }
                        });
                      },
                      errorText:
                          _termsError,
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // ERRO
                    if (errorMessage
                        .isNotEmpty)
                      Text(
                        errorMessage,
                        style:
                            const TextStyle(
                              color: Colors
                                  .redAccent,
                            ),
                        textAlign:
                            TextAlign
                                .center,
                      ),

                    // BOTÃO
                    CustomButton(
                      text: 'Confirmar',
                      color:
                          ConstantsColors
                              .blueShade900,
                      textColor:
                          ConstantsColors
                              .whiteShade900,
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                  if (formKey
                                          .currentState
                                          ?.validate() ??
                                      false) {
                                    registerUser();
                                  }
                                },
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}