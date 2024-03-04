import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'firebase_conversation_user_data.freezed.dart';
part 'firebase_conversation_user_data.g.dart';

@freezed
class FirebaseConversationUserData with _$FirebaseConversationUserData {
  const FirebaseConversationUserData._();

  const factory FirebaseConversationUserData({
    @Default(FirebaseConversationUserData.defaultUserId)
    @JsonKey(name: FirebaseConversationUserData.keyUserId)
    String userId,
    @Default(FirebaseConversationUserData.defaultEmail)
    @JsonKey(name: FirebaseConversationUserData.keyEmail)
    String email,
    @Default(FirebaseConversationUserData.defaultLastSeen)
    @TimestampConverter()
    @JsonKey(name: FirebaseConversationUserData.keyLastSeen)
    DateTime? lastSeen,
    @Default(FirebaseConversationUserData.defaultIsConversationAdmin)
    @JsonKey(name: FirebaseConversationUserData.keyIsConversationAdmin)
    bool isConversationAdmin,
  }) = _FirebaseConversationUserData;

  factory FirebaseConversationUserData.fromJson(Map<String, dynamic> json) =>
      _$FirebaseConversationUserDataFromJson(json);

  static const keyUserId = 'user_id';
  static const keyEmail = 'email';
  static const keyLastSeen = 'last_seen';
  static const keyIsConversationAdmin = 'is_conversation_admin';

  static const defaultUserId = '';
  static const defaultEmail = '';
  static const defaultLastSeen = null;
  static const defaultIsConversationAdmin = false;

  ChatUser toChatUser() => ChatUser(
        id: userId,
        name: email,
      );
}
