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
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController passwordController = TextEditingController();
  late final AuthApiService _authApiService;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _authApiService = AuthApiService(ApiClient());
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleVerification() async {
    final password = passwordController.text.trim();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira sua senha.')),
      );
      return;
    }

    setState(() => _isVerifying = true);

    try {
      await _authApiService.verifyPassword(password);

      if (mounted) {
        GoRouter.of(context).pushNamed(
          'confirmDeletionPage',
          extra: password,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColors.whiteShade900,
      appBar: AppBar(
        backgroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ConstantsColors.blueShade900,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Segurança',
          style: const TextStyle(
            color: ConstantsColors.blueShade900,
            fontSize: 22,
          ).merge(TextStylesConstants.kinterSemiBold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ConstantsColors.blueShade900.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 80,
                  color: ConstantsColors.blueShade900,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Confirme sua identidade",
                style: TextStylesConstants.kpoppinsSemiBold.copyWith(
                  fontSize: 20,
                  color: ConstantsColors.blueShade900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Para sua segurança, insira a senha atual da sua conta para prosseguir com a exclusão.",
                textAlign: TextAlign.center,
                style: TextStylesConstants.kpoppinsMedium.copyWith(
                  fontSize: 15.0,
                  color: ConstantsColors.greyShade800,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextFields(
                icon: Icons.lock_outline,
                label: 'Senha atual',
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                secret: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: ConstantsColors.blueShade900,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstantsColors.blueShade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _isVerifying ? null : _handleVerification,
                  child: _isVerifying
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          'Verificar Senha',
                          style: TextStylesConstants.kpoppinsSemiBold.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Mudei de ideia",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}