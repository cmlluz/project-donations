import 'dart:convert';
import 'package:appdonationsgestor/core/routes.dart';
import 'package:appdonationsgestor/models/notification_model.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/notification_api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPage();
}

class _NotificationsPage extends State<NotificationsPage> {
  bool notificationsEnabled = true;

  late final NotificationApiService _notificationApiService;
  final ApiClient _apiClient = ApiClient();
  late Future<List<NotificationModel>> _apiNotificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationApiService = NotificationApiService(_apiClient);
    _checkNotificationSettings();
    _loadApiNotifications();
  }

  Future<void> _checkNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool('notifications_enabled') ?? true;
      setState(() {
        notificationsEnabled = enabled;
      });
    } catch (e) {
      print("Erro ao verificar configurações de notificação: $e");
    }
  }

  void _loadApiNotifications() {
    _apiNotificationsFuture = _notificationApiService.getMyNotifications();
    setState(() {});
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours < 1) {
        if (difference.inMinutes < 1) {
          return "Agora";
        }
        return "Hoje às ${DateFormat('HH:mm').format(dateTime)}";
      }
      return "Hoje às ${DateFormat('HH:mm').format(dateTime)}";
    } else if (difference.inDays == 1) {
      return "Ontem às ${DateFormat('HH:mm').format(dateTime)}";
    } else {
      return DateFormat('dd/MM/yy \'às\' HH:mm').format(dateTime);
    }
  }

  Future<void> _onNotificationTapped(NotificationModel notif) async {
    if (!notif.isRead) {
      try {
        await _notificationApiService.markAsRead(notif.id);
      } catch (e) {
        print("Falha ao marcar como lida: $e");
      }
    }

    if (notif.dataPayload == null) {
      _loadApiNotifications();
      return;
    }

    try {
      Map<String, dynamic> data = jsonDecode(notif.dataPayload!);
      final type = data['type'] as String?;

      if (!mounted) return;

      if (type == 'NEW_REQUEST') {
        GoRouter.of(context).goNamed(RouteNames.pendingRequests);
      } else if (type == 'REQUEST_APPROVED' || type == 'REQUEST_REJECTED') {
        GoRouter.of(context).goNamed(RouteNames.hystoryPage);
      } else if (type == 'POST_VALIDATION_PENDING') {
        final String? itemId = data['itemId'];
        final String? itemType = data['itemType'];
        if (itemId != null && itemType != null) {
          GoRouter.of(context).pushNamed(
            RouteNames.allowPostPage,
            extra: {'itemId': itemId, 'itemType': itemType},
          );
        }
      } else if (type == 'POST_APPROVED' || type == 'POST_REJECTED') {
        GoRouter.of(context).goNamed(RouteNames.hystoryPage);
      }
    } catch (e) {
      print("Erro ao navegar pela notificação: $e");
    } finally {
      _loadApiNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        centerTitle: true,
        backgroundColor: ConstantsColors.whiteShade900,
        elevation: 0,
        iconTheme: const IconThemeData(color: ConstantsColors.blueShade900),
        titleTextStyle: TextStylesConstants.kinterSemiBold.merge(
          const TextStyle(
            color: ConstantsColors.blueShade900,
            fontSize: 24,
          ).merge(TextStylesConstants.kpoppinsRegular),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: ConstantsColors.whiteShade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: notificationsEnabled
              ? RefreshIndicator(
                  onRefresh: () async {
                    _loadApiNotifications();
                  },
                  child: buildApiNotificationsList(),
                )
              : buildDisabledNotifications(),
        ),
      ),
    );
  }

  Widget buildApiNotificationsList() {
    return FutureBuilder<List<NotificationModel>>(
      future: _apiNotificationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro ao carregar histórico: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        final notifications = snapshot.data;

        if (notifications == null || notifications.isEmpty) {
          return buildEmptyNotifications();
        }

        final newNotifications = notifications.where((n) => !n.isRead).toList();
        final oldNotifications = notifications.where((n) => n.isRead).toList();

        return ListView(
          children: [
            if (newNotifications.isNotEmpty) ...[
              buildSectionTitle("Recentes"),
              ...newNotifications
                  .map((notif) => buildApiNotification(notif))
                  .toList(),
            ],
            if (oldNotifications.isNotEmpty) ...[
              buildDivider(),
              buildSectionTitle("Antigas"),
              ...oldNotifications
                  .map((notif) => buildApiNotification(notif))
                  .toList(),
            ],
          ],
        );
      },
    );
  }

  Widget buildApiNotification(NotificationModel notif) {
    return GestureDetector(
      onTap: () => _onNotificationTapped(notif),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: notif.isRead
              ? ConstantsColors.whiteShade700
              : ConstantsColors.blueShade400.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "•",
                  style: TextStyle(
                    fontSize: 30,
                    color: notif.isRead
                        ? Colors.grey.shade400
                        : ConstantsColors.blueShade900,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    notif.title,
                    style: const TextStyle(
                      color: ConstantsColors.blueShade900,
                      fontSize: 17,
                    ).merge(TextStylesConstants.kinterBold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                _formatRelativeTime(notif.createdAt),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ).merge(TextStylesConstants.kinterRegular),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                notif.body,
                style: const TextStyle(
                  color: ConstantsColors.blueShade900,
                  fontSize: 14,
                ).merge(TextStylesConstants.kinterRegular),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: ConstantsColors.blueShade900,
          ).merge(TextStylesConstants.kinterRegular),
        ),
      );

  Widget buildDivider() => Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: ConstantsColors.greyShade600,
              width: 1,
            ),
          ),
        ),
      );

  Widget buildEmptyNotifications() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/notification_img.png",
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 40),
          Text(
            'Nenhuma notificação encontrada',
            style: const TextStyle(
              color: ConstantsColors.blueShade900,
              fontSize: 20,
            ).merge(TextStylesConstants.kpoppinsBold),
          ),
          const SizedBox(height: 10),
          Text(
            'Fique tranquilo, avisaremos quando houver novidades.',
            style: const TextStyle(
              color: ConstantsColors.blueShade900,
              fontSize: 17,
            ).merge(TextStylesConstants.kpoppinsRegular),
            textAlign: TextAlign.center,
          ),
        ],
      );

  Widget buildDisabledNotifications() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/notification_img.png",
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 40),
          Text(
            'Notificações Desativadas',
            style: const TextStyle(
              color: ConstantsColors.blueShade900,
              fontSize: 20,
            ).merge(TextStylesConstants.kpoppinsBold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Você desativou as notificações. Para receber novidades sobre doações e necessidades, ative as notificações nas configurações.',
              style: const TextStyle(
                color: ConstantsColors.blueShade900,
                fontSize: 15,
              ).merge(TextStylesConstants.kpoppinsRegular),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () {
              // Navegar para página de configurações
              GoRouter.of(context).pushNamed(RouteNames.root);
              Future.delayed(const Duration(milliseconds: 100), () {
                Navigator.of(context).pushNamed('/settings');
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: ConstantsColors.blueShade900,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Ir para Configurações',
              style: const TextStyle(
                color: ConstantsColors.whiteShade900,
                fontSize: 16,
              ).merge(TextStylesConstants.kpoppinsMedium),
            ),
          ),
        ],
      );
}