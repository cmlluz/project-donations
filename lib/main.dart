import 'package:appdonationsgestor/core/routes.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
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
import 'package:appdonationsgestor/services/notification_service.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
}

void main() {
  // Garante que a ligação com o nativo exista, mas NÃO espera o Firebase aqui
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  // Executa o app IMEDIATAMENTE com uma tela de carregamento
  runApp(const AppInitialization());
}

/// Widget responsável por inicializar dependências antes de carregar o app real
class AppInitialization extends StatefulWidget {
  const AppInitialization({super.key});

  @override
  State<AppInitialization> createState() => _AppInitializationState();
}

class _AppInitializationState extends State<AppInitialization> {
  // Future que guarda o estado da inicialização
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initApp();
  }

  /// Coloque aqui tudo que estava "travando" o main()
  Future<void> _initApp() async {
    // 1. Configuração de Data
    await initializeDateFormatting('pt_BR', null);
    Intl.defaultLocale = 'pt_BR';

    // 2. Inicialização do Firebase (A parte pesada)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 3. Configuração de Listeners
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // (Opcional) Pequeno delay artificial se quiser ver o loading
    // await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        // Enquanto carrega, mostra tela de loading
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: ConstantsColors.whiteShade700, // Cor do seu tema
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Pode colocar sua Logo aqui
                    // Image.asset('assets/LogoName.png', width: 150),
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

        // Se der erro na inicialização
        if (snapshot.hasError) {
          return MaterialApp(
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

        // Sucesso: Carrega os Providers e o App Principal
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => FavoriteController()),
            ChangeNotifierProvider(create: (context) => UserProvider()),
            ChangeNotifierProvider(create: (context) => CampaignController()),
            ChangeNotifierProvider(create: (context) => DonationController()),
            ChangeNotifierProvider(create: (context) => NeedController()),
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
        colorScheme:
            ColorScheme.fromSeed(seedColor: ConstantsColors.blueShade900),
        useMaterial3: true,
      ),
    );
  }
}
