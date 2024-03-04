import '../index.dart';

class RemoteException extends AppException {
  RemoteException({
    required this.kind,
    this.httpErrorCode,
    this.serverError,
    super.rootException,
    super.onRetry,
  }) : super();

  final RemoteExceptionKind kind;
  final int? httpErrorCode;
  final ServerError? serverError;

  @override
  String get message => switch (kind) {
        RemoteExceptionKind.badCertificate => l10n.unknownException('UE-01'),
        RemoteExceptionKind.noInternet => l10n.noInternetException,
        RemoteExceptionKind.network => l10n.canNotConnectToHost,
        RemoteExceptionKind.serverDefined => generalServerMessage ?? l10n.unknownException('UE-02'),
        RemoteExceptionKind.serverUndefined =>
          generalServerMessage ?? l10n.unknownException('UE-03'),
        RemoteExceptionKind.timeout => l10n.timeoutException,
        RemoteExceptionKind.cancellation => l10n.unknownException('UE-04'),
        RemoteExceptionKind.unknown => l10n.unknownException('UE-05'),
        RemoteExceptionKind.refreshTokenFailed => l10n.tokenExpired,
        RemoteExceptionKind.decodeError => l10n.unknownException('UE-06'),
      };

  @override
  AppExceptionAction get action {
    return switch (kind) {
      RemoteExceptionKind.refreshTokenFailed => AppExceptionAction.showDialogForceLogout,
      RemoteExceptionKind.serverDefined ||
      RemoteExceptionKind.serverUndefined =>
        AppExceptionAction.showDialog,
      RemoteExceptionKind.noInternet ||
      RemoteExceptionKind.network ||
      RemoteExceptionKind.timeout =>
        AppExceptionAction.showDialogWithRetry,
      _ => AppExceptionAction.doNothing,
    };
  }

  int get generalServerStatusCode =>
      serverError?.generalServerStatusCode ??
      serverError?.errors.firstOrNull?.serverStatusCode ??
      -1;

  String? get generalServerErrorId =>
      serverError?.generalServerErrorId ?? serverError?.errors.firstOrNull?.serverErrorId;

  String? get generalServerMessage =>
      serverError?.generalMessage ?? serverError?.errors.firstOrNull?.message;

  @override
  String toString() {
    return '''RemoteException(
      kind: $kind,
      message: $message,
      action: $action,
      httpErrorCode: $httpErrorCode,
      serverError: $serverError,
      rootException: $rootException,
      generalServerMessage: $generalServerMessage,
      generalServerStatusCode: $generalServerStatusCode,
      generalServerErrorId: $generalServerErrorId,
      stackTrace: ${rootException is Error ? (rootException as Error).stackTrace : ''}
)''';
  }
}

enum RemoteExceptionKind {
  noInternet,

  /// host not found, cannot connect to host, SocketException
  network,

  /// server has defined response
  serverDefined,

  /// server has not defined response
  serverUndefined,

  /// Caused by an incorrect certificate as configured by [ValidateCertificate]
  badCertificate,

  /// error occurs when passing JSON
  decodeError,

  refreshTokenFailed,
  timeout,
  cancellation,
  unknown,
}
