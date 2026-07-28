import 'dart:convert';

import 'package:appdonationsgestor/models/request_model.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/request_api_service.dart';
import 'package:appdonationsgestor/services/api_services/notification_api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PendingRequestsPage extends StatefulWidget {
  const PendingRequestsPage({super.key});

  @override
  State<PendingRequestsPage> createState() => _PendingRequestsPageState();
}

class _PendingRequestsPageState extends State<PendingRequestsPage> {
  late final RequestApiService _requestApiService;
  late final NotificationApiService _notificationApiService;
  final ApiClient _apiClient = ApiClient();
  late Future<List<Request>> _pendingRequestsFuture;

  @override
  void initState() {
    super.initState();
    _requestApiService = RequestApiService(_apiClient);
    _notificationApiService = NotificationApiService(_apiClient);
    _loadRequests();
  }

  void _loadRequests() {
    _pendingRequestsFuture = _requestApiService.getPendingRequests();
    setState(() {});
  }

  Future<void> _clearRelatedNewRequestNotifications(
      {required int requestId}) async {
    try {
      final notifs = await _notificationApiService.getMyNotifications();

      for (final n in notifs) {
        if (n.dataPayload == null) continue;

        try {
          final data = jsonDecode(n.dataPayload!) as Map<String, dynamic>;
          final type = data['type'];
          if (type != 'NEW_REQUEST') continue;

          final payloadRequestId = data['requestId'];
          final int? parsedRequestId = payloadRequestId is int
              ? payloadRequestId
              : int.tryParse(payloadRequestId?.toString() ?? '');

          if (parsedRequestId != requestId) continue;

          final payloadNotificationId = data['notificationId'];
          final int notificationIdToClear = payloadNotificationId is int
              ? payloadNotificationId
              : int.tryParse(payloadNotificationId?.toString() ?? '') ?? n.id;

          await _notificationApiService
              .deleteNotification(notificationIdToClear);
        } catch (_) {
          // ignora payload inválido
        }
      }
    } catch (e) {
      print('Falha ao limpar notificação relacionada: $e');
    }
  }

  Future<void> _handleRequest(Request request, bool approve) async {
    try {
      if (approve) {
        final approvedRequest =
            await _requestApiService.approveRequest(request.id);

        await _clearRelatedNewRequestNotifications(requestId: request.id);

        if (mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.grey.shade200,
              title: const Text("Solicitação Aprovada!"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    "Compartilhe este código com o solicitante para confirmar a entrega:\n\n${approvedRequest.confirmationCode}",
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Informações de contato de ${request.solicitante.name}:',
                    style: TextStylesConstants.kpoppinsSemiBold,
                  ),
                  const SizedBox(height: 6),
                  SelectableText(
                    [
                      if (request.solicitante.phone != null &&
                          request.solicitante.phone!.isNotEmpty)
                        'Telefone: ${request.solicitante.phone}',
                      'Email: ${request.solicitante.email}',
                      '',
                      'Combine a entrega/recebimento fora do app com cautela.',
                    ].join('\n'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Estas informações também estão disponíveis na página da sua publicação no seu perfil.',
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        await _requestApiService.rejectRequest(request.id);

        await _clearRelatedNewRequestNotifications(requestId: request.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solicitação Rejeitada.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao processar solicitação: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      _loadRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Solicitações Pendentes',
          style: TextStylesConstants.kinterSemiBold.merge(
            const TextStyle(
              color: ConstantsColors.blueShade900,
              fontSize: 22,
            ),
          ),
        ),
        backgroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        iconTheme: const IconThemeData(color: ConstantsColors.blueShade900),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/root'),
        ),
      ),
      backgroundColor: ConstantsColors.whiteShade900,
      body: FutureBuilder<List<Request>>(
        future: _pendingRequestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar solicitações: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final requests = snapshot.data;

          if (requests == null || requests.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma solicitação pendente.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final itemTitle = request.donation?.title ??
                  request.need?.title ??
                  'Item desconhecido';
              final solicitante = request.solicitante;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: solicitante.profilePictureUrl != null
                              ? NetworkImage(solicitante.profilePictureUrl!)
                              : null,
                          child: solicitante.profilePictureUrl == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(
                          solicitante.name,
                          style: TextStylesConstants.kpoppinsSemiBold,
                        ),
                        subtitle: Text(solicitante.email),
                      ),
                      const Divider(height: 20),
                      Text(
                        'Solicitou seu item:',
                        style: TextStylesConstants.kpoppinsRegular
                            .copyWith(color: Colors.grey.shade600),
                      ),
                      Text(
                        itemTitle,
                        style: TextStylesConstants.kpoppinsMedium
                            .copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => _handleRequest(request, false),
                            child: const Text(
                              'Rejeitar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _handleRequest(request, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ConstantsColors.blueShade900,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Aprovar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
