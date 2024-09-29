import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../index.dart';

abstract class BaseViewModel<S extends BaseState> extends StateNotifier<CommonState<S>> {
  BaseViewModel(CommonState<S> initialState) : super(initialState) {
    this.initialState = initialState;
  }

  late final CommonState<S> initialState;

  @override
  set state(CommonState<S> value) {
    if (mounted) {
      super.state = value;
    } else {
      Log.e('Cannot set state when widget is not mounted');
    }
  }

  @override
  CommonState<S> get state {
    if (mounted) {
      return super.state;
    } else {
      Log.e('Cannot get state when widget is not mounted');

      return initialState;
    }
  }

  set data(S data) {
    if (mounted) {
      state = state.copyWith(data: data);
    } else {
      Log.e('Cannot set data when widget is not mounted');
    }
  }

  S get data => state.data;

  int _loadingCount = 0;

  set exception(AppException appException) {
    if (mounted) {
      state = state.copyWith(appException: appException);
    } else {
      Log.e('Cannot set exception when widget is not mounted');
    }
  }

  void showLoading() {
    if (_loadingCount <= 0) {
      state = state.copyWith(isLoading: true);
    }

    _loadingCount++;
  }

  void hideLoading() {
    if (_loadingCount <= 1) {
      state = state.copyWith(isLoading: false);
    }

    _loadingCount--;
  }

  Future<void> runCatching({
    required Future<void> Function() action,
    Future<void> Function()? doOnRetry,
    Future<void> Function(AppException)? doOnError,
    Future<void> Function()? doOnSuccessOrError,
    Future<void> Function()? doOnCompleted,
    bool handleLoading = true,
    bool Function(AppException)? handleRetryWhen,
    bool Function(AppException)? handleErrorWhen,
    int? maxRetries = 3,
  }) async {
    assert(maxRetries == null || maxRetries >= 0, 'maxRetries must be positive');
    try {
      if (handleLoading) {
        showLoading();
      }

      await action.call();

      if (handleLoading) {
        hideLoading();
      }
      await doOnSuccessOrError?.call();
    } on Object catch (e) {
      final appException = e is AppException ? e : AppUncaughtException(rootException: e);

      if (handleLoading) {
        hideLoading();
      }
      await doOnSuccessOrError?.call();
      await doOnError?.call(appException);

      if (handleErrorWhen?.call(appException) != false || appException.isForcedErrorToHandle) {
        final shouldRetryAutomatically = handleRetryWhen?.call(appException) != false &&
            (maxRetries == null || maxRetries - 1 >= 0);
        final shouldDoBeforeRetrying = doOnRetry != null;

        if (shouldRetryAutomatically || shouldDoBeforeRetrying) {
          appException.onRetry = () async {
            if (shouldDoBeforeRetrying) {
              await doOnRetry.call();
            }

            if (shouldRetryAutomatically) {
              await runCatching(
                action: action,
                doOnCompleted: doOnCompleted,
                doOnSuccessOrError: doOnSuccessOrError,
                doOnError: doOnError,
                doOnRetry: doOnRetry,
                handleErrorWhen: handleErrorWhen,
                handleLoading: handleLoading,
                handleRetryWhen: handleRetryWhen,
                maxRetries: maxRetries?.minus(1),
              );
            }
          };
        }

        exception = appException;
      }
    } finally {
      await doOnCompleted?.call();
    }
  }
}
