import '../index.dart';

class RemoteException extends AppException {
  RemoteException({
    required this.kind,
    this.dioStatusCode,
    this.serverError,
    super.rootException,
    super.onRetry,
  }) : super();

  final RemoteExceptionKind kind;
  final int? dioStatusCode;
  final ServerError? serverError;

  @override
  String get message => switch (kind) {
        RemoteExceptionKind.badCertificate => l10n.unknownException('UE-01'),
        RemoteExceptionKind.noInternet => l10n.noInternetException,
        RemoteExceptionKind.network => l10n.canNotConnectToHost,
        RemoteExceptionKind.userNotFound ||
        RemoteExceptionKind.otherServerDefined =>
          generalServerMessage ?? l10n.unknownException('UE-02'),
        RemoteExceptionKind.serverUndefined => l10n.unknownException('UE-03'),
        RemoteExceptionKind.timeout => l10n.timeoutException,
        RemoteExceptionKind.cancellation => l10n.unknownException('UE-04'),
        RemoteExceptionKind.unknown => l10n.unknownException('UE-05'),
        RemoteExceptionKind.refreshTokenFailed => l10n.tokenExpired,
        RemoteExceptionKind.decodeError => l10n.unknownException('UE-06'),
        RemoteExceptionKind.serverMaintenance => l10n.maintenanceTitle,
      };

  @override
  AppExceptionAction get action {
    return switch (kind) {
      RemoteExceptionKind.serverMaintenance => AppExceptionAction.showMaintenanceDialog,
      RemoteExceptionKind.refreshTokenFailed ||
      RemoteExceptionKind.userNotFound =>
        AppExceptionAction.showForceLogoutDialog,
      RemoteExceptionKind.otherServerDefined ||
      RemoteExceptionKind.serverUndefined ||
      RemoteExceptionKind.badCertificate ||
      RemoteExceptionKind.decodeError ||
      RemoteExceptionKind.cancellation ||
      RemoteExceptionKind.unknown =>
        AppExceptionAction.showDialog,
      RemoteExceptionKind.noInternet ||
      RemoteExceptionKind.network ||
      RemoteExceptionKind.timeout =>
        AppExceptionAction.showDialogWithRetry,
    };
  }

  @override
  bool get isForcedErrorToHandle =>
      kind == RemoteExceptionKind.refreshTokenFailed ||
      kind == RemoteExceptionKind.serverMaintenance;

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
      dioStatusCode: $dioStatusCode,
      serverError: $serverError,
      rootException: $rootException,
      generalServerMessage: $generalServerMessage,
      generalServerStatusCode: $generalServerStatusCode,
      generalServerErrorId: $generalServerErrorId,
      isForcedErrorToHandle: $isForcedErrorToHandle,
      stackTrace: ${rootException is Error ? (rootException as Error).stackTrace : ''}
)''';
  }
}

enum RemoteExceptionKind {
  /// errors that can retry
  noInternet,
  timeout,
  network, // host not found, cannot connect to host, SocketException

  /// server has defined response like 4xx errors
  otherServerDefined,

  /// specific serverDefined errors need to be handled in separate ways
  refreshTokenFailed,
  serverMaintenance,
  userNotFound,

  /// server has not defined response like 5xx errors
  serverUndefined,

  /// Caused by an incorrect certificate as configured by [ValidateCertificate]
  badCertificate,

  /// error occurs when passing JSON
  decodeError,

  // other errors
  cancellation,
  unknown,
}
