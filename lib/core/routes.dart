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
import 'package:appdonationsgestor/pages/settings_pages/delete_account_pages/delete_account_page.dart';
import 'package:appdonationsgestor/pages/settings_pages/delete_account_pages/confirm_deletion_page.dart';
import 'package:appdonationsgestor/pages/settings_pages/delete_account_pages/delete_feedback_page.dart';
import 'package:appdonationsgestor/pages/settings_pages/edit_profile_page.dart';
import 'package:appdonationsgestor/pages/settings_pages/notifications_page.dart';
import 'package:appdonationsgestor/pages/settings_pages/link_manager_page.dart';
import 'package:appdonationsgestor/pages/hystory_page.dart';
import 'package:appdonationsgestor/pages/post_detail_page.dart';
import 'package:appdonationsgestor/pages/register_pages/registration_confirmed.dart';
import 'package:appdonationsgestor/pages/campaign_pages/publish_campaign.dart';
import 'package:appdonationsgestor/pages/nota_fiscal_page.dart';
import 'package:appdonationsgestor/pages/feedback_page.dart';
import 'package:appdonationsgestor/models/post_model.dart';
import 'package:appdonationsgestor/pages/pending_requests_page.dart';

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
  static const String deleteAccountPage = "deleteAccountPage";
  static const String confirmDeletionPage = "confirmDeletionPage";
  static const String deleteFeedbackPage = "deleteFeedbackPage";
  static const String editProfilePage = "editProfilePage";
  static const String hystoryPage = "hystoryPage";
  static const String postDetailPage = "postDetailPage";
  static const String confirmedRegistration = "confirmedRegistration";
  static const String notaFiscalPage = "notaFiscalPage";
  static const String feedbackPage = "feedback";
  static const String notificationsPage = "notificationsPage";
  static const String linkManagerPage = "linkManagerPage";
  static const String publishCampaign = "publishCampaign";
  static const String pendingRequests = "pendingRequests";
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
          path: '/pendingRequests',
          name: RouteNames.pendingRequests,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: PendingRequestsPage(),
            );
          },
        ),
        GoRoute(
          path: '/itemPostPage',
          name: RouteNames.itemPostPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: ItemPostPage(),
            );
          },
        ),
        GoRoute(
          path: '/institutionProfilePage',
          name: RouteNames.institutionProfilePage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: InstitutionProfilePage(
                userId: '',
                userName: 'Usuário',
                userEmail: '',
                userImageUrl: '',
              ),
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
          pageBuilder: (context, state) => const MaterialPage(
            child: UserRegisterPage(),
          ),
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
              child: ForgotPasswordPage(
                email: '',
              ),
            );
          },
        ),
        GoRoute(
          path: '/finalizeRegistrationPage',
          name: RouteNames.finalizeRegistrationPage,
          pageBuilder: (context, state) => const MaterialPage(
            child: FinalizeRegistrationPage(),
          ),
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
          },
        ),
        GoRoute(
          path: '/deleteAccountPage',
          name: RouteNames.deleteAccountPage,
          pageBuilder: (context, state) => const MaterialPage(
            child: DeleteAccountPage(),
          ),
        ),
        GoRoute(
          path: '/confirmDeletionPage',
          name: RouteNames.confirmDeletionPage,
          pageBuilder: (context, state) => const MaterialPage(
            child: ConfirmDeletionPage(),
          ),
        ),
        GoRoute(
          path: '/deleteFeedbackPage',
          name: RouteNames.deleteFeedbackPage,
          pageBuilder: (context, state) => const MaterialPage(
            child: DeleteFeedbackPage(),
          ),
        ),
        GoRoute(
          path: '/editProfilePage',
          name: RouteNames.editProfilePage,
          pageBuilder: (context, state) => const MaterialPage(
            child: EditProfilePage(),
          ),
        ),
        GoRoute(
          path: '/hystoryPage',
          name: RouteNames.hystoryPage,
          pageBuilder: (context, state) => const MaterialPage(
            child: HystoryPage(),
          ),
        ),
        GoRoute(
          path: '/postDetailPage',
          name: RouteNames.postDetailPage,
          pageBuilder: (context, state) {
            final postData = state.extra as PostModel?;
            final post = postData ??
                PostModel(
                  id: '0',
                  title: 'Post não encontrado',
                  description: 'Não foi possível carregar os dados do post.',
                  imageUrl: 'assets/instituicao.png',
                  location: 'Salvador, Bahia',
                  institution: 'Sistema',
                  institutionImageUrl: 'assets/instituicao.png',
                  createdAt: DateTime.now(),
                  category: 'outros',
                );

            return MaterialPage(
              child: PostDetailPage(post: post),
            );
          },
        ),
        GoRoute(
          path: '/confirmedRegistration',
          name: RouteNames.confirmedRegistration,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: RegistrationConfirmedPage(),
            );
          },
        ),
        GoRoute(
          path: '/notaFiscalPage',
          name: RouteNames.notaFiscalPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: NotaFiscalPage(),
            );
          },
        ),
        GoRoute(
          path: '/notificationsPage',
          name: RouteNames.notificationsPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: NotificationsPage(),
            );
          },
        ),
        GoRoute(
          path: '/publishCampaign',
          name: RouteNames.publishCampaign,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: PublishCampaignPage(),
            );
          },
        ),
        GoRoute(
          path: '/linkManagerPage',
          name: RouteNames.linkManagerPage,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: LinkManagerPage(),
            );
          },
        ),
        GoRoute(
          path: '/feedback',
          name: RouteNames.feedbackPage,
          pageBuilder: (context, state) {
            final String? text1 = state.uri.queryParameters['text1'];
            return MaterialPage(
              child: FeedbackPage(text1: text1 ?? 'Publicação'),
            );
          },
        ),
      ],
    );
  }
}
