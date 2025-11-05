import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:appdonationsgestor/auth/app_data.dart';
import 'package:appdonationsgestor/auth/auth_service.dart';
import 'package:appdonationsgestor/components/menu_button.dart';
import 'package:appdonationsgestor/controllers/navigation_controller.dart';
import 'package:appdonationsgestor/core/routes.dart';
import 'package:appdonationsgestor/pages/favorites_page.dart';
import 'package:appdonationsgestor/pages/home_page.dart';
import 'package:appdonationsgestor/pages/search_pages/search_page.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:appdonationsgestor/resources/text_styles.dart';
import 'package:appdonationsgestor/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final NotificationService _notificationService = NotificationService();
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    NavigationController.currentIndex.addListener(_updateIndex);
    _initNotifications();

    _notificationSubscription =
        _notificationService.navigationStream.listen((type) {
      if (mounted) {
        _handleNavigation(type);
      }
    });
  }

  void _handleNavigation(String type) {
    if (type == 'NEW_REQUEST') {
      GoRouter.of(context).goNamed(RouteNames.pendingRequests);
    } else if (type == 'REQUEST_APPROVED' || type == 'REQUEST_REJECTED') {
      GoRouter.of(context).goNamed(RouteNames.hystoryPage);
    }
  }

  void _initNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    _notificationService.initNotifications();
  }

  @override
  void dispose() {
    NavigationController.currentIndex.removeListener(_updateIndex);
    _notificationSubscription?.cancel();
    super.dispose();
  }

  void _updateIndex() {
    setState(() {});
  }

  final List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    SizedBox.shrink(),
    FavoritesPage(),
    SizedBox.shrink(),
  ];

  final List<String> iconList = [
    'assets/icons/home_icon.png',
    'assets/icons/welcome_icon.png',
    'assets/icons/create_icon.png',
    'assets/icons/favorites_icon.png',
    'assets/icons/logout_icon.png',
  ];

  void logout() async {
    try {
      await _notificationService.deleteToken();
      await authService.value.signOut();
      AppData.navBarCurrentIndexNotifier.value = 0;
      AppData.onboardingCurrentIndexNotifier.value = 0;
      if (context.mounted) {
        context.go('/');
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: NavigationController.currentIndex.value,
        children: pages,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (index, isActive) {
          final iconColor = isActive
              ? ConstantsColors.blueShade900
              : ConstantsColors.blueShade500;

          return Image.asset(iconList[index], color: iconColor);
        },
        activeIndex: NavigationController.currentIndex.value,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.softEdge,
        scaleFactor: 1.0,
        splashColor: Colors.transparent,
        splashSpeedInMilliseconds: 1,
        shadow: const Shadow(color: Colors.transparent),
        elevation: 0,
        onTap: (index) {
          if (index == 2) {
            _showBottomMenu(context);
          } else if (index == 4) {
            _showLogoutMenu(context);
          } else {
            setState(() {
              NavigationController.currentIndex.value = index;
            });
          }
        },
      ),
    );
  }

  void _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: ConstantsColors.whiteShade700,
            borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
          ),
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Comece a postar',
                      style: const TextStyle(
                        fontSize: 20,
                        color: ConstantsColors.blueShade900,
                      ).merge(TextStylesConstants.kinterSemiBold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: ConstantsColors.blueShade900,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MenuButton(
                    icon: Icons.volunteer_activism_outlined,
                    label: 'Anunciar \n Necessidade',
                    onTap: () {
                      GoRouter.of(context).push("/itemPostPage");
                      Navigator.of(context).pop();
                    },
                  ),
                  MenuButton(
                    icon: Icons.text_snippet_rounded,
                    label: 'Criar \n publicação',
                    onTap: () {
                      GoRouter.of(context).push("/postPage");
                      Navigator.of(context).pop();
                    },
                  ),
                  MenuButton(
                    icon: Icons.receipt_long_sharp,
                    label: 'Criar \n nota fiscal',
                    onTap: () {
                      GoRouter.of(context).push("/notaFiscalPage");
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: ConstantsColors.whiteShade700,
            borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
          ),
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ConstantsColors.greyShade600,
                      width: 1,
                    ),
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.only(bottom: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Sair',
                        style: const TextStyle(
                          fontSize: 16,
                          color: ConstantsColors.blueShade900,
                        ).merge(TextStylesConstants.kinterSemiBold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 19),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tem certeza que deseja sair?',
                    style: TextStyle(
                      fontSize: 16,
                      color: ConstantsColors.blueShade900.withOpacity(0.7),
                    ).merge(TextStylesConstants.kinterRegular),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstantsColors.whiteShade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                color: ConstantsColors.blueShade900),
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: const TextStyle(
                            color: ConstantsColors.blueShade900,
                            fontSize: 16,
                          ).merge(TextStylesConstants.kpoppinsMedium),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstantsColors.blueShade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Sim, sair',
                          style: const TextStyle(
                            color: ConstantsColors.whiteShade900,
                            fontSize: 16,
                          ).merge(TextStylesConstants.kpoppinsMedium),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
