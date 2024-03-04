import 'package:json_annotation/json_annotation.dart';

import '../../../../index.dart';

class FirebaseConversionUserDataConverter
    implements JsonConverter<FirebaseConversationUserData, Map<String, dynamic>> {
  const FirebaseConversionUserDataConverter();

  @override
  FirebaseConversationUserData fromJson(Map<String, dynamic> json) {
    return FirebaseConversationUserData.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(FirebaseConversationUserData data) {
    return data.toJson();
  }
}
