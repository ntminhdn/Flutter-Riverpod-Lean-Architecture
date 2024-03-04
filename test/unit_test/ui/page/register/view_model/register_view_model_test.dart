import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import '../../../../../common/index.dart';

void main() {
  late RegisterViewModel registerViewModel;

  setUp(() {
    registerViewModel = RegisterViewModel(ref);
  });

  group('setEmail', () {
    group('test', () {
      final seed = _registerState(const RegisterState());
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
        build: () => registerViewModel,
      );
    });

    group('test', () {
      final seed = _registerState(const RegisterState(
        email: 'duynn@gmail.com',
        onPageError: 'error',
        password: '123',
        confirmPassword: '123',
      ));
      stateNotifierTest(
        'when both `email` and `onPageError` are not empty',
        seed: () => [seed],
        actions: (vm) {
          vm.setEmail('ntminhdn@gmail.com');
        },
        expect: () {
          final state1 = seed.copyWithData(email: 'ntminhdn@gmail.com', onPageError: '');

          return [seed, state1];
        },
        build: () => registerViewModel,
      );
    });
  });

  group('setPassword', () {
    group('test', () {
      final seed = _registerState(const RegisterState());
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
        build: () => registerViewModel,
      );
    });

    group('test', () {
      final seed = _registerState(const RegisterState(
        password: '123456',
        onPageError: 'error',
        email: 'ntminh@gmail.com',
        confirmPassword: '123455',
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
        build: () => registerViewModel,
      );
    });
  });

  group('setConfirmPassword', () {
    group('test', () {
      final seed = _registerState(const RegisterState());
      stateNotifierTest(
        'when both `confirmPassword` and `onPageError` are empty',
        seed: () => [seed],
        actions: (vm) {
          vm.setConfirmPassword('123456');
        },
        expect: () {
          final state1 = seed.copyWithData(confirmPassword: '123456');

          return [seed, state1];
        },
        build: () => registerViewModel,
      );
    });

    group('test', () {
      final seed = _registerState(const RegisterState(
        confirmPassword: '123456',
        onPageError: 'error',
        email: 'nt@gmail.com',
        password: '123456',
      ));
      stateNotifierTest(
        'when both `confirmPassword` and `onPageError` are not empty',
        seed: () => [seed],
        actions: (vm) {
          vm.setConfirmPassword('Ab123456');
        },
        expect: () {
          final state1 = seed.copyWithData(confirmPassword: 'Ab123456', onPageError: '');

          return [seed, state1];
        },
        build: () => registerViewModel,
      );
    });
  });

  group('register', () {
    group('test', () {
      const email = 'ntminhdn@gmail.com';
      const password = '123456';
      const confirmPassword = '123456';
      const userId = 'xyz009';
      const deviceId = 'device_ios_001';
      const deviceToken = 'fcm_token_001';
      final seed = _registerState(const RegisterState(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      ));

      stateNotifierTest(
        'when `createUserWithEmailAndPassword` succeed',
        seed: () => [seed],
        setUp: () {
          when(() => firebaseAuthService.createUserWithEmailAndPassword(
                email: email,
                password: password,
              )).thenAnswer((_) async => userId);

          when(() => deviceHelper.deviceId).thenAnswer((_) async => deviceId);
          when(() => appPreferences.saveUserId(userId)).thenAnswer((_) async => true);
          when(() => appPreferences.saveEmail(email)).thenAnswer((_) async => true);
          when(() => appPreferences.saveIsLoggedIn(true)).thenAnswer((_) async {});
          when(() => navigator.replaceAll([const ContactListRoute()])).thenAnswer((_) async {});
          when(() => firebaseFirestoreService.putUserToFireStore(
                userId: any(named: 'userId'),
                user: any(named: 'user'),
              )).thenAnswer((_) async {});
          when(() => sharedViewModel.deviceToken).thenAnswer((_) async => deviceToken);
        },
        actions: (vm) => vm.register(),
        expect: () {
          final state1And2 = seed.showAndHideLoading;

          return [seed, ...state1And2];
        },
        verify: (vm) {
          verify(() => appPreferences.saveUserId(userId)).called(1);
          verify(() => appPreferences.saveEmail(email)).called(1);
          verify(() => appPreferences.saveIsLoggedIn(true)).called(1);
          verify(() => navigator.replaceAll([const ContactListRoute()])).called(1);
          verify(() => firebaseFirestoreService.putUserToFireStore(
                userId: userId,
                user: const FirebaseUserData(
                  id: userId,
                  email: email,
                  deviceIds: [deviceId],
                  deviceTokens: [deviceToken],
                ),
              )).called(1);
        },
        build: () => registerViewModel,
      );
    });

    group('test', () {
      const email = 'ntminhdn@gmail.com';
      const password = '123456';
      const confirmPassword = '123456';
      final seed = _registerState(const RegisterState(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      ));

      stateNotifierTest(
        'when `createUserWithEmailAndPassword` failed',
        seed: () => [seed],
        setUp: () {
          when(() => firebaseAuthService.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  ))
              .thenThrow(AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.invalidEmail));
        },
        actions: (vm) => vm.register(),
        expect: () {
          final state1And2 = seed.showAndHideLoading;
          final state3 = seed.copyWithData(onPageError: l10n.invalidEmail);

          return [seed, ...state1And2, state3];
        },
        verify: (vm) {
          verifyNever(() => appPreferences.saveUserId(any()));
          verifyNever(() => appPreferences.saveEmail(any()));
          verifyNever(() => appPreferences.saveIsLoggedIn(any()));
          verifyNever(() => navigator.replaceAll(any()));
          verifyNever(() => firebaseFirestoreService.putUserToFireStore(
                userId: any(named: 'userId'),
                user: any(named: 'user'),
              ));
        },
        build: () => registerViewModel,
      );
    });

    group('test', () {
      const email = 'duynn';
      const password = '123456';
      const confirmPassword = '123456';
      final seed = _registerState(const RegisterState(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      ));

      stateNotifierTest(
        'when email is invalid',
        seed: () => [seed],
        actions: (vm) => vm.register(),
        expect: () {
          final state1And2 = seed.showAndHideLoading;
          final state3 = seed.copyWithData(onPageError: l10n.invalidEmail);

          return [seed, ...state1And2, state3];
        },
        verify: (vm) {
          verifyNever(() => appPreferences.saveUserId(any()));
          verifyNever(() => appPreferences.saveEmail(any()));
          verifyNever(() => appPreferences.saveIsLoggedIn(any()));
          verifyNever(() => navigator.replaceAll(any()));
          verifyNever(() => firebaseFirestoreService.putUserToFireStore(
                userId: any(named: 'userId'),
                user: any(named: 'user'),
              ));
        },
        build: () => registerViewModel,
      );
    });

    group('test', () {
      const email = 'duynn@gmail.com';
      const password = '123';
      const confirmPassword = '123';
      final seed = _registerState(const RegisterState(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      ));

      stateNotifierTest(
        'when password is invalid',
        seed: () => [seed],
        actions: (vm) => vm.register(),
        expect: () {
          final state1And2 = seed.showAndHideLoading;
          final state3 = seed.copyWithData(onPageError: l10n.invalidPassword);

          return [seed, ...state1And2, state3];
        },
        verify: (vm) {
          verifyNever(() => appPreferences.saveUserId(any()));
          verifyNever(() => appPreferences.saveEmail(any()));
          verifyNever(() => appPreferences.saveIsLoggedIn(any()));
          verifyNever(() => navigator.replaceAll(any()));
          verifyNever(() => firebaseFirestoreService.putUserToFireStore(
                userId: any(named: 'userId'),
                user: any(named: 'user'),
              ));
        },
        build: () => registerViewModel,
      );
    });

    group('test', () {
      const email = 'duynn@gmail.com';
      const password = '123456';
      const confirmPassword = '12345555555555';
      final seed = _registerState(const RegisterState(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      ));

      stateNotifierTest(
        'when passwords do not match',
        seed: () => [seed],
        actions: (vm) => vm.register(),
        expect: () {
          final state1And2 = seed.showAndHideLoading;
          final state3 = seed.copyWithData(onPageError: l10n.passwordsAreNotMatch);

          return [seed, ...state1And2, state3];
        },
        verify: (vm) {
          verifyNever(() => appPreferences.saveUserId(any()));
          verifyNever(() => appPreferences.saveEmail(any()));
          verifyNever(() => appPreferences.saveIsLoggedIn(any()));
          verifyNever(() => navigator.replaceAll(any()));
          verifyNever(() => firebaseFirestoreService.putUserToFireStore(
                userId: any(named: 'userId'),
                user: any(named: 'user'),
              ));
        },
        build: () => registerViewModel,
      );
    });
  });
}

CommonState<RegisterState> _registerState(RegisterState data) => CommonState(data: data);

extension RegisterStateExt on CommonState<RegisterState> {
  CommonState<RegisterState> copyWithData({
    String? email,
    String? password,
    String? confirmPassword,
    String? onPageError,
  }) {
    return copyWith(
      data: data.copyWith(
        email: email ?? data.email,
        password: password ?? data.password,
        confirmPassword: confirmPassword ?? data.confirmPassword,
        onPageError: onPageError ?? data.onPageError,
      ),
    );
  }
}
