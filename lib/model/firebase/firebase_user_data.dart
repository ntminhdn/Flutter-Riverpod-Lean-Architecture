import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'firebase_user_data.freezed.dart';
part 'firebase_user_data.g.dart';

@freezed
class FirebaseUserData with _$FirebaseUserData {
  const FirebaseUserData._();

  const factory FirebaseUserData({
    @Default(FirebaseUserData.defaultId) @JsonKey(name: FirebaseUserData.keyId) String id,
    @Default(FirebaseUserData.defaultEmail) @JsonKey(name: FirebaseUserData.keyEmail) String email,
    @Default(FirebaseUserData.defaultIsVip) @JsonKey(name: FirebaseUserData.keyIsVip) bool isVip,
    @Default(FirebaseUserData.defaultDeviceIds)
    @JsonKey(name: FirebaseUserData.keyDeviceIds)
    List<String> deviceIds,
    @Default(FirebaseUserData.defaultDeviceTokens)
    @JsonKey(name: FirebaseUserData.keyDeviceTokens)
    List<String> deviceTokens,
    @Default(FirebaseUserData.defaultCreatedAt)
    @TimestampConverter()
    @JsonKey(name: FirebaseUserData.keyCreatedAt)
    DateTime? createdAt,
    @Default(FirebaseUserData.defaultUpdatedAt)
    @TimestampConverter()
    @JsonKey(name: FirebaseUserData.keyUpdatedAt)
    DateTime? updatedAt,
  }) = _FirebaseUserData;

  factory FirebaseUserData.fromJson(Map<String, dynamic> json) => _$FirebaseUserDataFromJson(json);

  static const keyId = 'id';
  static const keyEmail = 'email';
  static const keyIsVip = 'is_vip';
  static const keyDeviceIds = 'device_ids';
  static const keyDeviceTokens = 'device_tokens';
  static const keyCreatedAt = 'created_at';
  static const keyUpdatedAt = 'updated_at';

  static const defaultId = '';
  static const defaultEmail = '';
  static const defaultIsVip = false;
  static const defaultDeviceIds = <String>[];
  static const defaultDeviceTokens = <String>[];
  static const defaultCreatedAt = null;
  static const defaultUpdatedAt = null;

  ChatUser toChatUser() => ChatUser(
        id: id,
        name: email,
      );
}
