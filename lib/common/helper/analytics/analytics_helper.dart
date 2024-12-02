import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../index.dart';

final analyticsHelperProvider = Provider<AnalyticsHelper>(
  (ref) => AnalyticsHelper(ref: ref),
);

class AnalyticsHelper {
  AnalyticsHelper({
    FirebaseAnalytics? firebaseAnalytics,
    required this.ref,
  }) : _firebaseAnalytics = firebaseAnalytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _firebaseAnalytics;
  final Ref ref;

  Future<Map<String, Object>> get _commonParameters async => {
        ParameterConstants.userId: await ref.read(deviceHelperProvider).deviceId,
      };

  Future<void> logEvent(NormalEvent event) async {
    final parameters = {
      ...await _commonParameters,
      ...event.parameter?.parameters ?? {},
    };
    if (kDebugMode) {
      Log.d(
        'logEvent: ${event.fullEventName},\nparameters: ${Log.prettyJson(parameters)}',
        color: LogColor.cyan,
        mode: LogMode.logEventOnly,
      );
    }
    return _firebaseAnalytics.logEvent(
      name: event.fullEventName,
      parameters: parameters,
    );
  }

  Future<void> logScreenView(ScreenViewEvent screenViewEvent) async {
    final parameters = {
      ...await _commonParameters,
      ...screenViewEvent.parameter?.parameters ?? {},
    };
    if (kDebugMode) {
      Log.d(
        'logScreenView: ${screenViewEvent.screenName},\nkey: ${screenViewEvent.fullKey}\nparameters: ${Log.prettyJson(parameters)}',
        color: LogColor.cyan,
        mode: LogMode.logEventOnly,
      );
    }
    return _firebaseAnalytics.logScreenView(
      screenName: screenViewEvent.screenName.screenName,
      screenClass: screenViewEvent.screenName.screenClass,
      parameters: parameters,
    );
  }

  Future<void> logPurchase({
    String? currency,
    String? coupon,
    double? value,
    List<AnalyticsEventItem>? items,
    double? tax,
    double? shipping,
    String? transactionId,
    String? affiliation,
  }) async {
    if (kDebugMode) {
      Log.d(
        'logPurchase: currency: $currency, coupon: $coupon, value: $value, tax: $tax, shipping: $shipping, transactionId: $transactionId, affiliation: $affiliation}',
        color: LogColor.cyan,
        mode: LogMode.logEventOnly,
      );
    }
    await _firebaseAnalytics.logPurchase(
      currency: currency,
      coupon: coupon,
      value: value,
      items: items,
      tax: tax,
      shipping: shipping,
      transactionId: transactionId,
      affiliation: affiliation,
    );
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
