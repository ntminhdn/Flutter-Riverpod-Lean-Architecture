import '../index.dart';

ErrorSeverity convertStringToErrorSeverity(Object? value) {
  return switch (value) {
    'info' => ErrorSeverity.INFO,
    'warning' => ErrorSeverity.WARNING,
    'error' => ErrorSeverity.ERROR,
    'none' => ErrorSeverity.NONE,
    _ => ErrorSeverity.WARNING,
  };
}
