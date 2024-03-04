import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'firebase_message_data.freezed.dart';
part 'firebase_message_data.g.dart';

@freezed
class FirebaseMessageData with _$FirebaseMessageData {
  const FirebaseMessageData._();

  const factory FirebaseMessageData({
    @Default(FirebaseMessageData.defaultId) @JsonKey(name: FirebaseMessageData.keyId) String id,
    @Default(FirebaseMessageData.defaultSenderId)
    @JsonKey(name: FirebaseMessageData.keySenderId)
    String senderId,
    @Default(FirebaseMessageData.defaultMessage)
    @JsonKey(name: FirebaseMessageData.keyMessage)
    String message,
    @Default(FirebaseMessageData.defaultType)
    @JsonKey(name: FirebaseMessageData.keyType)
    MessageType type,
    @Default(FirebaseMessageData.defaultReplyMessage)
    @FirebaseReplyMessageDataConverter()
    @JsonKey(name: FirebaseMessageData.keyReplyMessage)
    FirebaseReplyMessageData? replyMessage,
    @Default(FirebaseMessageData.defaultCreatedAt)
    @TimestampConverter()
    @JsonKey(name: FirebaseMessageData.keyCreatedAt)
    DateTime? createdAt,
    @Default(FirebaseMessageData.defaultUpdatedAt)
    @TimestampConverter()
    @JsonKey(name: FirebaseMessageData.keyUpdatedAt)
    DateTime? updatedAt,
  }) = _FirebaseMessageData;

  factory FirebaseMessageData.fromJson(Map<String, dynamic> json) =>
      _$FirebaseMessageDataFromJson(json);

  static const keyId = 'id';
  static const keySenderId = 'sender_id';
  static const keyMessage = 'message';
  static const keyType = 'type';
  static const keyReplyMessage = 'reply_message';
  static const keyCreatedAt = 'created_at';
  static const keyUpdatedAt = 'updated_at';

  static const defaultId = '';
  static const defaultSenderId = '';
  static const defaultMessage = '';
  static const defaultType = MessageType.text;
  static const defaultReplyMessage = null;
  static const defaultCreatedAt = null;
  static const defaultUpdatedAt = null;
}
