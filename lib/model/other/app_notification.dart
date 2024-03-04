import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    @Default(AppNotification.defaultImage) String image,
    @Default(AppNotification.defaultTitle) String title,
    @Default(AppNotification.defaultMessage) String message,
    @Default(AppNotification.defaultConversationId) String conversationId,
  }) = _AppNotification;

  static const defaultImage = '';
  static const defaultTitle = '';
  static const defaultMessage = '';
  static const defaultConversationId = '';
}
