import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/controllers/navigation_controller.dart';
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
  bool _isLoadingTargetQuantity = true;
  int? _targetQuantity;

  @override
  void initState() {
    super.initState();
    _requestApiService = RequestApiService(_apiClient);
    _loadTargetQuantity();
  }

  Future<void> _loadTargetQuantity() async {
    try {
      final sentRequests = await _requestApiService.getMySentRequests();
      final request = sentRequests.firstWhere(
        (item) => item.id == widget.requestId,
      );

      if (mounted) {
        setState(() {
          _targetQuantity =
              request.donation?.quantity ?? request.need?.quantity;
          _isLoadingTargetQuantity = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _targetQuantity = null;
          _isLoadingTargetQuantity = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados da solicitação: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _buildDeliveryErrorMessage(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains('código') ||
        message.contains('codigo') ||
        message.contains('code') ||
        message.contains('confirm') ||
        message.contains('senha')) {
      return 'O código informado não confere com o código de confirmação desta solicitação.';
    }

    if (message.contains('quantidade') ||
        message.contains('quantity') ||
        message.contains('quantity')) {
      return 'A quantidade informada não foi aceita pelo sistema. Verifique se ela está dentro do limite permitido.';
    }

    if (message.contains('já') &&
        (message.contains('conclu') ||
            message.contains('confirm') ||
            message.contains('finaliz'))) {
      return 'Esta solicitação já foi concluída e não pode ser confirmada novamente.';
    }

    if (message.contains('403') || message.contains('401')) {
      return 'Você não tem permissão para confirmar esta solicitação.';
    }

    if (message.contains('404')) {
      return 'Não encontramos esta solicitação. Ela pode ter sido removida ou finalizada.';
    }

    if (message.contains('409')) {
      return 'Esta solicitação já mudou de status. Atualize a tela e tente novamente.';
    }

    return 'Não foi possível confirmar a entrega. Verifique o código e a quantidade informada.';
  }

  Future<void> _confirmDelivery() async {
    if (_codeController.text.isEmpty || _codeController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um código de 6 dígitos.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirmedQuantity = int.tryParse(_quantityController.text.trim());
    if (confirmedQuantity == null || confirmedQuantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Por favor, informe uma quantidade válida maior que zero.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_targetQuantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível validar a quantidade do post.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (confirmedQuantity > _targetQuantity!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'A quantidade informada não pode ser maior que a quantidade pretendida ($_targetQuantity).',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _requestApiService.deliverRequest(
        widget.requestId,
        _codeController.text.trim(),
        confirmedQuantity,
      );

      if (mounted) {
        NavigationController.postsRefreshToken.value++;
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
              content: Text(_buildDeliveryErrorMessage(e)),
              backgroundColor: Colors.red),
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
        foregroundColor: ConstantsColors.whiteShade700,
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
                'Insira o código de 6 dígitos fornecido pelo doador/instituição para confirmar a entrega.',
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
                  'Código de Confirmação',
                  style: TextStyle(
                    color: ConstantsColors.blackShade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFields(
                icon: Icons.password,
                secret: false,
                controller: _codeController,
                keyboardType: TextInputType.number,
                labelColor: ConstantsColors.whiteShade700,
                maxLength: 6,
              ),
              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quantidade entregue / recebida',
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
                maxLength: 9,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _isLoadingTargetQuantity
                      ? 'Carregando quantidade pretendida...'
                      : 'Quantidade pretendida: ${_targetQuantity ?? "indisponível"}',
                  style: TextStylesConstants.kinterRegular.merge(
                    const TextStyle(
                      fontSize: 13,
                      color: ConstantsColors.greyShade600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: CustomButton(
                  height: 45,
                  width: 240,
                  text: 'Confirmar doação',
                  color: ConstantsColors.blueShade900,
                  textColor: ConstantsColors.whiteShade900,
                  onPressed: _isLoading || _isLoadingTargetQuantity
                      ? null
                      : _confirmDelivery,
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
