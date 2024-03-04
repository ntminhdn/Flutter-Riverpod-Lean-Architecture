import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState extends BaseState with _$LoginState {
  const LoginState._();

  const factory LoginState({
    @Default('') String email,
    @Default('') String password,
    @Default('') String onPageError,
  }) = _LoginState;

  bool get isLoginButtonEnabled => email.isNotEmpty && password.isNotEmpty;
}
