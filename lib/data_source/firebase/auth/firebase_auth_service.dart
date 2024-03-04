import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../index.dart';

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>(
  (ref) => getIt.get<FirebaseAuthService>(),
);

@LazySingleton()
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user.user == null) {
        throw AppFirebaseAuthException(
          kind: AppFirebaseAuthExceptionKind.userDoesNotExist,
        );
      }

      return user.user!.uid;
    } on FirebaseAuthException catch (e) {
      Log.e('error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'invalid-email':
          throw AppFirebaseAuthException(
            kind: AppFirebaseAuthExceptionKind.invalidEmail,
          );
        default:
          throw AppFirebaseAuthException(
            kind: AppFirebaseAuthExceptionKind.invalidLoginCredentials,
          );
      }
    }
  }

  Future<String> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user.user == null) {
        throw AppFirebaseAuthException(
          kind: AppFirebaseAuthExceptionKind.userDoesNotExist,
        );
      }

      return user.user!.uid;
    } on FirebaseAuthException catch (e) {
      Log.e('error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'email-already-in-use':
          throw AppFirebaseAuthException(
            kind: AppFirebaseAuthExceptionKind.usernameAlreadyInUse,
          );
        default:
          throw AppFirebaseAuthException(
            kind: AppFirebaseAuthExceptionKind.unknown,
          );
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'requires-recent-login':
          throw AppFirebaseAuthException(
            kind: AppFirebaseAuthExceptionKind.requiresRecentLogin,
          );
        default:
          throw AppFirebaseAuthException(
            kind: AppFirebaseAuthExceptionKind.unknown,
          );
      }
    }
  }
}
