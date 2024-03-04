import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../index.dart';

final localPushNotificationHelperProvider = Provider<LocalPushNotificationHelper>(
  (ref) => getIt.get<LocalPushNotificationHelper>(),
);

@LazySingleton()
class LocalPushNotificationHelper with LogMixin {
  static const _channelId = 'jp.flutter.app';
  static const _channelName = 'flutter';
  static const _channelDescription = 'flutter';
  static const _androidDefaultIcon = 'ic_app_logo';
  static const _bitCount = 31;

  int get _randomNotificationId => Random().nextInt(pow(2, _bitCount).toInt() - 1);

  Future<void> init(Future<void> Function(String) onNavigate) async {
    const androidInit = AndroidInitializationSettings(_androidDefaultIcon);

    /// don't request permission here
    /// we use firebase_messaging package to request permission instead
    const iOSInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const init = InitializationSettings(android: androidInit, iOS: iOSInit);

    /// init local notification
    await FlutterLocalNotificationsPlugin().initialize(
      init,
      onDidReceiveNotificationResponse: (details) => onSelectNotification(details, onNavigate),
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
        ));
  }

// ignore: prefer_named_parameters
  static void onSelectNotification(
    NotificationResponse payload,
    void Function(String) onNavigate,
  ) {
    if (payload.payload == null || payload.payload!.isEmpty) {
      return;
    }
    final Map<String, dynamic> data = jsonDecode(payload.payload!) as Map<String, dynamic>;
    final conversationId = data['conversation_id'] as String? ?? '';

    onNavigate(conversationId);
  }

  Future<void> notify(AppNotification notification) async {
    File? imageFile;
    if (notification.image.startsWith('http')) {
      imageFile = await FileUtil.getImageFileFromUrl(notification.image);
      logD('Downloaded Image File: $imageFile');
    }

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      autoCancel: true,
      enableVibration: true,
      playSound: true,
      styleInformation: imageFile != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(imageFile.path),
              hideExpandedLargeIcon: true,
            )
          : null,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final Map<String, dynamic> payload = <String, dynamic>{
      // FirebaseMessagingConstants.firebaseKeyConversationId: notification.conversationId,
    };

    await FlutterLocalNotificationsPlugin()
        .show(
          _randomNotificationId,
          notification.title,
          notification.message,
          platformChannelSpecifics,
          payload: jsonEncode(payload),
        )
        .onError((error, stackTrace) => logE('Can not show notification cause $error'));
  }

  Future<void> cancelAll() async => await FlutterLocalNotificationsPlugin().cancelAll();
}
