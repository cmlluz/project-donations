import 'dart:convert';
import 'package:appdonationsgestor/models/notification_model.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';

class NotificationApiService {
  final ApiClient _apiClient;

  NotificationApiService(this._apiClient);

  Future<List<NotificationModel>> getMyNotifications() async {
    final response = await _apiClient.get('notifications');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body
          .map((dynamic item) => NotificationModel.fromJson(item))
          .toList();
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao buscar notificações');
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final response =
        await _apiClient.post('notifications/$notificationId/read');

    if (response.statusCode != 200) {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao marcar notificação como lida');
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    final response = await _apiClient.delete('notifications/$notificationId');

    // Alguns backends retornam 200, outros 204
    if (response.statusCode != 200 && response.statusCode != 204) {
      print("Erro ${response.statusCode}: ${response.body}");
      throw Exception('Falha ao deletar notificação');
    }
  }
}
