import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../../common/index.dart';

abstract class InitFunctionCall extends Mock {
  void call(String conversationId);
}

class _MockInitFunctionCall extends Mock implements InitFunctionCall {}

class _FakeRouteData extends Fake implements RouteData {
  final String conversationId;

  _FakeRouteData(this.conversationId);

  @override
  Object? get args => ChatRouteArgs(conversation: FirebaseConversationData(id: conversationId));
}

class _MockStreamSubscription<T> extends Mock implements StreamSubscription<T> {}

void main() {
  late MainViewModel mainViewModel;

  setUpAll(() {
    registerFallbackValue(_MockInitFunctionCall());
  });

  setUp(() {
    mainViewModel = MainViewModel(ref);
  });

  group('dispose', () {
    test('when `dispose` is called', () async {
      final mockOnMessageOpenedAppSubscription = _MockStreamSubscription<RemoteMessage>();
      final mockOnTokenRefreshSubscription = _MockStreamSubscription<String>();
      final mockCurrentUserSubscription = _MockStreamSubscription<FirebaseUserData>();

      mainViewModel.onMessageOpenedAppSubscription = mockOnMessageOpenedAppSubscription;
      mainViewModel.onTokenRefreshSubscription = mockOnTokenRefreshSubscription;
      mainViewModel.currentUserSubscription = mockCurrentUserSubscription;
      when(() => mockOnMessageOpenedAppSubscription.cancel()).thenAnswer((_) async {});
      when(() => mockOnTokenRefreshSubscription.cancel()).thenAnswer((_) async {});
      when(() => mockCurrentUserSubscription.cancel()).thenAnswer((_) async {});

      mainViewModel.dispose();

      verify(() => mockOnMessageOpenedAppSubscription.cancel()).called(1);
      verify(() => mockOnTokenRefreshSubscription.cancel()).called(1);
      verify(() => mockCurrentUserSubscription.cancel()).called(1);
      expect(mainViewModel.onMessageOpenedAppSubscription, isNull);
      expect(mainViewModel.onTokenRefreshSubscription, isNull);
      expect(mainViewModel.currentUserSubscription, isNull);
    });
  });

  group('setInitialCurrentUserState', () {
    test('when both userId and email are not empty', () async {
      const userId = 'user133';
      const email = 'ntminh@gmail.com';
      when(() => appPreferences.userId).thenReturn(userId);
      when(() => appPreferences.email).thenReturn(email);
      when(() => currentUserStateController.update(any())).thenReturn(const FirebaseUserData(
        id: userId,
        email: email,
      ));

      mainViewModel.setInitialCurrentUserState();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(mainViewModel.state, const CommonState(data: MainState()));
      verify(() => currentUserStateController.update(any(
            that: isA<FirebaseUserData Function(FirebaseUserData)>().having(
              (e) => e.invoke(any()),
              'closure output',
              const FirebaseUserData(id: userId, email: email),
            ),
          ))).called(1);
    });
  });

  group('listenToCurrentUser', () {
    test('when `user.id` is empty', () async {
      const userId = 'user133';
      const user = FirebaseUserData(id: '');
      when(() => appPreferences.userId).thenReturn(userId);
      when(() => firebaseFirestoreService.getUserDetailStream(userId))
          .thenAnswer((_) => Stream.fromIterable([user]));
      when(() => navigator.showDialog(any())).thenAnswer((_) async => null);
      when(() => appPreferences.clearCurrentUserData()).thenAnswer((_) async {});
      when(() => navigator.replaceAll(any())).thenAnswer((_) async {});

      mainViewModel.listenToCurrentUser();

      // wait for the stream to emit the user
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => navigator.showDialog(any())).called(1);
      verify(() => appPreferences.clearCurrentUserData()).called(1);
      verify(() => navigator.replaceAll([const LoginRoute()])).called(1);
      verify(() => currentUserStateController.update(any(
            that: isA<FirebaseUserData Function(FirebaseUserData)>()
                .having((e) => e.invoke(any()), 'closure output', const FirebaseUserData()),
          ))).called(1);
    });

    test('when `user.id` is not empty', () async {
      const userId = 'user133';
      const user = FirebaseUserData(id: 'user133');
      when(() => appPreferences.userId).thenReturn(userId);
      when(() => firebaseFirestoreService.getUserDetailStream(userId))
          .thenAnswer((_) => Stream.fromIterable([user]));

      mainViewModel.listenToCurrentUser();

      // wait for the stream to emit the user
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => currentUserStateController.update(any(
            that: isA<FirebaseUserData Function(FirebaseUserData)>()
                .having((e) => e.invoke(any()), 'closure output', user),
          ))).called(1);
    });
  });

  group('initLocalPushNotification', () {
    test('when callback `onNavigate` is called', () async {
      const conversationId = '12345';
      when(() => localPushNotificationHelper.init(any())).thenAnswer((invocation) async {
        invocation.positionalArguments.first.call(conversationId);
      });
      when(() => navigator.getCurrentRouteName()).thenReturn(HomeRoute.name);
      when(() => navigator.push(any())).thenAnswer((_) => Future.value(null));

      await mainViewModel.initLocalPushNotification();

      verify(() => localPushNotificationHelper.init(captureAny(
            that: isA<Future<void> Function(String)>(),
          ))).called(1);
      verify(() => navigator.getCurrentRouteName()).called(1);
      verify(() => navigator.push(
            ChatRoute(conversation: const FirebaseConversationData(id: conversationId)),
          )).called(1);
    });
  });

  group('listenOnDeviceTokenRefresh', () {
    test('when `firebaseMessagingService.onTokenRefresh` emits a non-empty value', () async {
      const deviceToken = 'token123';

      when(() => firebaseMessagingService.onTokenRefresh)
          .thenAnswer((_) => Stream.value(deviceToken));
      when(() => appPreferences.saveDeviceToken(deviceToken)).thenAnswer((_) async => true);

      mainViewModel.listenOnDeviceTokenRefresh();
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => appPreferences.saveDeviceToken(deviceToken)).called(1);
    });
  });

  group('getInitialMessage', () {
    test('when `firebaseMessagingService.initialMessage` is not null', () async {
      const appNotification = AppNotification(conversationId: 'abc123');
      final remoteMessage = RemoteMessage(
        data: {
          Constant.fcmConversationId: appNotification.conversationId,
        },
      );
      when(() => firebaseMessagingService.initialMessage).thenAnswer((_) async => remoteMessage);
      when(() => remoteMessageAppNotificationMapper.mapToLocal(remoteMessage))
          .thenReturn(appNotification);
      when(() => navigator.getCurrentRouteName()).thenReturn(HomeRoute.name);
      when(() => navigator.push(any())).thenAnswer((_) => Future.value(null));

      await mainViewModel.getInitialMessage();

      verify(() => remoteMessageAppNotificationMapper.mapToLocal(remoteMessage)).called(1);
      verify(() => navigator.getCurrentRouteName()).called(1);
      verify(() => navigator.push(ChatRoute(
            conversation: FirebaseConversationData(id: appNotification.conversationId),
          ))).called(1);
    });
  });

  group('listenOnMessageOpenedApp', () {
    test('when `firebaseMessagingService.onMessageOpenedApp` emits a non-empty value', () async {
      const appNotification = AppNotification(conversationId: 'abc123');
      final remoteMessage = RemoteMessage(
        data: {
          Constant.fcmConversationId: appNotification.conversationId,
        },
      );
      when(() => firebaseMessagingService.onMessageOpenedApp)
          .thenAnswer((_) => Stream.value(remoteMessage));
      when(() => localPushNotificationHelper.cancelAll()).thenAnswer((_) async {});
      when(() => remoteMessageAppNotificationMapper.mapToLocal(remoteMessage))
          .thenReturn(appNotification);
      when(() => navigator.getCurrentRouteName()).thenReturn(HomeRoute.name);
      when(() => navigator.push(any())).thenAnswer((_) => Future.value(null));

      mainViewModel.listenOnMessageOpenedApp();
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => localPushNotificationHelper.cancelAll()).called(1);
      verify(() => remoteMessageAppNotificationMapper.mapToLocal(remoteMessage)).called(1);
      verify(() => navigator.push(ChatRoute(
            conversation: FirebaseConversationData(id: appNotification.conversationId),
          ))).called(1);
    });
  });

  group('goToChatPage', () {
    test('when `conversationId` is empty', () async {
      const conversationId = '';
      const appNotification = AppNotification(conversationId: conversationId);

      await mainViewModel.goToChatPage(appNotification);

      verifyNever(() => navigator.push(any()));
      verifyNever(() => navigator.pop());
    });

    test('when `conversationId` is not empty and current page is not ChatPage', () async {
      const conversationId = '123321';
      const appNotification = AppNotification(conversationId: conversationId);

      when(() => navigator.getCurrentRouteName()).thenReturn(HomeRoute.name);
      when(() => navigator.push(any())).thenAnswer((_) => Future.value(null));

      await mainViewModel.goToChatPage(appNotification);

      verify(() => navigator.push(
            ChatRoute(conversation: const FirebaseConversationData(id: conversationId)),
          )).called(1);
      verifyNever(() => navigator.pop());
    });

    test(
      'when `conversationId` is not empty and current page is ChatPage and current conversationId is equal to the conversationId of destination',
      () async {
        const conversationId = '123123';
        const appNotification = AppNotification(conversationId: conversationId);

        when(() => navigator.getCurrentRouteName()).thenReturn(ChatRoute.name);
        final routeDate = _FakeRouteData(conversationId);
        when(() => navigator.getCurrentRouteData()).thenReturn(routeDate);
        when(() => navigator.push(any())).thenAnswer((_) => Future.value(null));
        when(() => navigator.pop()).thenAnswer((_) => Future.value(true));

        await mainViewModel.goToChatPage(appNotification);

        verifyNever(() => navigator.push(any()));
        verifyNever(() => navigator.pop());
      },
    );

    test(
      'when `conversationId` is not empty and current page is ChatPage and current conversationId is not equal to the conversationId of destination',
      () async {
        const conversationId = '1230';
        const destinationConversationId = '456';
        const appNotification = AppNotification(conversationId: conversationId);

        when(() => navigator.getCurrentRouteName()).thenReturn(ChatRoute.name);
        final routeDate = _FakeRouteData(destinationConversationId);
        when(() => navigator.getCurrentRouteData()).thenReturn(routeDate);
        when(() => navigator.push(any())).thenAnswer((_) => Future.value(null));
        when(() => navigator.pop()).thenAnswer((_) => Future.value(true));

        await mainViewModel.goToChatPage(appNotification);

        verify(() => navigator.push(ChatRoute(
              conversation: const FirebaseConversationData(id: destinationConversationId),
            ))).called(1);
        verify(() => navigator.pop()).called(1);
      },
    );
  });
}
