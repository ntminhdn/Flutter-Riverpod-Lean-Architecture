import 'package:flutter/material.dart';
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
        _showErrorSnackBar(appException.message);
        break;
      case AppExceptionAction.showDialog:
        await _showErrorDialog(message: appException.message);
        break;
      case AppExceptionAction.showDialogWithRetry:
        await _showErrorDialogWithRetry(
          message: appException.message,
          onRetryPressed: () async {
            await _ref.nav.pop();
            await appException.onRetry?.call();
          },
        );
        break;
      case AppExceptionAction.showDialogForceLogout:
        await _showErrorDialog(
          message: appException.message,
          forceLogout: true,
        );
        break;
      case AppExceptionAction.doNothing:
        break;
    }
  }

  void _showErrorSnackBar(String message) {
    _ref.nav.showSnackBar(CommonPopup.errorSnackBar(message));
  }

  Future<void> _showErrorDialog({
    required String message,
    bool forceLogout = false,
  }) async {
    await _ref.nav.showDialog(
      CommonPopup.errorDialog(message),
    );
    if (forceLogout) {
      try {
        await _ref.sharedViewModel.logout();
      } catch (e) {
        Log.e('force logout error: $e');
        await _ref.nav.replaceAll([const LoginRoute()]);
      }
    }
  }

  Future<void> _showErrorDialogWithRetry({
    required String message,
    required VoidCallback? onRetryPressed,
  }) async {
    await _ref.nav.showDialog(
      CommonPopup.errorWithRetryDialog(message: message, onRetryPressed: onRetryPressed),
    );
  }
}
