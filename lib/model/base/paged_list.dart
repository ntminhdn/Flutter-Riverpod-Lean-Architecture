import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'paged_list.freezed.dart';

@freezed
class PagedList<T> with _$PagedList<T> {
  const PagedList._();

  const factory PagedList({
    required List<T> data,
    Object? otherData,
    int? next,
    int? offset,
    int? total,
  }) = _PagedList;

  // TODO(minh): fix depend on project #0
  bool get isLastPage => data.isEmpty;

  LoadMoreOutput<T> toLoadMoreOutput() {
    return LoadMoreOutput(data: data, otherData: otherData, isLastPage: isLastPage);
  }
}
