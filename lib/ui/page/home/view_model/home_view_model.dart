import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, CommonState<HomeState>>(
  (ref) => HomeViewModel(ref),
);

class HomeViewModel extends BaseViewModel<HomeState> {
  HomeViewModel(
    this._ref,
  ) : super(CommonState(data: HomeState()));

  final Ref _ref;

  Future<void> fetchInitialUsers() async {
    await _getUsers(isInitialLoad: true);
  }

  FutureOr<void> fetchMoreUsers() async {
    await _getUsers(isInitialLoad: false);
  }

  Future<void> _getUsers({
    required bool isInitialLoad,
  }) async {
    return runCatching(
      action: () async {
        data = data.copyWith(isShimmerLoading: isInitialLoad, loadUsersException: null);
        final output = await _ref.loadMoreUsersExecutor.execute(
          isInitialLoad: isInitialLoad,
        );
        data = data.copyWith(users: output);
      },
      doBeforeHandlingError: (e) async {
        data = data.copyWith(loadUsersException: e);
      },
      doOnSuccessOrError: () async {
        data = data.copyWith(isShimmerLoading: false);
      },
      handleLoading: false,
      handleErrorWhen: (e) => false,
    );
  }
}
