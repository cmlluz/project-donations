import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart'; // Importar o ApiClient
import 'package:appdonationsgestor/services/api_services/auth_api_service.dart'; // Importar o novo serviço

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Instanciar o ApiClient e o AuthApiService
  final ApiClient _apiClient = ApiClient();
  late final AuthApiService _authApiService;

  AuthService() {
    // Inicializar o AuthApiService com a instância do ApiClient
    _authApiService = AuthApiService(_apiClient);
  }

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;
    if (user != null) {
      String? token = await user.getIdToken();
      print('--- FIREBASE TOKEN PARA POSTMAN ---');
      print(token);
      print('------------------------------------');
    }

    if (userCredential.user != null) {
      await _authApiService.syncUser(); // ATUALIZADO
    }
    return userCredential;
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      await _authApiService.syncUser(); // ATUALIZADO
    }

    return userCredential;
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({
    required String username,
  }) async {
    await currentUser!.updateDisplayName(username);
    await _authApiService.updateUser({"name": username}); // ATUALIZADO
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(credential);
    await _authApiService.deleteUser(); // ATUALIZADO
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: currentPassword);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      final userCredential = await firebaseAuth.signInWithCredential(cred);

      if (userCredential.user != null) {
        await _authApiService.syncUser(); // ATUALIZADO
      }

      return userCredential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserCredential?> loginWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ['public_profile', 'email']);

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      if (userCredential.user != null) {
        await _authApiService.syncUser(); // ATUALIZADO
      }

      return userCredential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
