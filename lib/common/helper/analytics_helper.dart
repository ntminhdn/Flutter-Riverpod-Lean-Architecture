import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../index.dart';

final analyticsHelperProvider = Provider<AnalyticsHelper>(
  (ref) => getIt.get<AnalyticsHelper>(),
);

@LazySingleton()
class AnalyticsHelper {
  Future<void> logEvent(AnalyticEvent event) {
    Log.d(
      'logEvent: ${event.fullEventName}, parameters: ${event.parameters}',
      color: LogColor.cyan,
    );
    return FirebaseAnalytics.instance.logEvent(
      name: event.fullEventName,
      parameters: event.parameters,
    );
  }

  Future<void> logScreenView({
    required ScreenName screenName,
    Map<String, Object>? parameters,
  }) {
    Log.d(
      'logScreenView: ${screenName.screenName}, parameters: $parameters',
      color: LogColor.cyan,
    );
    return FirebaseAnalytics.instance.logScreenView(
      screenName: screenName.screenName,
      parameters: parameters,
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

enum ScreenName {
  allUsers(screenName: 'All Users Page', eventName: 'all_users'),
  chat(screenName: 'Chat Page', eventName: 'chat'),
  contactList(screenName: 'Contact List Page', eventName: 'contact_list'),
  home(screenName: 'Home Page', eventName: 'home'),
  login(screenName: 'Login Page', eventName: 'login'),
  main(screenName: 'Main Page', eventName: 'main'),
  myPage(screenName: 'My Page', eventName: 'my_page'),
  register(screenName: 'Register Page', eventName: 'register'),
  renameConversation(screenName: 'Rename Conversation Page', eventName: 'rename_conversation'),
  setting(screenName: 'Setting Page', eventName: 'setting');

  final String screenName;
  final String eventName;

  const ScreenName({
    required this.screenName,
    required this.eventName,
  });
}

abstract class AnalyticEvent {
  final String name;
  final ScreenName screenName;
  final Map<String, Object>? parameters;

  AnalyticEvent({
    required this.name,
    required this.screenName,
    required this.parameters,
  });

  String get fullEventName => 'app_${screenName.eventName}_$name';
}

class RegisterButtonClickEvent extends AnalyticEvent {
  RegisterButtonClickEvent({
    required super.screenName,
  }) : super(
          name: 'register_button_click',
          parameters: null,
        );
}

class LoginButtonClickEvent extends AnalyticEvent {
  LoginButtonClickEvent({
    required super.screenName,
  }) : super(name: 'login_button_click', parameters: null);
}

class EyeIconClickEvent extends AnalyticEvent {
  final bool obscureText;

  EyeIconClickEvent({
    required this.obscureText,
    required super.screenName,
  }) : super(
          name: 'eye_icon_click',
          parameters: {
            'obscure_text': obscureText.toString(),
          },
        );
}
