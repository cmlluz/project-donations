import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:appdonationsgestor/pages/app_loading_page.dart';
import 'package:appdonationsgestor/resources/root_page.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = AppLoadingPage();
            } else if (snapshot.hasData) {
              widget = const RootPage();
            } else {
              widget = pageIfNotConnected ?? const RootPage();
            }
            return widget;
          },
        );
      },
    );
  }
}
