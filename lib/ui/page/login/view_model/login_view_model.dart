import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, CommonState<LoginState>>(
  (ref) => LoginViewModel(ref),
);

class LoginViewModel extends BaseViewModel<LoginState> {
  LoginViewModel(this._ref) : super(const CommonState(data: LoginState()));

  final Ref _ref;

  void setEmail(String email) {
    data = data.copyWith(
      email: email,
      onPageError: '',
    );
  }

  void setPassword(String password) {
    data = data.copyWith(
      password: password,
      onPageError: '',
    );
  }

  FutureOr<void> login() async {
    await runCatching(
      action: () async {
        final email = data.email.trim();
        final userId = await _ref.firebaseAuthService.signInWithEmailAndPassword(
          email: email,
          password: data.password,
        );

        final user = await _ref.firebaseFirestoreService.getCurrentUser(userId);
        final deviceId = await _ref.deviceHelper.deviceId;

        if (user.deviceIds.isNotEmpty && !user.deviceIds.contains(deviceId)) {
          await _ref.firebaseAuthService.signOut();
          data = data.copyWith(onPageError: l10n.youHaveLoggedInOnAnotherDevice);

          return;
        }

        final deviceToken = await _ref.sharedViewModel.deviceToken;

        Log.d('deviceToken: $deviceToken');

        await Future.wait([
          _ref.appPreferences.saveUserId(userId),
          _ref.appPreferences.saveEmail(data.email),
          _ref.appPreferences.saveIsLoggedIn(true),
          _ref.firebaseFirestoreService.updateCurrentUser(userId: userId, data: {
            FirebaseUserData.keyDeviceIds: [deviceId],
            FirebaseUserData.keyDeviceTokens: FieldValue.arrayUnion([deviceToken]),
          }),
        ]);

        await _ref.nav.replaceAll([const ContactListRoute()]);
      },
      handleErrorWhen: (_) => false,
      doBeforeHandlingError: (e) async {
        data = data.copyWith(onPageError: e.message);
      },
    );
  }
}
