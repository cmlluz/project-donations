import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/components/custom_button.dart';

class FinalizeRegistrationPage extends StatefulWidget {
  const FinalizeRegistrationPage({super.key});

  @override
  State<FinalizeRegistrationPage> createState() =>
      _FinalizeRegistrationPageState();
}

class _FinalizeRegistrationPageState extends State<FinalizeRegistrationPage> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController pixKeyController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ConstantsColors.blueShade500,
                ConstantsColors.tealShade200
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Quase lá!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(186, 0, 0, 0),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Faltam só mais alguns detalhes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(186, 0, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      backgroundColor: ConstantsColors.blueShade500,
                      radius: 60,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.add_photo_alternate_sharp,
                              size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Adicione uma foto de perfil',
                    style: TextStyle(
                      color: Color.fromARGB(186, 0, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFields(
                    icon: Icons.info,
                    controller: bioController,
                    label: 'Biografia',
                    secret: false,
                    keyboardType: TextInputType.text,
                    hintText: 'Conte-nos um pouco sobre você',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFields(
                    controller: pixKeyController,
                    icon: Icons.payment,
                    label: 'Chave PIX',
                    keyboardType: TextInputType.text,
                    secret: false,
                  ),
                  const SizedBox(height: 20),
                  const CustomButton(
                    text: 'Cadastrar',
                    route: '/root',
                    color: ConstantsColors.blueShade900,
                    textColor: ConstantsColors.whiteShade900,
                    width: 130,
                    height: 35,
                    hasMensage: true,
                    mensage: 'Cadastro realizado com sucesso!',
                  ),
                  const SizedBox(height: 10),
                  const CustomButton(
                    text: 'Voltar',
                    route: '/institutionRegisterPage',
                    color: ConstantsColors.whiteShade900,
                    textColor: ConstantsColors.blueShade900,
                    width: 130,
                    height: 35,
                    fontSize: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
