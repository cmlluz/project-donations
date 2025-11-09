import 'package:appdonationsgestor/core/routes.dart';
import 'package:appdonationsgestor/models/donation_model.dart';
import 'package:appdonationsgestor/models/need_model.dart';
import 'package:appdonationsgestor/models/request_model.dart';
import 'package:appdonationsgestor/pages/confirm_donation_page.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/request_api_service.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/components/popup.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HystoryPage extends StatefulWidget {
  const HystoryPage({Key? key}) : super(key: key);

  @override
  State<HystoryPage> createState() => _HystoryPage();
}

class _HystoryPage extends State<HystoryPage> {
  late final RequestApiService _requestApiService;
  final ApiClient _apiClient = ApiClient();
  late Future<List<Request>> _myRequestsFuture;

  @override
  void initState() {
    super.initState();
    _requestApiService = RequestApiService(_apiClient);
    _loadMyRequests();
  }

  void _loadMyRequests() {
    _myRequestsFuture = _requestApiService.getMySentRequests();
    setState(() {});
  }

  String _formatStatus(String status) {
    if (status == 'APROVADO') return 'Solicitação aprovada';
    if (status == 'REJEITADO') return 'Solicitação recusada';
    if (status == 'PENDENTE') return 'Solicitação pendente';
    if (status == 'ENTREGUE') return 'Item entregue';
    return status;
  }

  IconData _getStatusIcon(String status) {
    if (status == 'APROVADO' || status == 'ENTREGUE') return Icons.check_circle;
    if (status == 'REJEITADO') return Icons.cancel;
    return Icons.hourglass_top_rounded;
  }

  Color _getStatusColor(String status) {
    if (status == 'APROVADO' || status == 'ENTREGUE') return Colors.green;
    if (status == 'REJEITADO') return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Solicitações'),
        backgroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        iconTheme: const IconThemeData(color: ConstantsColors.blackShade900),
        titleTextStyle: TextStylesConstants.kinterSemiBold.merge(
          const TextStyle(
            color: ConstantsColors.blackShade900,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.go('/root')),
      ),
      backgroundColor: ConstantsColors.whiteShade900,
      body: FutureBuilder<List<Request>>(
        future: _myRequestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Erro: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Você ainda não enviou nenhuma solicitação.'));
          }

          final requests = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final item = request.donation ?? request.need;

              if (item == null) return const SizedBox.shrink();

              final title =
                  item is Donation ? item.title : (item as Need).title;
              final category =
                  item is Donation ? item.category : (item as Need).category;
              final quantity =
                  item is Donation ? item.quantity : (item as Need).quantity;

              final statusText = _formatStatus(request.status);
              final statusIcon = _getStatusIcon(request.status);
              final statusColor = _getStatusColor(request.status);

              final formattedDate =
                  DateFormat('dd \'de\' MMMM \'de\' yyyy', 'pt_BR')
                      .format(request.createdAt);

              return Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: -30,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.only(top: 16, left: 12),
                        decoration: BoxDecoration(
                          color: ConstantsColors.blueShade500.withOpacity(0.38),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(statusIcon, color: statusColor, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              statusText,
                              style: TextStylesConstants.kpoppinsMedium.merge(
                                const TextStyle(
                                    fontSize: 13,
                                    color: ConstantsColors.blackShade900),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  title,
                                  style: TextStylesConstants.kpoppinsSemiBold
                                      .merge(const TextStyle(fontSize: 16)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (request.status == 'APROVADO') {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          content: Popup(
                                            title: 'Contato do Doador',
                                            subtitle:
                                                'Telefone: ${request.dono.phone ?? "Não informado"}',
                                            cancelText: 'Fechar',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    request.status == 'APROVADO'
                                        ? 'Ver contato'
                                        : 'Detalhes',
                                    style:
                                        TextStylesConstants.kinterRegular.merge(
                                      const TextStyle(
                                        fontSize: 13,
                                        color: ConstantsColors.greyShade900,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Quantidade: $quantity',
                              style: TextStylesConstants.kinterRegular.merge(
                                const TextStyle(
                                  fontSize: 12,
                                  color: ConstantsColors.greyShade600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_pin,
                                  color: ConstantsColors.greyShade600,
                                  size: 15,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Dono: ${request.dono.name}',
                                  style:
                                      TextStylesConstants.kinterRegular.merge(
                                    const TextStyle(
                                      fontSize: 12,
                                      color: ConstantsColors.greyShade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedDate,
                                  style:
                                      TextStylesConstants.kinterRegular.merge(
                                    const TextStyle(
                                      fontSize: 12,
                                      color: ConstantsColors.greyShade600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: ConstantsColors.greyShade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    category.toString().split('.').last,
                                    style: TextStylesConstants.kpoppinsMedium
                                        .merge(
                                      const TextStyle(
                                        fontSize: 12,
                                        color: ConstantsColors.blackShade900,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (request.status == 'APROVADO')
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      GoRouter.of(context).pushNamed(
                                        RouteNames.confirmDonationPage,
                                        extra: request.id,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Confirmar Entrega'),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
