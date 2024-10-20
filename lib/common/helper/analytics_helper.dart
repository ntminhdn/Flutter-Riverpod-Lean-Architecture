import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../index.dart';

final analyticsHelperProvider = Provider<AnalyticsHelper>(
  (ref) => getIt.get<AnalyticsHelper>(),
);

@LazySingleton()
class AnalyticsHelper {
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) {
    return FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
  }

  Future<void> logScreenView({
    required String screenName,
    Map<String, Object>? parameters,
  }) {
    return FirebaseAnalytics.instance.logScreenView(screenName: screenName, parameters: parameters);
  }

  Future<void> setUserId(String userId) {
    return FirebaseAnalytics.instance.setUserId(id: userId);
  }

  Future<void> setUserProperties(Map<String, String?> properties) async {
    await Future.wait(properties.entries.map((e) async {
      await FirebaseAnalytics.instance.setUserProperty(name: e.key, value: e.value);
    }));
  }

  Future<void> reset() {
    return FirebaseAnalytics.instance.resetAnalyticsData();
  }
}
