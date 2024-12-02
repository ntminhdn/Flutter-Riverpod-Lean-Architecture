import '../../../index.dart';

class EventConstants {
  EventConstants._();

  static const String eyeIconClick = 'eye_icon_click';
  static const String loginButtonClick = 'login_button_click';
  static const String registerButtonClick = 'register_button_click';
}

class NormalEvent {
  NormalEvent({
    required this.eventName,
    required this.screenName,
    this.parameter,
  });
  final String eventName;
  final ScreenName screenName;
  final AnalyticParameter? parameter;

  String get fullEventName =>
      'app${screenName.screenEventPrefix.isNotEmpty ? '_' : ''}${screenName.screenEventPrefix}_$eventName';

  NormalEvent copyWith({
    String? eventName,
    ScreenName? screenName,
    AnalyticParameter? parameter,
  }) {
    return NormalEvent(
      eventName: eventName ?? this.eventName,
      screenName: screenName ?? this.screenName,
      parameter: parameter ?? this.parameter,
    );
  }
}

class ScreenViewEvent {
  ScreenViewEvent({
    required this.screenName,
    this.key,
    this.parameter,
  });

  final ScreenName screenName;
  final String? key;
  final AnalyticParameter? parameter;

  String get fullKey =>
      '${screenName.screenName}_${screenName.screenEventPrefix}${key != null ? '_$key' : ''}';

  ScreenViewEvent copyWith({
    ScreenName? screenName,
    String? key,
    AnalyticParameter? parameter,
  }) {
    return ScreenViewEvent(
      screenName: screenName ?? this.screenName,
      key: key ?? this.key,
      parameter: parameter ?? this.parameter,
    );
  }
}
