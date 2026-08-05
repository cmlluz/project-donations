import 'package:appdonationsgestor/core/routes.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:appdonationsgestor/controllers/favorite_controller.dart';
import 'package:appdonationsgestor/controllers/user_provider.dart';
import 'package:appdonationsgestor/controllers/campaign_controller.dart';
import 'package:appdonationsgestor/controllers/donation_controller.dart';
import 'package:appdonationsgestor/controllers/need_controller.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Handling a background message: ${message.messageId}");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(const AppInitialization());
}

class AppInitialization extends StatefulWidget {
  const AppInitialization({super.key});

  @override
  State<AppInitialization> createState() => _AppInitializationState();
}

class _AppInitializationState extends State<AppInitialization> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initApp();
  }

  Future<void> _initApp() async {
    // Configuração de data
    await initializeDateFormatting('pt_BR', null);
    Intl.defaultLocale = 'pt_BR';

    // Inicialização Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Firebase App Check
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );

    // Firebase Messaging
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: ConstantsColors.whiteShade700,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    CircularProgressIndicator(
                      color: ConstantsColors.blueShade900,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Erro
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Erro ao inicializar o aplicativo:\n${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          );
        }

        // App principal
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => FavoriteController(),
            ),
            ChangeNotifierProvider(
              create: (context) => UserProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => CampaignController(),
            ),
            ChangeNotifierProvider(
              create: (context) => DonationController(),
            ),
            ChangeNotifierProvider(
              create: (context) => NeedController(),
            ),
          ],
          child: const MyApp(),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRountersConfiguration.returnRouter(),
      title: 'Donations Gestor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ConstantsColors.blueShade900,
        ),
        useMaterial3: true,
      ),
    );
  }
}
