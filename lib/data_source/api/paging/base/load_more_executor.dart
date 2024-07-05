import '../../../../index.dart';

abstract class LoadMoreExecutor<T> with LogMixin {
  LoadMoreExecutor({
    this.initPage = Constant.initialPage,
    this.initOffset = 0,
    this.limit = Constant.itemsPerPage,
  })  : _output = LoadMoreOutput<T>(data: <T>[], page: initPage, offset: initOffset),
        _oldOutput = LoadMoreOutput<T>(data: <T>[], page: initPage, offset: initOffset);

  final int initPage;
  final int initOffset;
  final int limit;

  LoadMoreOutput<T> _output;
  LoadMoreOutput<T> _oldOutput;

  int get page => _output.page;
  int get offset => _output.offset;

  Future<PagedList<T>> action({
    required int page,
    required int limit,
    required Map<String, dynamic> params,
  });

  Future<LoadMoreOutput<T>> execute({
    required bool isInitialLoad,
    Map<String, dynamic>? params,
  }) async {
    try {
      if (isInitialLoad) {
        _output = LoadMoreOutput<T>(data: <T>[], page: initPage, offset: initOffset);
      }
      logD('LoadMoreInput: page: $page, offset: $offset');
      final pagedList = await action(page: page, limit: limit, params: params ?? {});

      final newOutput = _oldOutput.copyWith(
        data: pagedList.data,
        otherData: pagedList.otherData,
        page: isInitialLoad
            ? initPage + (pagedList.data.isNotEmpty ? 1 : 0)
            : _oldOutput.page + (pagedList.data.isNotEmpty ? 1 : 0),
        offset: isInitialLoad
            ? (initOffset + pagedList.data.length)
            : _oldOutput.offset + pagedList.data.length,
        isLastPage: pagedList.isLastPage,
        isRefreshSuccess: isInitialLoad,
        total: pagedList.total ?? 0,
      );

      _output = newOutput;
      _oldOutput = newOutput;
      if (Config.enableLogExecutorOutput) {
        logD(
          'LoadMoreOutput: pagedList: $pagedList, inputPage: $page, inputOffset: $offset, newOutput: $newOutput',
        );
      }

      return newOutput;
    } catch (e) {
      logE('LoadMoreError: $e');
      _output = _oldOutput;

      throw e is AppException ? e : AppUncaughtException(rootException: e);
    }
  }
}
