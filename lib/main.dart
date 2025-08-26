import 'package:appdonationsgestor/core/routes.dart';
import 'package:appdonationsgestor/pages/home_page.dart';
import 'package:appdonationsgestor/pages/login_page.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final user = FirebaseAuth.instance.currentUser;

  Widget initialPage = (user == null) ? const LoginPage() : const HomePage();
  runApp(MyApp(initialPage: initialPage));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialPage});

  final Widget initialPage;

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
