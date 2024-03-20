import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../../index.dart';

final loadMoreUsersExecutorProvider = Provider<LoadMoreUsersExecutor>(
  (ref) => LoadMoreUsersExecutor(ref),
);

@Injectable()
class LoadMoreUsersExecutor extends LoadMoreExecutor<ApiUserData> {
  LoadMoreUsersExecutor(this._ref);

  final Ref _ref;

  @protected
  @override
  Future<PagedList<ApiUserData>> action({
    required int page,
    required int limit,
  }) async {
    final response =
        await _ref.randomUserApiClient.request<ApiUserData, ResultsListResponse<ApiUserData>>(
      method: RestMethod.get,
      path: '',
      queryParameters: {
        'page': page,
        'results': limit,
      },
      successResponseDecoderType: SuccessResponseDecoderType.resultsJsonArray,
      decoder: (json) => ApiUserData.fromJson(json as Map<String, dynamic>),
    );

    return PagedList(data: response?.results ?? [], next: response?.next);
  }
}
