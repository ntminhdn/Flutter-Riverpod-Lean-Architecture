import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState extends BaseState with _$RegisterState {
  const RegisterState._();

  const factory RegisterState({
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default('') String onPageError,
  }) = _RegisterState;

  bool get isRegisterButtonEnabled =>
      email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty;
}
