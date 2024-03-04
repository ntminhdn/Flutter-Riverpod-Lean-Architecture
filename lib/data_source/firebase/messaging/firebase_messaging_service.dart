import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../index.dart';

final firebaseMessagingServiceProvider = Provider((ref) => getIt.get<FirebaseMessagingService>());

@LazySingleton()
class FirebaseMessagingService {
  final _messaging = FirebaseMessaging.instance;

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  Future<String?> get deviceToken => _messaging.getToken();

  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  Stream<RemoteMessage> get onMessageOpenedApp => FirebaseMessaging.onMessageOpenedApp;

  Future<RemoteMessage?> get initialMessage => _messaging.getInitialMessage();

  Future<void> subscribeToTopic(String topic) async {
    Log.d('Subscribing to topic: $topic');
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    Log.d('Unsubscribing from topic: $topic');
    await _messaging.unsubscribeFromTopic(topic);
  }
}
