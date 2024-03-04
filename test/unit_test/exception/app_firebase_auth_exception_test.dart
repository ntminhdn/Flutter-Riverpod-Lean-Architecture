import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('message', () {
    test('when kind is AppFirebaseAuthExceptionKind.invalidEmail', () async {
      final result =
          AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.invalidEmail).message;
      expect(result, l10n.invalidEmail);
    });

    test('when kind is AppFirebaseAuthExceptionKind.userDoesNotExist', () async {
      final result =
          AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.userDoesNotExist).message;
      expect(result, l10n.userDoesNotExist);
    });

    test('when kind is AppFirebaseAuthExceptionKind.invalidLoginCredentials', () async {
      final result = AppFirebaseAuthException(
        kind: AppFirebaseAuthExceptionKind.invalidLoginCredentials,
      ).message;
      expect(result, l10n.invalidLoginCredentials);
    });

    test('when kind is AppFirebaseAuthExceptionKind.usernameAlreadyInUse', () async {
      final result =
          AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.usernameAlreadyInUse).message;
      expect(result, l10n.usernameAlreadyInUse);
    });

    test('when kind is AppFirebaseAuthExceptionKind.requiresRecentLogin', () async {
      final result =
          AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.requiresRecentLogin).message;
      expect(result, l10n.requiresRecentLogin);
    });

    test('when kind is AppFirebaseAuthExceptionKind.unknown', () async {
      final result = AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.unknown).message;
      expect(result, l10n.unknownException('FBA-001'));
    });
  });

  group('action', () {
    test('when kind is AppFirebaseAuthExceptionKind.invalidEmail', () async {
      final result =
          AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.invalidEmail).action;
      expect(result, AppExceptionAction.doNothing);
    });

    test('when kind is AppFirebaseAuthExceptionKind.userDoesNotExist', () async {
      final result =
          AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.userDoesNotExist).action;
      expect(result, AppExceptionAction.doNothing);
    });

    test('when kind is AppFirebaseAuthExceptionKind.invalidLoginCredentials', () async {
      final result = AppFirebaseAuthException(
        kind: AppFirebaseAuthExceptionKind.invalidLoginCredentials,
      ).action;
      expect(result, AppExceptionAction.doNothing);
    });

    test('when kind is AppFirebaseAuthExceptionKind.usernameAlreadyInUse', () async {
      final result =
          AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.usernameAlreadyInUse).action;
      expect(result, AppExceptionAction.doNothing);
    });

    test('when kind is AppFirebaseAuthExceptionKind.requiresRecentLogin', () async {
      final result =
          AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.requiresRecentLogin).action;
      expect(result, AppExceptionAction.doNothing);
    });

    test('when kind is AppFirebaseAuthExceptionKind.unknown', () async {
      final result = AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.unknown).action;
      expect(result, AppExceptionAction.doNothing);
    });
  });
}
