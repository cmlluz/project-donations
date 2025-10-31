import 'package:appdonationsgestor/services/api_services/auth_api_service.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final AuthApiService _authApiService = AuthApiService(ApiClient());

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
      _setupListeners();
      getAndSendToken();
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _setupListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
    }
  }

  Future<void> deleteToken() async {
    try {
      await _fcm.deleteToken();
      await _authApiService.updateUser({"fcmToken": null});
      print("FCM Token deletado");
    } catch (e) {
      print("Erro ao deletar token FCM: $e");
    }
  }
}
