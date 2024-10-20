import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'api_user_data.freezed.dart';
part 'api_user_data.g.dart';

@freezed
class ApiUserData with _$ApiUserData {
  const ApiUserData._();

  const factory ApiUserData({
    @Default(0) @JsonKey(name: 'uid') int id,
    @Default('') @JsonKey(name: 'email') String email,
    @ApiDateTimeConverter() @JsonKey(name: 'dob') DateTime? birthday,
    @Default(Gender.other) @JsonKey(name: 'gender') Gender gender,
  }) = _ApiUserData;

  factory ApiUserData.fromJson(Map<String, dynamic> json) => _$ApiUserDataFromJson(json);
}
