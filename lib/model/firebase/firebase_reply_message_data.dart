import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'firebase_reply_message_data.freezed.dart';
part 'firebase_reply_message_data.g.dart';

@freezed
class FirebaseReplyMessageData with _$FirebaseReplyMessageData {
  const FirebaseReplyMessageData._();

  const factory FirebaseReplyMessageData({
    @Default(FirebaseReplyMessageData.defaultReplyToMessageId)
    @JsonKey(name: FirebaseReplyMessageData.keyReplyToMessageId)
    String replyToMessageId,
    @Default(FirebaseReplyMessageData.defaultType)
    @JsonKey(name: FirebaseReplyMessageData.keyType)
    MessageType type,
    @Default(FirebaseReplyMessageData.defaultReplyToMessage)
    @JsonKey(name: FirebaseReplyMessageData.keyReplyToMessage)
    String replyToMessage,
    @Default(FirebaseReplyMessageData.defaultReplyByUserId)
    @JsonKey(name: FirebaseReplyMessageData.keyReplyByUserId)
    String replyByUserId,
    @Default(FirebaseReplyMessageData.defaultReplyToUserId)
    @JsonKey(name: FirebaseReplyMessageData.keyReplyToUserId)
    String replyToUserId,
  }) = _FirebaseReplyMessageData;

  factory FirebaseReplyMessageData.fromJson(Map<String, dynamic> json) =>
      _$FirebaseReplyMessageDataFromJson(json);

  static const keyReplyToMessageId = 'reply_to_message_id';
  static const keyType = 'type';
  static const keyReplyToMessage = 'reply_to_message';
  static const keyReplyByUserId = 'reply_by_user_id';
  static const keyReplyToUserId = 'reply_to_user_id';

  static const defaultReplyToMessageId = '';
  static const defaultType = MessageType.text;
  static const defaultReplyToMessage = '';
  static const defaultReplyByUserId = '';
  static const defaultReplyToUserId = '';
}
