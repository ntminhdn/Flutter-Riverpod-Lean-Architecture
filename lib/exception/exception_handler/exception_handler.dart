import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../index.dart';

final exceptionHandlerProvider = Provider<ExceptionHandler>(
  (ref) => ExceptionHandler(
    ref,
  ),
);

class ExceptionHandler {
  const ExceptionHandler(
    this._ref,
  );

  final Ref _ref;

  Future<void> handleException(AppException appException) async {
    if (appException.recordError) {
      await _ref.crashlyticsHelper.recordError(
        exception: appException,
        stack: StackTrace.current,
        reason: appException.message,
      );
    }

    Log.e('handleException: $appException');

    switch (appException.action) {
      case AppExceptionAction.showSnackBar:
        _ref.nav.showSnackBar(CommonPopup.errorSnackBar(appException.message));
        break;
      case AppExceptionAction.showDialog:
        await _ref.nav.showDialog(
          CommonPopup.errorDialog(appException.message),
        );
        break;
      case AppExceptionAction.showDialogWithRetry:
        await _ref.nav.showDialog(
          CommonPopup.errorWithRetryDialog(
            message: appException.message,
            onRetryPressed: () async {
              await appException.onRetry?.call();
            },
          ),
        );
        break;
      case AppExceptionAction.showForceLogoutDialog:
        await _ref.nav.showDialog(
          CommonPopup.errorDialog(appException.message),
        );
        try {
          await _ref.sharedViewModel.forceLogout();
        } catch (e) {
          Log.e('force logout error: $e');
          await _ref.nav.replaceAll([const LoginRoute()]);
        }
        break;
      case AppExceptionAction.showNonCancelableDialog:
        await _ref.nav.showDialog(
          CommonPopup.errorDialog(
            appException.message,
          ),
          barrierDismissible: false,
          canPop: false,
        );
        break;
      case AppExceptionAction.showMaintenanceDialog:
        await _ref.nav.showDialog(
          CommonPopup.maintenanceModeDialog(
            message: appException.message,
            time: appException.message,
          ),
          barrierDismissible: false,
          canPop: false,
        );
        break;
      case AppExceptionAction.doNothing:
        break;
    }
  }
}
