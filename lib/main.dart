import 'package:appdonationsgestor/core/routes.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application .
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRountersConfiguration.returnRouter(),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: ConstantsColors.blueShade900),
        useMaterial3: true,
      ),
    );
  }
}
