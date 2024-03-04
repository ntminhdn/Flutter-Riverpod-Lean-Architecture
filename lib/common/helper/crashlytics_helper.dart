import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../index.dart';

final crashlyticsHelperProvider = Provider<CrashlyticsHelper>(
  (ref) => getIt.get<CrashlyticsHelper>(),
);

@LazySingleton()
class CrashlyticsHelper {
  Future<void> recordError({
    dynamic exception,
    dynamic reason,
    bool? printDetails,
    StackTrace? stack,
    bool fatal = false,
    Iterable<Object> information = const [],
  }) {
    return FirebaseCrashlytics.instance.recordError(
      exception,
      stack,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: fatal,
    );
  }
}
