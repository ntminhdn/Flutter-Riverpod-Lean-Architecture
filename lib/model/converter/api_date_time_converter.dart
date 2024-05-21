import 'package:json_annotation/json_annotation.dart';

import '../../index.dart';

class ApiDateTimeConverter implements JsonConverter<DateTime?, Map<String, dynamic>> {
  const ApiDateTimeConverter();

  @override
  DateTime? fromJson(Map<String, dynamic> json) => DateTimeUtil.tryParse(
        safeCast(json['date']),
        format: 'yyyy-MM-dd\'T\'HH:mm:ssZ',
      );

  @override
  Map<String, dynamic> toJson(DateTime? object) => {
        'date': object?.toIso8601String(),
      };
}
