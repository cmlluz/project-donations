import 'package:appdonationsgestor/pages/institution_page.dart';
import 'package:appdonationsgestor/pages/institution_profile_page.dart';
import 'package:appdonationsgestor/pages/item_edit_page.dart';
import 'package:appdonationsgestor/pages/item_register_page.dart';
import 'package:appdonationsgestor/pages/login_page.dart';
import 'package:appdonationsgestor/pages/popup_menu_state.dart';
import 'package:appdonationsgestor/pages/post_page.dart';
import 'package:appdonationsgestor/resources/root_page.dart';
import 'package:appdonationsgestor/pages/user_register_Page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/pages/user_type.dart';
import 'package:appdonationsgestor/pages/institution_register_page.dart';
import 'package:appdonationsgestor/pages/manager_register_page.dart';

class RouteNames {
  static const String legalEntitiesLogin = "legalEntitiesLogin";
  static const String institutionPage = "institution_page";
  static const String itemRegisterPage = "itemRegisterPage";
  static const String itemEditPage = "itemEditPage";
  static const String institutionProfilePage = "institutionProfilePage";
  static const String homePage = "homePage";
  static const String loginPage = "loginPage";
  static const String bottomBarState = "bottomBarState";
  static const String postPage = "postPage";
  static const String root = "root";
  static const String popupMenuState = "popupMenuState";
  static const String userRegisterPage = "userRegisterPage";
  static const String institutionRegisterPage = "institutionRegisterPage";
  static const String gestorRegisterPage = "gestorRegisterPage";
  static const String userTypePage = "userTypePage";
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
          name: RouteNames.institutionPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: InstitutionPage(),
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
        GoRoute(
          path: '/userRegisterPage',
          name: RouteNames.userRegisterPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: UserRegisterPage(),
            );
          },
        ),
        GoRoute(
          path: '/institutionRegisterPage',
          name: RouteNames.institutionRegisterPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: InstitutionRegisterPage(),
            );
          },
        ),
        GoRoute(
          path: '/gestorRegisterPage',
          name: RouteNames.gestorRegisterPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: ManagerRegisterPage(),
            );
          },
        ),
        GoRoute(
            path: '/userTypePage',
            name: RouteNames.userTypePage,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: UserType(),
              );
            }),
      ],
    );
  }
}
