import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final registerViewModelProvider =
    StateNotifierProvider.autoDispose<RegisterViewModel, CommonState<RegisterState>>(
  (ref) => RegisterViewModel(ref),
);

class RegisterViewModel extends BaseViewModel<RegisterState> {
  RegisterViewModel(this._ref) : super(const CommonState(data: RegisterState()));

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

  void setConfirmPassword(String password) {
    data = data.copyWith(
      confirmPassword: password,
      onPageError: '',
    );
  }

  FutureOr<void> register() async {
    await runCatching(
      action: () async {
        final email = data.email.trim();
        final password = data.password;
        final confirmPassword = data.confirmPassword;

        final isValidEmail = AppUtil.isValidEmail(email);

        if (!isValidEmail) {
          throw ValidationException(kind: ValidationExceptionKind.invalidEmail);
        }

        final isValidPassword = AppUtil.isValidPassword(password);

        if (!isValidPassword) {
          throw ValidationException(kind: ValidationExceptionKind.invalidPassword);
        }

        if (password != confirmPassword) {
          throw ValidationException(kind: ValidationExceptionKind.passwordsDoNotMatch);
        }

        final userId = await _ref.firebaseAuthService.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final deviceToken = await _ref.sharedViewModel.deviceToken;
        final deviceId = await _ref.deviceHelper.deviceId;
        Log.d('deviceToken: $deviceToken');

        await Future.wait([
          _ref.appPreferences.saveUserId(userId),
          _ref.appPreferences.saveEmail(email),
          _ref.appPreferences.saveIsLoggedIn(true),
          _ref.firebaseFirestoreService.putUserToFireStore(
            userId: userId,
            user: FirebaseUserData(
              id: userId,
              email: email,
              isVip: false,
              deviceIds: [deviceId],
              deviceTokens: [deviceToken],
            ),
          ),
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
