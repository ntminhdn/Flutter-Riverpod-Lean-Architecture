import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'api_user_data.freezed.dart';
part 'api_user_data.g.dart';

@freezed
class ApiUserData with _$ApiUserData {
  const ApiUserData._();

  const factory ApiUserData({
    @Default(ApiUserData.defaultId) @JsonKey(name: 'uid') int id,
    @Default(ApiUserData.defaultEmail) @JsonKey(name: 'email') String email,
    @ApiDateTimeConverter() @JsonKey(name: 'dob') DateTime? birthday,
    @Default(ApiUserData.defaultGender) @JsonKey(name: 'gender') Gender gender,
  }) = _ApiUserData;

  static const defaultId = 0;
  static const defaultEmail = '';
  static const defaultBirthday = '';
  static const defaultGender = Gender.other;

  factory ApiUserData.fromJson(Map<String, dynamic> json) => _$ApiUserDataFromJson(json);
}
