import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:appdonationsgestor/services/api_services/api_client.dart';
import 'package:http/http.dart' as http;

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final exists = await userExists(email);

    if (!exists) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Usuário não encontrado.',
      );
    }

    try {
      return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw FirebaseAuthException(
          code: 'wrong-password',
          message: 'Senha incorreta.',
        );
      }

      rethrow;
    }
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
    String? name,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (name != null && name.trim().isNotEmpty) {
      await credential.user?.updateDisplayName(
        name.trim(),
      );

      await credential.user?.reload();
    }

    return credential;
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();

    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<void> updateUsername({
    required String username,
  }) async {
    await currentUser!.updateDisplayName(username);

    await currentUser!.reload();
  }

  Future<void> deleteAccount({
    String? email,
    String? password,
  }) async {
    final user = currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Usuário não encontrado.',
      );
    }

    final providers = user.providerData.map((e) => e.providerId);

    try {
      if (providers.contains('password') && password != null && email != null) {
        final credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);
      }

      final apiClient = ApiClient();
      final response = await apiClient.delete('users/me');

      if (response.statusCode != 204) {
        throw Exception(
          'Erro ao excluir usuário do banco.',
        );
      }

      await user.delete();

      await signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception('Senha incorreta.');
      }

      if (e.code == 'requires-recent-login') {
        throw Exception(
          'Sessão expirada. Por segurança, faça login novamente antes de excluir a conta.',
        );
      }

      rethrow;
    }
  }

  // ALTERAR SENHA
  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await currentUser!.reauthenticateWithCredential(
      credential,
    );

    await currentUser!.updatePassword(newPassword);

    await currentUser!.reload();
  }

  // LOGIN COM GOOGLE
  Future<Map<String, dynamic>?> loginWithGoogle(BuildContext context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (userCredential.user != null &&
          (userCredential.user!.displayName == null ||
              userCredential.user!.displayName!.isEmpty)) {
        await userCredential.user!.updateDisplayName(
          googleUser.displayName ?? '',
        );

        await userCredential.user!.reload();
      }

      return {'isNewUser': isNewUser};
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<bool> userExists(String email) async {
    final response = await http.get(
      Uri.parse(
        'http://10.0.2.2:8080/api/users/exists?email=$email',
      ),
    );

    return response.body == 'true';
  }

  Future<bool> verifyPassword(String email, String password) async {
    final user = currentUser;
    if (user == null) return false;
    if (password.isEmpty) return false;

    try {
      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        throw Exception(
          'Ops, muitas tentativas seguidas! Por segurança, aguarde um momento antes de tentar de novo',
        );
      }

      return false;
    } catch (_) {
      return false;
    }
  }
}
