import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('message', () {
    test('when kind is RemoteExceptionKind.badCertificate', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.badCertificate).message,
        l10n.unknownException('UE-01'),
      );
    });

    test('when kind is RemoteExceptionKind.noInternet', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.noInternet).message,
        l10n.noInternetException,
      );
    });

    test('when kind is RemoteExceptionKind.network', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.network).message,
        l10n.canNotConnectToHost,
      );
    });

    test('when kind is RemoteExceptionKind.serverDefined', () async {
      expect(
        RemoteException(
          kind: RemoteExceptionKind.otherServerDefined,
          serverError: const ServerError(
            errors: [ServerErrorDetail(message: 'error')],
            generalMessage: 'general message',
          ),
        ).message,
        'general message',
      );
    });

    test('when kind is RemoteExceptionKind.serverUndefined', () async {
      expect(
        RemoteException(
          kind: RemoteExceptionKind.serverUndefined,
          serverError: null,
        ).message,
        l10n.unknownException('UE-03'),
      );
    });

    test('when kind is RemoteExceptionKind.timeout', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.timeout).message,
        l10n.timeoutException,
      );
    });

    test('when kind is RemoteExceptionKind.cancellation', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.cancellation).message,
        l10n.unknownException('UE-04'),
      );
    });

    test('when kind is RemoteExceptionKind.unknown', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.unknown).message,
        l10n.unknownException('UE-05'),
      );
    });

    test('when kind is RemoteExceptionKind.refreshTokenFailed', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.refreshTokenFailed).message,
        l10n.tokenExpired,
      );
    });

    test('when kind is RemoteExceptionKind.decodeError', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.decodeError).message,
        l10n.unknownException('UE-06'),
      );
    });
  });

  group('action', () {
    test('when kind is RemoteExceptionKind.refreshTokenFailed', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.refreshTokenFailed).action,
        AppExceptionAction.showForceLogoutDialog,
      );
    });

    test('when kind is RemoteExceptionKind.serverDefined', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.otherServerDefined).action,
        AppExceptionAction.showDialog,
      );
    });

    test('when kind is RemoteExceptionKind.serverUndefined', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.serverUndefined).action,
        AppExceptionAction.showDialog,
      );
    });

    test('when kind is RemoteExceptionKind.noInternet', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.noInternet).action,
        AppExceptionAction.showDialogWithRetry,
      );
    });

    test('when kind is RemoteExceptionKind.network', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.network).action,
        AppExceptionAction.showDialogWithRetry,
      );
    });

    test('when kind is RemoteExceptionKind.timeout', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.timeout).action,
        AppExceptionAction.showDialogWithRetry,
      );
    });

    test('when kind is RemoteExceptionKind.cancellation', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.cancellation).action,
        AppExceptionAction.showDialog,
      );
    });

    test('when kind is RemoteExceptionKind.unknown', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.unknown).action,
        AppExceptionAction.showDialog,
      );
    });
  });

  group('generalServerStatusCode', () {
    test('when serverError is null', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.unknown).generalServerStatusCode,
        -1,
      );
    });

    test('when generalServerStatusCode is not null', () async {
      expect(
        RemoteException(
          kind: RemoteExceptionKind.unknown,
          serverError: const ServerError(
            generalServerStatusCode: 400,
            errors: [ServerErrorDetail(serverStatusCode: 500)],
          ),
        ).generalServerStatusCode,
        400,
      );
    });

    test('when generalServerStatusCode is null and errors is not empty', () async {
      expect(
        RemoteException(
          kind: RemoteExceptionKind.unknown,
          serverError: const ServerError(
            errors: [
              ServerErrorDetail(serverStatusCode: 500),
              ServerErrorDetail(serverStatusCode: 404),
            ],
          ),
        ).generalServerStatusCode,
        500,
      );
    });

    test('when generalServerStatusCode is null and errors is empty', () async {
      expect(
        RemoteException(
          kind: RemoteExceptionKind.unknown,
          serverError: const ServerError(),
        ).generalServerStatusCode,
        -1,
      );
    });
  });

  group('generalServerErrorId', () {
    test('when serverError is null', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.unknown).generalServerErrorId,
        null,
      );
    });

    test('when generalServerErrorId is not null', () async {
      expect(
        RemoteException(
          kind: RemoteExceptionKind.unknown,
          serverError: const ServerError(
            generalServerErrorId: 'id',
            errors: [ServerErrorDetail(serverErrorId: 'id')],
          ),
        ).generalServerErrorId,
        'id',
      );
    });

    test('when generalServerErrorId is null and errors is not empty', () async {
      expect(
        RemoteException(
          kind: RemoteExceptionKind.unknown,
          serverError: const ServerError(
            errors: [
              ServerErrorDetail(serverErrorId: 'id'),
              ServerErrorDetail(serverErrorId: 'id2'),
            ],
          ),
        ).generalServerErrorId,
        'id',
      );
    });

    test('when generalServerErrorId is null and errors is empty', () async {
      expect(
        RemoteException(
          kind: RemoteExceptionKind.unknown,
          serverError: const ServerError(),
        ).generalServerErrorId,
        null,
      );
    });
  });

  group('generalServerMessage', () {
    test('when serverError is null', () async {
      expect(
        RemoteException(kind: RemoteExceptionKind.unknown).generalServerMessage,
        null,
      );
    });

    test('when generalServerMessage is not null', () async {
      expect(
        RemoteException(
          kind: RemoteExceptionKind.unknown,
          serverError: const ServerError(
            generalMessage: 'message',
            errors: [ServerErrorDetail(message: 'message')],
          ),
        ).generalServerMessage,
        'message',
      );
    });

    test('when generalServerMessage is null and errors is not empty', () async {
      expect(
        RemoteException(
          kind: RemoteExceptionKind.unknown,
          serverError: const ServerError(
            errors: [
              ServerErrorDetail(message: 'message'),
              ServerErrorDetail(message: 'message2'),
            ],
          ),
        ).generalServerMessage,
        'message',
      );
    });

    test('when generalServerMessage is null and errors is empty', () async {
      expect(
        RemoteException(
          kind: RemoteExceptionKind.unknown,
          serverError: const ServerError(),
        ).generalServerMessage,
        null,
      );
    });
  });
}
