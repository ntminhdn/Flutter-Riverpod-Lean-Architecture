import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import '../../../../../common/index.dart';

void main() {
  late LoginViewModel loginViewModel;

  setUp(() {
    loginViewModel = LoginViewModel(ref);
  });

  group('setEmail', () {
    group('test', () {
      final seed = _loginState(const LoginState());
      stateNotifierTest(
        'when both `email` and `onPageError` are empty',
        seed: () => [seed],
        actions: (vm) {
          vm.setEmail('ntminh@gmail.com');
        },
        expect: () {
          final state1 = seed.copyWithData(email: 'ntminh@gmail.com');

          return [seed, state1];
        },
        build: () => loginViewModel,
      );
    });

    group('test', () {
      final seed = _loginState(const LoginState(
        email: 'ntminh@gmail.com',
        onPageError: 'error',
        password: '123456',
      ));
      stateNotifierTest(
        'when both `email` and `onPageError` are not empty',
        seed: () => [seed],
        actions: (vm) {
          vm.setEmail('duynn@gmail.com');
        },
        expect: () {
          final state1 = seed.copyWithData(email: 'duynn@gmail.com', onPageError: '');

          return [seed, state1];
        },
        build: () => loginViewModel,
      );
    });
  });

  group('setPassword', () {
    group('test', () {
      final seed = _loginState(const LoginState());
      stateNotifierTest(
        'when both `password` and `onPageError` are empty',
        seed: () => [seed],
        actions: (vm) {
          vm.setPassword('123456');
        },
        expect: () {
          final state1 = seed.copyWithData(password: '123456');

          return [seed, state1];
        },
        build: () => loginViewModel,
      );
    });

    group('test', () {
      final seed = _loginState(const LoginState(
        password: '123456',
        onPageError: 'error',
        email: 'ntminh@gmail.com',
      ));
      stateNotifierTest(
        'when both `password` and `onPageError` are not empty',
        seed: () => [seed],
        actions: (vm) {
          vm.setPassword('Ab123456');
        },
        expect: () {
          final state1 = seed.copyWithData(password: 'Ab123456', onPageError: '');

          return [seed, state1];
        },
        build: () => loginViewModel,
      );
    });
  });

  group('login', () {
    group('test', () {
      const email = 'ntminh@gmail.com';
      const password = '123456';
      const userId = 'xyz009';
      const deviceId = 'device_ios_001';
      const deviceToken = 'fcm_token_001';
      final seed = _loginState(const LoginState(email: email, password: password));

      stateNotifierTest(
        'when `signInWithEmailAndPassword` succeed',
        seed: () => [seed],
        setUp: () {
          when(() => firebaseAuthService.signInWithEmailAndPassword(
                email: email,
                password: password,
              )).thenAnswer((_) async => userId);

          when(() => firebaseFirestoreService.getCurrentUser(userId))
              .thenAnswer((_) async => const FirebaseUserData());
          when(() => deviceHelper.deviceId).thenAnswer((_) async => deviceId);
          when(() => appPreferences.saveUserId(userId)).thenAnswer((_) async => true);
          when(() => appPreferences.saveEmail(email)).thenAnswer((_) async => true);
          when(() => appPreferences.saveIsLoggedIn(true)).thenAnswer((_) async {});
          when(() => firebaseAuthService.signOut()).thenAnswer((_) async {});
          when(() => navigator.replaceAll([const ContactListRoute()])).thenAnswer((_) async {});
          when(() => firebaseFirestoreService.updateCurrentUser(
                userId: any(named: 'userId'),
                data: any(named: 'data'),
              )).thenAnswer((_) async {});
          when(() => sharedViewModel.deviceToken).thenAnswer((_) async => deviceToken);
        },
        actions: (vm) => vm.login(),
        expect: () {
          final state1And2 = seed.showAndHideLoading;

          return [seed, ...state1And2];
        },
        build: () => loginViewModel,
      );
    });

    group('test', () {
      const email = 'ntminh@gmail.com';
      const password = '123456';
      const userId = 'xyz009';
      const deviceId = 'device_ios_001';
      const deviceIdOnFirestore = 'device_android_003';
      final seed = _loginState(const LoginState(email: email, password: password));

      stateNotifierTest(
        'when `signInWithEmailAndPassword` succeed but user has logged in on another device',
        seed: () => [seed],
        setUp: () {
          when(() => firebaseAuthService.signInWithEmailAndPassword(
                email: email,
                password: password,
              )).thenAnswer((_) async => userId);

          when(() => firebaseFirestoreService.getCurrentUser(userId))
              .thenAnswer((_) async => const FirebaseUserData(
                    deviceIds: [deviceIdOnFirestore],
                  ));
          when(() => deviceHelper.deviceId).thenAnswer((_) async => deviceId);
          when(() => firebaseAuthService.signOut()).thenAnswer((_) async {});
        },
        actions: (vm) => vm.login(),
        expect: () {
          final state1 = seed.copyWith(isLoading: true);
          final state2 = state1.copyWithData(onPageError: l10n.youHaveLoggedInOnAnotherDevice);
          final state3 = state2.copyWith(isLoading: false);

          return [seed, state1, state2, state3];
        },
        build: () => loginViewModel,
      );
    });

    group('test', () {
      const email = 'duynn@gmail.com';
      const password = 'Ab123456';
      final seed = _loginState(const LoginState(email: email, password: password));

      stateNotifierTest(
        'when `signInWithEmailAndPassword` fail',
        seed: () => [seed],
        setUp: () {
          final exception =
              AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.invalidLoginCredentials);
          when(() => firebaseAuthService.signInWithEmailAndPassword(
                email: email,
                password: password,
              )).thenThrow(exception);
        },
        actions: (vm) => vm.login(),
        expect: () {
          final state1And2 = seed.showAndHideLoading;
          final state3 = state1And2.last.copyWithData(onPageError: l10n.invalidLoginCredentials);

          return [seed, ...state1And2, state3];
        },
        build: () => loginViewModel,
      );
    });
  });
}

CommonState<LoginState> _loginState(LoginState data) => CommonState(data: data);

extension LoginStateExt on CommonState<LoginState> {
  CommonState<LoginState> copyWithData({
    String? email,
    String? password,
    String? onPageError,
  }) {
    return copyWith(
      data: data.copyWith(
        email: email ?? data.email,
        password: password ?? data.password,
        onPageError: onPageError ?? data.onPageError,
      ),
    );
  }
}
