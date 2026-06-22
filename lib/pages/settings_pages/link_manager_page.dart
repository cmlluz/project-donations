// import 'package:appdonationsgestor/components/custom_text_field.dart';
// import 'package:appdonationsgestor/resources/constant_colors.dart';
// import 'package:appdonationsgestor/resources/text_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class LinkManagerPage extends StatefulWidget {
//   const LinkManagerPage({super.key});

//   @override
//   State<LinkManagerPage> createState() => _LinkManagerPageState();
// }

// class _LinkManagerPageState extends State<LinkManagerPage> {
//   final TextEditingController emailController = TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     emailController.dispose();
//     super.dispose();
//   }

//   String? _validateEmail(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Campo obrigatório';
//     }
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value.trim())) {
//       return 'Email inválido';
//     }
//     return null;
//   }

//   void _sendLinkRequest() {
//     if (formKey.currentState?.validate() ?? false) {
//       final email = emailController.text.trim();

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Solicitação enviada"),
//           content: Text(
//             "Um email será enviado para $email para vincular sua conta ao gestor.",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 GoRouter.of(context).pop();
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ConstantsColors.whiteShade900,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: ConstantsColors.blueShade900,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Vincular Gestor',
//           style: const TextStyle(
//             color: ConstantsColors.blueShade900,
//             fontSize: 24,
//           ).merge(TextStylesConstants.kinterSemiBold),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Form(
//             key: formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Text(
//                     "Para vincular sua conta a um gestor, insira o email do gestor abaixo. Um email será enviado para ele com a solicitação.",
//                     style: TextStylesConstants.kpoppinsMedium.merge(
//                       const TextStyle(
//                         fontSize: 16.0,
//                         color: ConstantsColors.greyShade800,
//                       ),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 CustomTextFields(
//                   icon: Icons.email,
//                   label: 'Email do gestor',
//                   controller: emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   validator: _validateEmail,
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(200.0, 40.0),
//                     backgroundColor: ConstantsColors.blueShade900,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   onPressed: _sendLinkRequest,
//                   child: Text(
//                     'Enviar solicitação',
//                     style: const TextStyle(
//                       color: ConstantsColors.whiteShade900,
//                       fontSize: 18,
//                     ).merge(TextStylesConstants.kpoppinsSemiBold),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
