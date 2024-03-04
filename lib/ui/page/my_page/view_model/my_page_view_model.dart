import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final myPageViewModelProvider =
    StateNotifierProvider.autoDispose<MyPageViewModel, CommonState<MyPageState>>(
  (ref) => MyPageViewModel(ref),
);

class MyPageViewModel extends BaseViewModel<MyPageState> {
  MyPageViewModel(this._ref)
      : super(
          const CommonState(data: MyPageState()),
        );

  final Ref _ref;

  Future<void> logout() {
    return runCatching(
      action: () async {
        await _ref.sharedViewModel.logout();
      },
      handleErrorWhen: (_) => false,
    );
  }

  Future<void> deleteAccount() async {
    return runCatching(
      action: () async {
        final userId = _ref.appPreferences.userId;
        await _ref.appPreferences.clearCurrentUserData();
        await _ref.firebaseFirestoreService.deleteUser(userId);
        await _ref.firebaseAuthService.deleteAccount();
        await _ref.nav.replaceAll([const LoginRoute()]);
      },
      handleErrorWhen: (_) => false,
      doBeforeHandlingError: (e) async {
        await _ref.nav.replaceAll([const LoginRoute()]);
      },
    );
  }
}
