import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pixController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.blueShade900,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/root');
          },
        ),
        title: const Text(
          'Editar Perfil',
          style: TextStylesConstants.kformularyTitle,
        ),
        backgroundColor: ConstantsColors.blueShade900,
        foregroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: ConstantsColors.whiteShade900,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
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
                ),
                const SizedBox(height: 20),
                CustomTextFields(
                  icon: Icons.person,
                  label: 'Nome',
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFields(
                  icon: Icons.mail,
                  label: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFields(
                  icon: Icons.phone,
                  label: 'Telefone',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFields(
                  icon: Icons.key,
                  label: 'Chave Pix',
                  controller: pixController,
                  keyboardType: TextInputType.text,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 120,
                  child: TextFormField(
                    controller: bioController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 55),
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                        ),
                      ),
                      labelText: 'Biografia',
                      alignLabelWithHint: true,
                      filled: true,
                      fillColor: ConstantsColors.whiteShade900,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Digite sua biografia...',
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 150, 150, 150),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFields(
                  icon: Icons.lock,
                  label: 'Senha',
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  secret: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 30),
                const CustomButton(
                  height: 50,
                  width: double.infinity,
                  text: 'Confirmar',
                  route: '/root',
                  color: ConstantsColors.blueShade900,
                  textColor: ConstantsColors.whiteShade900,
                  hasMensage: true,
                  mensage: 'Perfil atualizado com sucesso!',
                ),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).go('/root');
                  },
                  child: Text(
                    'Cancelar',
                    style: const TextStyle(
                      color: ConstantsColors.blueShade900,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ).merge(TextStylesConstants.kpoppinsSemiBold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
