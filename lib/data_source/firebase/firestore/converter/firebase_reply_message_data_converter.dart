import 'package:json_annotation/json_annotation.dart';

import '../../../../index.dart';

class FirebaseReplyMessageDataConverter
    implements JsonConverter<FirebaseReplyMessageData, Map<String, dynamic>> {
  const FirebaseReplyMessageDataConverter();

  @override
  FirebaseReplyMessageData fromJson(Map<String, dynamic> json) {
    return FirebaseReplyMessageData.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(FirebaseReplyMessageData data) {
    return data.toJson();
  }
}
