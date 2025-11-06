import 'dart:async';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:appdonationsgestor/services/api_services/auth_api_service.dart';
import 'package:appdonationsgestor/services/api_services/notification_api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final ApiClient _apiClient = ApiClient();
  late final AuthApiService _authApiService;
  late final NotificationApiService _notificationApiService;

  NotificationService() {
    _authApiService = AuthApiService(_apiClient);
    _notificationApiService = NotificationApiService(_apiClient);
  }

  static final _navigationStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get navigationStream =>
      _navigationStreamController.stream;

  Future<void> initNotifications() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      await getAndSendToken();
      _setupListeners();
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _setupListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessage(message);
      }
    });
  }

  void _handleMessage(RemoteMessage message) async {
    print('Handling notification tap: ${message.data}');
    final Map<String, dynamic> data = message.data;

    final notificationIdStr = data['notificationId'];
    if (notificationIdStr != null) {
      try {
        final notificationId = int.parse(notificationIdStr);
        await _notificationApiService.markAsRead(notificationId);
      } catch (e) {
        print("Erro ao marcar como lida pelo push: $e");
      }
    }

    _navigationStreamController.add(data);
  }

  void disposeStream() {
    _navigationStreamController.close();
  }

  Future<void> getAndSendToken() async {
    try {
      String? token = await _fcm.getToken();
      if (token != null) {
        print("FCM Token: $token");
        await _authApiService.updateUser({"fcmToken": token});
      }
    } catch (e) {
      print("Erro ao obter e enviar token FCM: $e");
      rethrow;
    }
  }

  Future<void> deleteToken() async {
    try {
      await _fcm.deleteToken();
      await _authApiService.updateUser({"fcmToken": null});
      print("FCM Token deletado");
    } catch (e) {
      print("Erro ao deletar token FCM: $e");
      rethrow;
    }
  }
}
