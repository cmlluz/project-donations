import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/auth_api_service.dart';
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
  late final AuthApiService _authApiService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authApiService = AuthApiService(ApiClient());
  }

  Future<void> _handleDeleteAccount() async {
    setState(() => _isLoading = true);
    try {
      await _authApiService.deleteUser();

      if (mounted) {
        context.go('/');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta excluída com sucesso.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir conta: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 50,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Você está prestes a excluir todos os seus dados da conta.\nTem certeza absoluta?\nEssa ação é irreversível.",
                textAlign: TextAlign.center,
                style: TextStylesConstants.kpoppinsMedium.merge(
                  const TextStyle(
                    fontSize: 16,
                    color: ConstantsColors.greyShade800,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.red)
              else
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
                  onPressed: _handleDeleteAccount,
                  child: Text(
                    "Deletar conta",
                    style: const TextStyle(
                      color: ConstantsColors.whiteShade900,
                      fontSize: 18,
                    ).merge(TextStylesConstants.kpoppinsSemiBold),
                  ),
                ),
              const SizedBox(height: 20),
              if (!_isLoading)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
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
      ),
    );
  }
}
