import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../../index.dart';

part 'firebase_conversation_data.freezed.dart';
part 'firebase_conversation_data.g.dart';

@freezed
class FirebaseConversationData with _$FirebaseConversationData {
  const FirebaseConversationData._();

  const factory FirebaseConversationData({
    @Default(FirebaseConversationData.defaultId)
    @JsonKey(name: FirebaseConversationData.keyId)
    String id,
    @Default(FirebaseConversationData.defaultLastMessage)
    @JsonKey(name: FirebaseConversationData.keyLastMessage)
    String lastMessage,
    @Default(FirebaseConversationData.defaultLastMessageType)
    @JsonKey(name: FirebaseConversationData.keyLastMessageType)
    MessageType lastMessageType,
    @Default(FirebaseConversationData.defaultMembers)
    @FirebaseConversionUserDataConverter()
    @JsonKey(name: FirebaseConversationData.keyMembers)
    List<FirebaseConversationUserData> members,
    @Default(FirebaseConversationData.defaultMemberIds)
    @JsonKey(name: FirebaseConversationData.keyMemberIds)
    List<String> memberIds,
    @Default(FirebaseConversationData.defaultCreatedAt)
    @TimestampConverter()
    @JsonKey(name: FirebaseConversationData.keyCreatedAt)
    DateTime? createdAt,
    @Default(FirebaseConversationData.defaultUpdatedAt)
    @TimestampConverter()
    @JsonKey(name: FirebaseConversationData.keyUpdatedAt)
    DateTime? updatedAt,
  }) = _FirebaseConversationData;

  factory FirebaseConversationData.fromJson(Map<String, dynamic> json) =>
      _$FirebaseConversationDataFromJson(json);

  static const keyId = 'id';
  static const keyName = 'name';
  static const keyLastMessage = 'last_message';
  static const keyLastMessageType = 'last_message_type';
  static const keyMembers = 'members';
  static const keyMemberIds = 'member_ids';
  static const keyCreatedAt = 'created_at';
  static const keyUpdatedAt = 'updated_at';

  static const defaultId = '';
  static const defaultName = '';
  static const defaultLastMessage = '';
  static const defaultLastMessageType = MessageType.text;
  static const defaultMembers = <FirebaseConversationUserData>[];
  static const defaultMemberIds = <String>[];
  static const defaultCreatedAt = null;
  static const defaultUpdatedAt = null;

  Future<FirebaseConversationData> to({required LanguageCode languageCode}) async {
    final onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: BCP47Code.fromRawValue(LanguageCode.defaultValue.localeCode) ??
            TranslateLanguage.japanese,
        targetLanguage:
            BCP47Code.fromRawValue(languageCode.localeCode) ?? TranslateLanguage.japanese);
    final newLastMessage = await onDeviceTranslator.translateText(lastMessage);
    return copyWith(lastMessage: newLastMessage);
  }
}
