import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  late Isar isar;
  late AppDatabase appDatabase;

  setUp(() async {
    await isar.writeTxn(() async => isar.clear());
    appDatabase = AppDatabase(isar, appPreferences);
  });

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    isar = await Isar.open(
      [
        LocalMessageDataSchema,
      ],
      directory: '',
    );
  });

  tearDownAll(() {
    isar.close();
  });

  group('putMessage', () {
    test('when `replyMessage` is not null', () async {
      final message = LocalMessageData(
        message: 'Hello',
        conversationId: '1',
        userId: '2',
        senderId: '3',
        uniqueId: '4',
        status: MessageStatus.sent,
        replyMessage: LocalReplyMessageData(
          conversationId: '1',
          replyByUserId: '3',
          replyToUserId: '4',
          replyToMessage: 'Hi',
          replyToMessageId: '5',
          type: MessageType.text,
        ),
        type: MessageType.text,
        createdAt: 1,
        updatedAt: 1,
      );

      await appDatabase.putMessage(message);

      final result = await isar.localMessageDatas.where().findAll();

      expect(result.length, 1);
      expect(
        result.first,
        isA<LocalMessageData>().having(
          (e) =>
              e.message == 'Hello' &&
              e.type == MessageType.text &&
              e.createdAt == 1 &&
              e.updatedAt == 1 &&
              e.conversationId == '1' &&
              e.userId == '2' &&
              e.senderId == '3' &&
              e.uniqueId == '4' &&
              e.status == MessageStatus.sent &&
              e.replyMessage!.conversationId == '1' &&
              e.replyMessage!.replyByUserId == '3' &&
              e.replyMessage!.replyToUserId == '4' &&
              e.replyMessage!.replyToMessage == 'Hi' &&
              e.replyMessage!.replyToMessageId == '5' &&
              e.replyMessage!.type == MessageType.text,
          'properties',
          true,
        ),
      );
    });

    test('when `replyMessage` is null', () async {
      final message = LocalMessageData(
        message: 'Hello',
        conversationId: '1',
        userId: '2',
        senderId: '3',
        uniqueId: '4',
        status: MessageStatus.sent,
        type: MessageType.text,
        createdAt: 1,
        updatedAt: 1,
      );

      await appDatabase.putMessage(message);

      final result = await isar.localMessageDatas.where().findAll();

      expect(result.length, 1);
      expect(
        result.first,
        isA<LocalMessageData>().having(
          (e) =>
              e.message == 'Hello' &&
              e.type == MessageType.text &&
              e.createdAt == 1 &&
              e.updatedAt == 1 &&
              e.conversationId == '1' &&
              e.userId == '2' &&
              e.senderId == '3' &&
              e.uniqueId == '4' &&
              e.status == MessageStatus.sent &&
              e.replyMessage == null,
          'properties',
          true,
        ),
      );
    });
  });

  group('putMessages', () {
    test('when `replyMessage` is not null', () async {
      const uniqueId = '4';
      const otherUniqueId = '5';
      final messages = [
        LocalMessageData(
          message: 'Hello',
          conversationId: '1',
          userId: '2',
          senderId: '3',
          uniqueId: uniqueId,
          status: MessageStatus.sent,
          replyMessage: LocalReplyMessageData(
            conversationId: '1',
            replyByUserId: '3',
            replyToUserId: '4',
            replyToMessage: 'Hi',
            replyToMessageId: '5',
            type: MessageType.text,
          ),
          type: MessageType.text,
          createdAt: 1,
          updatedAt: 1,
        ),
        LocalMessageData(
          message: 'Hello',
          conversationId: '1',
          userId: '2',
          senderId: '3',
          uniqueId: otherUniqueId,
          status: MessageStatus.sent,
          replyMessage: LocalReplyMessageData(
            conversationId: '1',
            replyByUserId: '3',
            replyToUserId: '4',
            replyToMessage: 'Hi',
            replyToMessageId: '5',
            type: MessageType.text,
          ),
          type: MessageType.text,
          createdAt: 1,
          updatedAt: 1,
        ),
      ];

      await appDatabase.putMessages(messages);

      final result = await isar.localMessageDatas.where().findAll();

      expect(result.length, 2);
      expect(
        result.first,
        isA<LocalMessageData>().having(
          (e) =>
              e.message == 'Hello' &&
              e.type == MessageType.text &&
              e.createdAt == 1 &&
              e.updatedAt == 1 &&
              e.conversationId == '1' &&
              e.userId == '2' &&
              e.senderId == '3' &&
              e.uniqueId == '4' &&
              e.status == MessageStatus.sent &&
              e.replyMessage!.conversationId == '1' &&
              e.replyMessage!.replyByUserId == '3' &&
              e.replyMessage!.replyToUserId == '4' &&
              e.replyMessage!.replyToMessage == 'Hi' &&
              e.replyMessage!.replyToMessageId == '5' &&
              e.replyMessage!.type == MessageType.text,
          'properties',
          true,
        ),
      );
    });

    test('when `replyMessage` is null', () async {
      const uniqueId = '4';
      const otherUniqueId = '5';
      final messages = [
        LocalMessageData(
          message: 'Hello',
          conversationId: '1',
          userId: '2',
          senderId: '3',
          uniqueId: uniqueId,
          status: MessageStatus.sent,
          type: MessageType.text,
          createdAt: 1,
          updatedAt: 1,
        ),
        LocalMessageData(
          message: 'Hello',
          conversationId: '1',
          userId: '2',
          senderId: '3',
          uniqueId: otherUniqueId,
          status: MessageStatus.sent,
          type: MessageType.text,
          createdAt: 1,
          updatedAt: 1,
        ),
      ];

      await appDatabase.putMessages(messages);

      final result = await isar.localMessageDatas.where().findAll();

      expect(result.length, 2);
      expect(
        result.first,
        isA<LocalMessageData>().having(
          (e) =>
              e.message == 'Hello' &&
              e.type == MessageType.text &&
              e.createdAt == 1 &&
              e.updatedAt == 1 &&
              e.conversationId == '1' &&
              e.userId == '2' &&
              e.senderId == '3' &&
              e.uniqueId == '4' &&
              e.status == MessageStatus.sent &&
              e.replyMessage == null,
          'properties',
          true,
        ),
      );
    });

    test('when data have the same uniqueId', () async {
      const uniqueId = '4';
      final messages = [
        LocalMessageData(
          message: 'Hello',
          conversationId: '1',
          userId: '2',
          senderId: '3',
          uniqueId: uniqueId,
          status: MessageStatus.sent,
          type: MessageType.text,
          createdAt: 1,
          updatedAt: 1,
        ),
        LocalMessageData(
          message: 'Hello',
          conversationId: '1',
          userId: '2',
          senderId: '3',
          uniqueId: uniqueId,
          status: MessageStatus.sent,
          type: MessageType.text,
          createdAt: 1,
          updatedAt: 1,
        ),
      ];

      await appDatabase.putMessages(messages);

      final result = await isar.localMessageDatas.where().findAll();

      expect(result.length, 1);
    });
  });

  group('getMessagesStream', () {
    const userId = '3';
    const conversationId = '1';

    final message1 = LocalMessageData(
      message: 'Hello',
      conversationId: conversationId,
      userId: userId,
      senderId: '3',
      uniqueId: '4',
      status: MessageStatus.sent,
      type: MessageType.text,
      createdAt: 2,
      updatedAt: 1,
    )..id = 1;

    final message2 = LocalMessageData(
      message: 'Hi',
      conversationId: conversationId,
      userId: userId,
      senderId: '4',
      uniqueId: '5',
      status: MessageStatus.sent,
      type: MessageType.text,
      createdAt: 1,
      updatedAt: 1,
    )..id = 2;

    final message3 = LocalMessageData(
      message: 'Abc',
      conversationId: conversationId,
      userId: userId,
      senderId: '5',
      uniqueId: '6',
      status: MessageStatus.sent,
      type: MessageType.text,
      createdAt: 3,
      updatedAt: 1,
    )..id = 3;

    final message4 = LocalMessageData(
      message: 'Minh',
      conversationId: '22222222222',
      userId: userId,
      senderId: '6',
      uniqueId: '7',
      status: MessageStatus.sent,
      type: MessageType.text,
      createdAt: 4,
      updatedAt: 1,
    )..id = 4;

    final message5 = LocalMessageData(
      message: 'Haha',
      conversationId: conversationId,
      userId: '999999999',
      senderId: '6',
      uniqueId: '8',
      status: MessageStatus.sent,
      type: MessageType.text,
      createdAt: 4,
      updatedAt: 1,
    )..id = 5;

    setUp(() {
      when(() => appPreferences.userId).thenReturn(userId);
    });

    test('when Isar emits events', () async {
      await isar.writeTxn(() async {
        await isar.localMessageDatas.put(message1);
        await isar.localMessageDatas.put(message2);
        await isar.localMessageDatas.put(message3);
        await isar.localMessageDatas.put(message4);
        await isar.localMessageDatas.put(message5);
      });

      final result = appDatabase.getMessagesStream(conversationId);
      expect(result, emits([message3, message1, message2]));
    });

    test('when Isar does not emit any events', () async {
      expect(appDatabase.getMessagesStream(conversationId), emits([]));
    });
  });

  group('getLatestMessages', () {
    const userId = '3';
    const conversationId = '1';

    final message1 = LocalMessageData(
      message: 'Hello',
      conversationId: conversationId,
      userId: userId,
      senderId: '3',
      uniqueId: '4',
      status: MessageStatus.sent,
      type: MessageType.text,
      createdAt: 2,
      updatedAt: 1,
    )..id = 1;

    final message2 = LocalMessageData(
      message: 'Hi',
      conversationId: conversationId,
      userId: userId,
      senderId: '4',
      uniqueId: '5',
      status: MessageStatus.sent,
      type: MessageType.text,
      createdAt: 1,
      updatedAt: 1,
    )..id = 2;

    final message3 = LocalMessageData(
      message: 'Abc',
      conversationId: conversationId,
      userId: userId,
      senderId: '5',
      uniqueId: '6',
      status: MessageStatus.sent,
      type: MessageType.text,
      createdAt: 3,
      updatedAt: 1,
    )..id = 3;

    final message4 = LocalMessageData(
      message: 'Minh',
      conversationId: '22222222222',
      userId: userId,
      senderId: '6',
      uniqueId: '7',
      status: MessageStatus.sent,
      type: MessageType.text,
      createdAt: 4,
      updatedAt: 1,
    )..id = 4;

    final message5 = LocalMessageData(
      message: 'Haha',
      conversationId: conversationId,
      userId: '999999999',
      senderId: '6',
      uniqueId: '8',
      status: MessageStatus.sent,
      type: MessageType.text,
      createdAt: 4,
      updatedAt: 1,
    )..id = 5;

    setUp(() {
      when(() => appPreferences.userId).thenReturn(userId);
    });

    test('when conversationId is valid', () async {
      await isar.writeTxn(() async {
        await isar.localMessageDatas.put(message1);
        await isar.localMessageDatas.put(message2);
        await isar.localMessageDatas.put(message3);
        await isar.localMessageDatas.put(message4);
        await isar.localMessageDatas.put(message5);
      });

      final result = appDatabase.getLatestMessages(conversationId);
      expect(result, hasLength(3));
      expect(result, [message3, message1, message2]);
    });

    test('when conversationId is invalid', () async {
      await isar.writeTxn(() async {
        await isar.localMessageDatas.put(message1);
        await isar.localMessageDatas.put(message2);
        await isar.localMessageDatas.put(message3);
        await isar.localMessageDatas.put(message4);
        await isar.localMessageDatas.put(message5);
      });

      final result = appDatabase.getLatestMessages('invalid');
      expect(result, isEmpty);
    });

    test('when conversationId is valid and the number of messages exceeds the limit', () async {
      await isar.writeTxn(() async {
        for (var i = 0; i < Constant.itemsPerPage + 10; i++) {
          await isar.localMessageDatas.put(
            LocalMessageData(
              message: 'Hello',
              conversationId: conversationId,
              userId: userId,
              senderId: '3',
              uniqueId: i.toString(),
              status: MessageStatus.sent,
              type: MessageType.text,
              createdAt: 1,
              updatedAt: 1,
            ),
          );
        }
      });

      final result = appDatabase.getLatestMessages(conversationId);
      expect(result.length, Constant.itemsPerPage);
    });
  });

  group('removeMessagesByConversationId', () {
    const userId = '3';
    const conversationId = '1';

    final message1 = LocalMessageData(
      message: 'Hello',
      conversationId: conversationId,
      userId: userId,
      senderId: '3',
      uniqueId: '4',
      status: MessageStatus.sent,
      type: MessageType.text,
      createdAt: 1,
      updatedAt: 1,
    );

    final message2 = LocalMessageData(
      message: 'Hi',
      conversationId: conversationId,
      userId: userId,
      senderId: '4',
      uniqueId: '5',
      status: MessageStatus.sent,
      type: MessageType.text,
      createdAt: 1,
      updatedAt: 1,
    );

    setUp(() {
      when(() => appPreferences.userId).thenReturn(userId);
    });

    test('when conversationId is valid', () async {
      await isar.writeTxn(() async {
        await isar.localMessageDatas.put(message1);
        await isar.localMessageDatas.put(message2);
      });

      await appDatabase.removeMessagesByConversationId(conversationId);

      final result = await isar.localMessageDatas.where().findAll();

      expect(result, isEmpty);
    });

    test('when conversationId is invalid', () async {
      await isar.writeTxn(() async {
        await isar.localMessageDatas.put(message1);
        await isar.localMessageDatas.put(message2);
      });

      await appDatabase.removeMessagesByConversationId('22222222222');

      final result = await isar.localMessageDatas.where().findAll();

      expect(result, hasLength(2));
    });
  });
}
