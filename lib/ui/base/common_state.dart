import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'common_state.freezed.dart';

@freezed
class CommonState<T extends BaseState> with _$CommonState<T> {
  const factory CommonState({
    required T data,
    AppException? appException,
    @Default(false) bool isLoading,
  }) = _CommonState;
}
