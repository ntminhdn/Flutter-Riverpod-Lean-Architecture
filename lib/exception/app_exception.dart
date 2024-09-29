abstract class AppException implements Exception {
  AppException({
    this.onRetry,
    this.rootException,
  });

  final Object? rootException;
  Future<void> Function()? onRetry;

  String get message;

  AppExceptionAction get action;

  bool get recordError => false;

  bool get isForcedErrorToHandle => false;

  @override
  String toString() {
    return 'rootException: $rootException, message: $message, action: $action';
  }
}

enum AppExceptionAction {
  showSnackBar,
  showDialog,
  showDialogWithRetry,
  showForceLogoutDialog,
  showNonCancelableDialog,
  showMaintenanceDialog,
  doNothing,
}
