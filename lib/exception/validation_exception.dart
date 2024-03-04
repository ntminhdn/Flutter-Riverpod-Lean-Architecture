import '../index.dart';

class ValidationException extends AppException {
  ValidationException({
    required this.kind,
    super.rootException,
    super.onRetry,
  }) : super();

  final ValidationExceptionKind kind;

  @override
  String toString() {
    return 'ValidationException(kind: $kind, ${super.toString()})';
  }

  @override
  AppExceptionAction get action => AppExceptionAction.doNothing;

  @override
  String get message => switch (kind) {
        ValidationExceptionKind.invalidEmail => l10n.invalidEmail,
        ValidationExceptionKind.invalidPassword => l10n.invalidPassword,
        ValidationExceptionKind.passwordsDoNotMatch => l10n.passwordsAreNotMatch,
      };
}

enum ValidationExceptionKind {
  invalidEmail,
  invalidPassword,
  passwordsDoNotMatch,
}
