import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import '../../../../../common/index.dart';

void main() {
  late MyPageViewModel myPageViewModel;

  setUp(() {
    myPageViewModel = MyPageViewModel(ref);
  });

  group('logout', () {
    group('test', () {
      final seed = _myPageState(const MyPageState());
      stateNotifierTest(
        'when logout successfully',
        seed: () => [seed],
        setUp: () {
          when(() => sharedViewModel.logout()).thenAnswer((invocation) async => {});
        },
        actions: (vm) => vm.logout(),
        expect: () => [seed, ...seed.showAndHideLoading],
        verify: (vm) {
          verify(() => sharedViewModel.logout()).called(1);
        },
        build: () => myPageViewModel,
      );
    });

    group('test', () {
      final seed = _myPageState(const MyPageState());
      stateNotifierTest(
        'when logout failed',
        seed: () => [seed],
        setUp: () {
          when(() => sharedViewModel.logout()).thenThrow(Exception());
        },
        actions: (vm) => vm.logout(),
        expect: () => [seed, ...seed.showAndHideLoading],
        verify: (vm) {
          verify(() => sharedViewModel.logout()).called(1);
        },
        build: () => myPageViewModel,
      );
    });
  });

  group('deleteAccount', () {
    group('test', () {
      final seed = _myPageState(const MyPageState());
      stateNotifierTest(
        'when delete account successfully',
        seed: () => [seed],
        setUp: () {
          when(() => appPreferences.userId).thenReturn('1');
          when(() => appPreferences.clearCurrentUserData()).thenAnswer((invocation) async => {});
          when(() => firebaseFirestoreService.deleteUser('1')).thenAnswer((invocation) async => {});
          when(() => firebaseAuthService.deleteAccount()).thenAnswer((invocation) async => {});
          when(() => navigator.replaceAll([const LoginRoute()]))
              .thenAnswer((invocation) async => {});
        },
        actions: (vm) => vm.deleteAccount(),
        expect: () => [seed, ...seed.showAndHideLoading],
        verify: (vm) {
          verify(() => appPreferences.userId).called(1);
          verify(() => appPreferences.clearCurrentUserData()).called(1);
          verify(() => firebaseFirestoreService.deleteUser('1')).called(1);
          verify(() => firebaseAuthService.deleteAccount()).called(1);
          verify(() => navigator.replaceAll([const LoginRoute()])).called(1);
        },
        build: () => myPageViewModel,
      );
    });

    group('test', () {
      final seed = _myPageState(const MyPageState());
      stateNotifierTest(
        'when `firebaseFirestoreService.deleteUser` failed',
        seed: () => [seed],
        setUp: () {
          when(() => appPreferences.userId).thenReturn('1');
          when(() => appPreferences.clearCurrentUserData()).thenAnswer((invocation) async => {});
          when(() => firebaseFirestoreService.deleteUser('1')).thenThrow(Exception());
          when(() => firebaseAuthService.deleteAccount()).thenAnswer((invocation) async => {});
          when(() => navigator.replaceAll([const LoginRoute()]))
              .thenAnswer((invocation) async => {});
        },
        actions: (vm) => vm.deleteAccount(),
        expect: () => [seed, ...seed.showAndHideLoading],
        verify: (vm) {
          verify(() => appPreferences.userId).called(1);
          verify(() => appPreferences.clearCurrentUserData()).called(1);
          verify(() => firebaseFirestoreService.deleteUser('1')).called(1);
          verifyNever(() => firebaseAuthService.deleteAccount());
          verify(() => navigator.replaceAll([const LoginRoute()])).called(1);
        },
        build: () => myPageViewModel,
      );
    });

    group('test', () {
      final seed = _myPageState(const MyPageState());
      stateNotifierTest(
        'when `firebaseAuthService.deleteAccount` failed',
        seed: () => [seed],
        setUp: () {
          when(() => appPreferences.userId).thenReturn('1');
          when(() => appPreferences.clearCurrentUserData()).thenAnswer((invocation) async => {});
          when(() => firebaseAuthService.deleteAccount()).thenThrow(Exception());
          when(() => firebaseFirestoreService.deleteUser('1')).thenAnswer((invocation) async => {});
          when(() => navigator.replaceAll([const LoginRoute()]))
              .thenAnswer((invocation) async => {});
        },
        actions: (vm) => vm.deleteAccount(),
        expect: () => [seed, ...seed.showAndHideLoading],
        verify: (vm) {
          verify(() => appPreferences.userId).called(1);
          verify(() => appPreferences.clearCurrentUserData()).called(1);
          verify(() => firebaseFirestoreService.deleteUser('1')).called(1);
          verify(() => firebaseAuthService.deleteAccount()).called(1);
          verify(() => navigator.replaceAll([const LoginRoute()])).called(1);
        },
        build: () => myPageViewModel,
      );
    });
  });
}

CommonState<MyPageState> _myPageState(MyPageState data) => CommonState(data: data);
