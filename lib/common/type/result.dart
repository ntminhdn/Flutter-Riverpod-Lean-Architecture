import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../index.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = _Success;
  const factory Result.failure(AppException exception) = _Error;

  static Result<T> fromSyncAction<T>(T Function() action) {
    try {
      return Result.success(action.call());
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  static Future<Result<T>> fromAsyncAction<T>(Future<T> Function() action) async {
    try {
      final output = await action.call();

      return Result.success(output);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }
}
