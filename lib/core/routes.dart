import 'package:appdonationsgestor/pages/search_page.dart';
import 'package:appdonationsgestor/pages/institution_profile_page.dart';
import 'package:appdonationsgestor/pages/item_edit_page.dart';
import 'package:appdonationsgestor/pages/item_register_page.dart';
import 'package:appdonationsgestor/pages/login_page.dart';
import 'package:appdonationsgestor/pages/popup_menu_state.dart';
import 'package:appdonationsgestor/pages/post_page.dart';
import 'package:appdonationsgestor/resources/root_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteNames {
  static const String legalEntitiesLogin = "legalEntitiesLogin";
  static const String searchPage = "search_page";
  static const String itemRegisterPage = "itemRegisterPage";
  static const String itemEditPage = "itemEditPage";
  static const String institutionProfilePage = "institutionProfilePage";
  static const String homePage = "homePage";
  static const String loginPage = "loginPage";
  static const String bottomBarState = "bottomBarState";
  static const String postPage = "postPage";
  static const String root = "root";
  static const String popupMenuState = "popupMenuState";
}

class AppRountersConfiguration {
  static GoRouter returnRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.loginPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: LoginPage(),
            );
          },
        ),
        GoRoute(
          path: '/root',
          name: RouteNames.root,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: RootPage(),
            );
          },
        ),
        GoRoute(
          path: '/itemRegisterPage',
          name: RouteNames.itemRegisterPage,
          pageBuilder: (context, state) {
            return MaterialPage(
              child: ItemRegisterPage(),
            );
          },
        ),
        GoRoute(
          path: '/institutionProfilePage',
          name: RouteNames.institutionProfilePage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: InstitutionProfilePage(),
            );
          },
        ),
        GoRoute(
          path: '/intitution_page',
          name: RouteNames.searchPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: SearchPage(),
            );
          },
        ),
        GoRoute(
          path: '/item_edit_page',
          name: RouteNames.itemEditPage,
          pageBuilder: (context, state) {
            return MaterialPage(
              child: ItemEditPage(),
            );
          },
        ),
        GoRoute(
          path: '/popupMenuState',
          name: RouteNames.popupMenuState,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: PopupMenuState(),
            );
          },
        ),
        GoRoute(
          path: '/postPage',
          name: RouteNames.postPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: PostPage(),
            );
          },
        ),
      ],
    );
  }
}
