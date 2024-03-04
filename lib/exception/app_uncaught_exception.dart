import '../index.dart';

class AppUncaughtException extends AppException {
  AppUncaughtException({
    super.rootException,
    super.onRetry,
  }) : super();

  @override
  String toString() {
    return 'AppUncaughtException(${super.toString()})';
  }

  @override
  String get message => l10n.unknownException('UE-00');

  @override
  AppExceptionAction get action => AppExceptionAction.doNothing;
}
