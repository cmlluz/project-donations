import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw FirebaseAuthException(
          code: e.code,
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

    // PEGA USUÁRIO ATUALIZADO
    final updatedUser = firebaseAuth.currentUser;

    print(updatedUser?.displayName);

    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
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
      // LOGIN EMAIL/SENHA
      if (providers.contains('password')) {
        if (email == null || password == null || password.isEmpty) {
          throw FirebaseAuthException(
            code: 'missing-credentials',
            message: 'Senha obrigatória para excluir a conta.',
          );
        }

        final credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );

        await user.reauthenticateWithCredential(
          credential,
        );
      } else if (providers.contains('google.com')) {
        final GoogleSignIn googleSignIn = GoogleSignIn();

        // FORÇA ESCOLHER CONTA NOVAMENTE
        await googleSignIn.signOut();

        final googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          throw FirebaseAuthException(
            code: 'google-sign-in-cancelled',
            message: 'Login com Google cancelado.',
          );
        }

        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await user.reauthenticateWithCredential(
          credential,
        );
      }

      await user.delete();

      await signOut();
    } on FirebaseAuthException catch (e) {
      // SENHA ERRADA
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception('Senha incorreta.');
      }

      if (e.code == 'google-sign-in-cancelled') {
        throw Exception(
          'Confirmação com Google cancelada.',
        );
      }

      if (e.code == 'requires-recent-login') {
        throw Exception(
          'Faça login novamente para continuar.',
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
}
