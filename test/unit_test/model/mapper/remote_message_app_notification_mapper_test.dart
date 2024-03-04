import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  late RemoteMessageAppNotificationMapper remoteMessageAppNotificationMapper;

  setUp(() {
    remoteMessageAppNotificationMapper = RemoteMessageAppNotificationMapper();
  });

  group('mapToLocal', () {
    test('when data is null', () async {
      final result = remoteMessageAppNotificationMapper.mapToLocal(null);

      expect(
        result,
        const AppNotification(
          title: '',
          message: '',
          image: '',
          conversationId: '',
        ),
      );
    });

    test('when data is not null', () async {
      final result = remoteMessageAppNotificationMapper.mapToLocal(const RemoteMessage(
        notification: RemoteNotification(
          title: 'title',
          body: 'body',
        ),
        data: <String, String>{
          Constant.fcmImage: 'image',
          Constant.fcmConversationId: 'conversationId',
        },
      ));

      expect(
        result,
        const AppNotification(
          title: 'title',
          message: 'body',
          image: 'image',
          conversationId: 'conversationId',
        ),
      );
    });
  });
}
