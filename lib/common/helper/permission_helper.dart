import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../index.dart';

final permissionHelperProvider = Provider<PermissionHelper>(
  (ref) => getIt.get<PermissionHelper>(),
);

@LazySingleton()
class PermissionHelper {
  Future<void> requestNotificationPermission() async {
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

// ignore: avoid_unnecessary_async_function
Future<void> _handleBackgroundMessage(RemoteMessage remoteMessage) async {
  /// If you're going to use other Firebase services in the background, such as Firestore,
  /// make sure you call `Firebase.initializeApp()` before using other Firebase services.

  // await Firebase.initializeApp();
  Log.d(
    '[FirebaseMessagingHelper] onBackgroundMessage: title: ${remoteMessage.notification?.title}\nbody: ${remoteMessage.notification?.body}\ndata: ${remoteMessage.data}',
  );
}
