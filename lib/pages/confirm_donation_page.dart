import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/request_api_service.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/components/custom_button.dart';
import 'package:appdonationsgestor/components/custom_text_field.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:go_router/go_router.dart';

class ConfirmDonationPage extends StatefulWidget {
  final int requestId;
  const ConfirmDonationPage({Key? key, required this.requestId})
      : super(key: key);

  @override
  State<ConfirmDonationPage> createState() => _ConfirmDonationPageState();
}

class _ConfirmDonationPageState extends State<ConfirmDonationPage> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  final ApiClient _apiClient = ApiClient();
  late final RequestApiService _requestApiService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestApiService = RequestApiService(_apiClient);
  }

  Future<void> _confirmDelivery() async {
    setState(() => _isLoading = true);

    try {
      await _requestApiService.deliverRequest(widget.requestId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entrega confirmada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/root');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao confirmar entrega: $e'),
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text(
          'Confirmar Doação',
          style: TextStylesConstants.kformularyTitle,
        ),
        backgroundColor: ConstantsColors.blueShade900,
        foregroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: SizedBox(),
        ),
      ),
      backgroundColor: ConstantsColors.blueShade900,
      body: Container(
        decoration: const BoxDecoration(
          color: ConstantsColors.whiteShade700,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Finalize sua doação',
                style: TextStylesConstants.kpoppinsSemiBold.merge(
                  const TextStyle(
                    fontSize: 18,
                    color: ConstantsColors.blueShade900,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Informe a quantidade e o código da doação para confirmar a entrega.',
                style: TextStylesConstants.kpoppinsRegular.merge(
                  const TextStyle(
                    fontSize: 15,
                    color: ConstantsColors.greyShade600,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quantidade entregue',
                  style: TextStyle(
                    color: ConstantsColors.blackShade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFields(
                icon: Icons.numbers_outlined,
                secret: false,
                controller: _quantityController,
                keyboardType: TextInputType.number,
                labelColor: ConstantsColors.whiteShade700,
              ),
              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Código da doação',
                  style: TextStyle(
                    color: ConstantsColors.blackShade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFields(
                icon: Icons.edit_document,
                secret: false,
                controller: _codeController,
                keyboardType: TextInputType.text,
                labelColor: ConstantsColors.whiteShade700,
              ),
              const SizedBox(height: 40),
              Center(
                child: CustomButton(
                  height: 45,
                  width: 240,
                  text: 'Confirmar doação',
                  color: ConstantsColors.blueShade900,
                  textColor: ConstantsColors.whiteShade900,
                  onPressed: _isLoading ? null : _confirmDelivery,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  child: Text(
                    'Cancelar',
                    style: const TextStyle(
                      color: ConstantsColors.greyShade600,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ).merge(TextStylesConstants.kpoppinsSemiBold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
