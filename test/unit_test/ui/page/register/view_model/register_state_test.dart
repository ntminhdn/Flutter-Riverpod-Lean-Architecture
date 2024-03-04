import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('isRegisterButtonEnabled', () {
    test('when `email` is empty', () async {
      const registerState = RegisterState(password: '123', confirmPassword: '1');
      expect(registerState.isRegisterButtonEnabled, false);
    });

    test('when `password` is empty', () async {
      const registerState = RegisterState(email: 'a', confirmPassword: '1');
      expect(registerState.isRegisterButtonEnabled, false);
    });

    test('when `confirmPassword` is empty', () async {
      const registerState = RegisterState(email: 'a', password: '1');
      expect(registerState.isRegisterButtonEnabled, false);
    });

    test('when both `email`, `password` and `confirmPassword` are not empty', () async {
      const registerState = RegisterState(email: 'a', password: '1', confirmPassword: '1');
      expect(registerState.isRegisterButtonEnabled, true);
    });
  });
}
