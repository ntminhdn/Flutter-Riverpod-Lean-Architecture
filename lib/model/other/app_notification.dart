import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    @Default('') String image,
    @Default('') String title,
    @Default('') String message,
    @Default('') String conversationId,
  }) = _AppNotification;
}
