import '../app_exception.dart';

abstract class AppExceptionMapper<T extends AppException> {
  T map(Object? exception);
}
