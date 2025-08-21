import 'package:appdonationsgestor/auth/app_data.dart';
import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmDeletionPage extends StatefulWidget {
  const ConfirmDeletionPage({super.key});

  @override
  State<ConfirmDeletionPage> createState() => _ConfirmDeletionPageState();
}

class _ConfirmDeletionPageState extends State<ConfirmDeletionPage> {
  //simular um request pra api
  final List<String> accountOwners = ["Lucia Fontes"];

  // void deleteAccount() async {
  //   try {
  //     await authService.value.deleteAccount();
  //     AppData.navBarCurrentIndexNotifier.value = 0;
  //     AppData.onboardingCurrentIndexNotifier.value = 0;
  //     if (context.mounted) {
  //       context.go('/');
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade900,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ConstantsColors.blueShade900,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Excluir conta',
          style: const TextStyle(
            color: ConstantsColors.blueShade900,
            fontSize: 20,
          ).merge(TextStylesConstants.kinterSemiBold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: ConstantsColors.whiteShade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "Você está prestes a excluir todos os seus dados da conta ${accountOwners[0]}.\n"
              "Tem certeza absoluta?\n"
              "Essa ação é irreversível.",
              style: TextStylesConstants.kpoppinsMedium.merge(
                const TextStyle(
                  fontSize: 16,
                  color: ConstantsColors.greyShade800,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(260, 50),
                backgroundColor: Colors.red.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.2),
              ),
              onPressed: () {
                // deleteAccount();
              },
              child: Text(
                "Deletar conta",
                style: const TextStyle(
                  color: ConstantsColors.whiteShade900,
                  fontSize: 18,
                ).merge(TextStylesConstants.kpoppinsSemiBold),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => {Navigator.pop(context), Navigator.pop(context)},
              child: Text(
                "Cancelar",
                style: const TextStyle(
                  fontSize: 16,
                  color: ConstantsColors.greyShade600,
                ).merge(TextStylesConstants.kpoppinsMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
