import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  late MessageDataMapper messageDataMapper;
  const conversationId = '1';

  setUp(() {
    messageDataMapper = MessageDataMapper(
      appPreferences,
      conversationId,
    );
  });

  group('mapToLocal', () {
    test('when `data` is null', () async {
      withClock(Clock.fixed(DateTime(2023, 1, 18)), () {
        when(() => appPreferences.userId).thenReturn('2');

        final result = messageDataMapper.mapToLocal(null);

        expect(
          result,
          LocalMessageData(
            userId: '2',
            conversationId: '1',
            uniqueID: '',
            senderId: '',
            message: '',
            type: MessageType.text,
            status: MessageStatus.sent,
            createdAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
            updatedAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
            replyMessage: null,
          ),
        );
      });
    });

    test('when `data` is not null', () async {
      when(() => appPreferences.userId).thenReturn('2');

      final result = messageDataMapper.mapToLocal(FirebaseMessageData(
        id: '1',
        senderId: '2',
        message: 'message',
        type: MessageType.text,
        createdAt: DateTime(2023, 1, 18),
        updatedAt: DateTime(2023, 1, 18),
        replyMessage: const FirebaseReplyMessageData(
          replyToMessageId: '1',
          type: MessageType.text,
          replyToMessage: 'replyToMessage',
          replyByUserId: '2',
          replyToUserId: '1',
        ),
      ));

      expect(
        result,
        LocalMessageData(
          userId: '2',
          conversationId: '1',
          uniqueID: '1',
          senderId: '2',
          message: 'message',
          type: MessageType.text,
          status: MessageStatus.sent,
          createdAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
          updatedAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
          replyMessage: LocalReplyMessageData(
            userId: '2',
            repplyToMessageId: '1',
            type: MessageType.text,
            repplyToMessage: 'replyToMessage',
            replyByUserId: '2',
            replyToUserId: '1',
          ),
        ),
      );
    });
  });

  group('mapToRemote', () {
    test('when `replyMessage` is null', () {
      final result = messageDataMapper.mapToRemote(LocalMessageData(
        conversationId: '1',
        senderId: '2',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        uniqueID: '1',
        userId: '2',
        createdAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
        updatedAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
        replyMessage: null,
      ));

      expect(
        result,
        const FirebaseMessageData(
          id: '1',
          senderId: '2',
          message: 'message',
          type: MessageType.text,
          replyMessage: null,
          createdAt: null,
          updatedAt: null,
        ),
      );
    });

    test('when `replyMessage` is not null', () {
      final result = messageDataMapper.mapToRemote(LocalMessageData(
        conversationId: '1',
        senderId: '2',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        uniqueID: '1',
        userId: '2',
        createdAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
        updatedAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
        replyMessage: LocalReplyMessageData(
          userId: '2',
          repplyToMessageId: '1',
          type: MessageType.text,
          repplyToMessage: 'replyToMessage',
          replyByUserId: '2',
          replyToUserId: '1',
        ),
      ));

      expect(
        result,
        const FirebaseMessageData(
          id: '1',
          senderId: '2',
          message: 'message',
          type: MessageType.text,
          replyMessage: FirebaseReplyMessageData(
            replyToMessageId: '1',
            type: MessageType.text,
            replyToMessage: 'replyToMessage',
            replyByUserId: '2',
            replyToUserId: '1',
          ),
          createdAt: null,
          updatedAt: null,
        ),
      );
    });
  });
}
