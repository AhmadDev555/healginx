

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healginx/core/api_client/api_service_interface/i_api_service.dart';

class LoginRepository {

  final ApiService _apiService;
  LoginRepository({required ApiService apiService}) : _apiService = apiService;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  /// EMAIL + PASSWORD LOGIN
  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }


  /// REGISTER (EMAIL + PASSWORD)
  Future<User?> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name.trim());
      await credential.user?.reload();

      return _auth.currentUser ?? credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }
  /// GOOGLE LOGIN
  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) {
        throw "Google sign-in cancelled";
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      throw "Google login failed: $e";
    }
  }

  /// =========================
  /// LOGOUT
  /// =========================
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  /// =========================
  /// ERROR HANDLING
  /// =========================
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No user found for this email";
      case 'wrong-password':
        return "Wrong password";
      case 'email-already-in-use':
        return "Email already in use";
      case 'weak-password':
        return "Password is too weak";
      case 'invalid-email':
        return "Invalid email format";
      default:
        return "Authentication error: ${e.message}";
    }
  }
}
