import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('isLoginButtonEnabled', () {
    test('when `email` is empty', () async {
      const loginState = LoginState(password: '123');
      expect(loginState.isLoginButtonEnabled, false);
    });

    test('when `password` is empty', () async {
      const loginState = LoginState(email: 'a@g.com');
      expect(loginState.isLoginButtonEnabled, false);
    });

    test('when both `email` and `password` are not empty', () async {
      const loginState = LoginState(email: 'a', password: '1');
      expect(loginState.isLoginButtonEnabled, true);
    });
  });
}
