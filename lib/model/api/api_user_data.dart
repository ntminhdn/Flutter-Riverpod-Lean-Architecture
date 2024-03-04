import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_user_data.freezed.dart';
part 'api_user_data.g.dart';

@freezed
class ApiUserData with _$ApiUserData {
  const ApiUserData._();

  const factory ApiUserData({
    @JsonKey(name: 'uid') int? id,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'birthday') String? birthday,
    @JsonKey(name: 'income') String? income,
    @JsonKey(name: 'avatar') String? avatar,
    @JsonKey(name: 'photos') List<String>? photos,
    @JsonKey(name: 'sex') int? gender,
  }) = _ApiUserData;

  factory ApiUserData.fromJson(Map<String, dynamic> json) => _$ApiUserDataFromJson(json);
}
