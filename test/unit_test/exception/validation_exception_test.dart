import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('message', () {
    test('when kind is ValidationExceptionKind.invalidEmail', () async {
      final result = ValidationException(kind: ValidationExceptionKind.invalidEmail).message;
      expect(result, l10n.invalidEmail);
    });

    test('when kind is ValidationExceptionKind.invalidPassword', () async {
      final result = ValidationException(kind: ValidationExceptionKind.invalidPassword).message;
      expect(result, l10n.invalidPassword);
    });

    test('when kind is ValidationExceptionKind.passwordsAreNotMatch', () async {
      final result = ValidationException(kind: ValidationExceptionKind.passwordsDoNotMatch).message;
      expect(result, l10n.passwordsAreNotMatch);
    });
  });

  group('action', () {
    test('when kind is ValidationExceptionKind.invalidEmail', () async {
      final result = ValidationException(kind: ValidationExceptionKind.invalidEmail).action;
      expect(result, AppExceptionAction.doNothing);
    });

    test('when kind is ValidationExceptionKind.invalidPassword', () async {
      final result = ValidationException(kind: ValidationExceptionKind.invalidPassword).action;
      expect(result, AppExceptionAction.doNothing);
    });

    test('when kind is ValidationExceptionKind.passwordsAreNotMatch', () async {
      final result = ValidationException(kind: ValidationExceptionKind.passwordsDoNotMatch).action;
      expect(result, AppExceptionAction.doNothing);
    });
  });
}
