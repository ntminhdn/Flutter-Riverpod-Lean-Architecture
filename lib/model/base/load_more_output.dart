import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'load_more_output.freezed.dart';

@freezed
class LoadMoreOutput<T> with _$LoadMoreOutput<T> {
  const LoadMoreOutput._();

  const factory LoadMoreOutput({
    required List<T> data,
    @Default(null) Object? otherData,
    @Default(Constant.initialPage) int page,
    @Default(false) bool isRefreshSuccess,
    @Default(0) int offset,
    @Default(false) bool isLastPage,
    @Default(0) int total,
  }) = _LoadMoreOutput;

  int get nextPage => page + 1;
  int get previousPage => page - 1;
}
