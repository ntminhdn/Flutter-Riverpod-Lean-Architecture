import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final mainViewModelProvider =
    StateNotifierProvider.autoDispose<MainViewModel, CommonState<MainState>>(
  (ref) => MainViewModel(ref),
);

class MainViewModel extends BaseViewModel<MainState> {
  MainViewModel(this._ref) : super(const CommonState(data: MainState()));

  final Ref _ref;

  @visibleForTesting
  StreamSubscription<RemoteMessage>? onMessageOpenedAppSubscription;
  @visibleForTesting
  StreamSubscription<String>? onTokenRefreshSubscription;
  @visibleForTesting
  StreamSubscription<FirebaseUserData>? currentUserSubscription;

  void _updateCurrentUser(FirebaseUserData user) => _ref.update<FirebaseUserData>(
        currentUserProvider,
        (_) => user,
      );

  FutureOr<void> init() async {
    setInitialCurrentUserState();
    listenToCurrentUser();
    await initLocalPushNotification();
    await requestPermissions();
    listenOnDeviceTokenRefresh();
    listenOnMessageOpenedApp();
    await getInitialMessage();
  }

  void setInitialCurrentUserState() {
    _updateCurrentUser(FirebaseUserData(
      id: _ref.appPreferences.userId,
      email: _ref.appPreferences.email,
    ));
  }

  void listenToCurrentUser() {
    currentUserSubscription?.cancel();
    final userId = _ref.appPreferences.userId;
    currentUserSubscription =
        _ref.firebaseFirestoreService.getUserDetailStream(userId).listen((user) async {
      // user deleted - force logout
      if (user.id.isEmpty) {
        await _ref.nav.showDialog(
          CommonPopup.forceLogout(l10n.forceLogout),
        );
        await _ref.appPreferences.clearCurrentUserData();
        _updateCurrentUser(const FirebaseUserData());
        await _ref.nav.replaceAll([const LoginRoute()]);
      } else {
        _updateCurrentUser(user);
      }
    });
  }

  Future<void> initLocalPushNotification() async {
    await _ref.localPushNotificationHelper.init((conversationId) async {
      await goToChatPage(
        AppNotification(
          conversationId: conversationId,
        ),
      );
    });
  }

  Future<void> requestPermissions() {
    return _ref.permissionHelper.requestNotificationPermission();
  }

  void listenOnDeviceTokenRefresh() {
    onTokenRefreshSubscription?.cancel();
    onTokenRefreshSubscription = _ref.firebaseMessagingService.onTokenRefresh.listen((event) async {
      if (event.isNotEmpty) {
        await _ref.appPreferences.saveDeviceToken(event);
      }
    });
  }

  void listenOnMessageOpenedApp() {
    onMessageOpenedAppSubscription?.cancel();
    onMessageOpenedAppSubscription = _ref.firebaseMessagingService.onMessageOpenedApp.listen(
      (event) async {
        await _ref.localPushNotificationHelper.cancelAll();
        await goToChatPage(_ref.remoteMessageAppNotificationMapper.mapToLocal(event));
      },
    );
  }

  Future<void> getInitialMessage() async {
    await runCatching(
      action: () async {
        final initialMessage = await _ref.firebaseMessagingService.initialMessage;
        await goToChatPage(
          _ref.remoteMessageAppNotificationMapper.mapToLocal(initialMessage),
        );
      },
      handleErrorWhen: (_) => false,
      handleLoading: false,
    );
  }

  @visibleForTesting
  Future<void> goToChatPage(AppNotification appNotification) async {
    final conversationId = appNotification.conversationId;
    if (conversationId.isEmpty) {
      return;
    }

    if (_ref.nav.getCurrentRouteName() == ChatRoute.name) {
      final routeData = _ref.nav.getCurrentRouteData();
      final arg = routeData.args as ChatRouteArgs;
      if (arg.conversation.id != conversationId) {
        await _ref.nav.pop();
        await _ref.nav.push(
          ChatRoute(
            conversation: FirebaseConversationData(id: conversationId),
          ),
        );
      }
    } else {
      await _ref.nav.push(
        ChatRoute(
          conversation: FirebaseConversationData(
            id: appNotification.conversationId,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    onMessageOpenedAppSubscription?.cancel();
    onTokenRefreshSubscription?.cancel();
    currentUserSubscription?.cancel();
    onMessageOpenedAppSubscription = null;
    onTokenRefreshSubscription = null;
    currentUserSubscription = null;
    super.dispose();
  }
}
