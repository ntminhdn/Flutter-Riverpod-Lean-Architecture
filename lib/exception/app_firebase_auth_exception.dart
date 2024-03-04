import '../index.dart';

class AppFirebaseAuthException extends AppException {
  AppFirebaseAuthException({
    required this.kind,
    super.rootException,
    super.onRetry,
  }) : super();

  final AppFirebaseAuthExceptionKind kind;

  @override
  String toString() {
    return 'AppFirebaseAuthExceptionKind(kind: $kind, ${super.toString()})';
  }

  @override
  String get message => switch (kind) {
        AppFirebaseAuthExceptionKind.invalidEmail => l10n.invalidEmail,
        AppFirebaseAuthExceptionKind.userDoesNotExist => l10n.userDoesNotExist,
        AppFirebaseAuthExceptionKind.invalidLoginCredentials => l10n.invalidLoginCredentials,
        AppFirebaseAuthExceptionKind.usernameAlreadyInUse => l10n.usernameAlreadyInUse,
        AppFirebaseAuthExceptionKind.requiresRecentLogin => l10n.requiresRecentLogin,
        AppFirebaseAuthExceptionKind.unknown => l10n.unknownException('FBA-001'),
      };

  @override
  AppExceptionAction get action => AppExceptionAction.doNothing;
}

enum AppFirebaseAuthExceptionKind {
  invalidEmail,
  invalidLoginCredentials,
  userDoesNotExist,
  usernameAlreadyInUse,
  requiresRecentLogin,
  unknown
}
