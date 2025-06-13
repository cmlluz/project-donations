import 'package:appdonationsgestor/pages/search_pages/search_page.dart';
import 'package:appdonationsgestor/pages/profile_pages/institution_profile_page.dart';
import 'package:appdonationsgestor/pages/item_edit_page.dart';
import 'package:appdonationsgestor/pages/item_post_page.dart';
import 'package:appdonationsgestor/pages/login_page.dart';
import 'package:appdonationsgestor/pages/post_page.dart';
import 'package:appdonationsgestor/resources/root_page.dart';
import 'package:appdonationsgestor/pages/register_pages/user_register_Page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdonationsgestor/pages/user_type.dart';
import 'package:appdonationsgestor/pages/register_pages/institution_register_page.dart';
import 'package:appdonationsgestor/pages/register_pages/manager_register_page.dart';
import 'package:appdonationsgestor/pages/forgot_password_page.dart';
import 'package:appdonationsgestor/pages/register_pages/finalize_registration_page.dart';
import 'package:appdonationsgestor/pages/favorites_page.dart';
import 'package:appdonationsgestor/pages/profile_pages/manager_profile_page.dart';
import 'package:appdonationsgestor/pages/settings_pages/remove_account_page.dart';
import 'package:appdonationsgestor/pages/settings_pages/edit_profile_page.dart';

class RouteNames {
  static const String legalEntitiesLogin = "legalEntitiesLogin";
  static const String searchPage = "search_page";
  static const String itemPostPage = "itemPostPage";
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
  static const String forgotPasswordPage = "forgotPasswordPage";
  static const String finalizeRegistrationPage = "finalizeRegistrationPage";
  static const String favoritesPage = "favoritesPage";
  static const String managerProfilePage = "managerProfilePage";
  static const String removeAccountPage = "removeAccountPage";
  static const String editProfilePage = "editProfilePage";
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
          path: '/itemPostPage',
          name: RouteNames.itemPostPage,
          pageBuilder: (context, state) {
            return MaterialPage(
              child: ItemPostPage(),
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
          },
        ),
        GoRoute(
          path: '/forgotPasswordPage',
          name: RouteNames.forgotPasswordPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: ForgotPasswordPage(),
            );
          },
        ),
        GoRoute(
          path: '/finalizeRegistrationPage',
          name: RouteNames.finalizeRegistrationPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: FinalizeRegistrationPage(),
            );
          },
        ),
        GoRoute(
          path: '/favoritesPage',
          name: RouteNames.favoritesPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: FavoritesPage(),
            );
          },
        ),
        GoRoute(
            path: '/managerProfilePage',
            name: RouteNames.managerProfilePage,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: ManagerProfilePage(),
              );
            }),
        GoRoute(
          path: '/removeAccountPage',
          name: RouteNames.removeAccountPage,
          pageBuilder: (context, state) => const MaterialPage(
            child: RemoveAccountPage(),
          ),
        ),
        GoRoute(
          path: '/editProfilePage',
          name: RouteNames.editProfilePage,
          pageBuilder: (context, state) => const MaterialPage(
            child: EditProfilePage(),
          ),
        ),
      ],
    );
  }
}
