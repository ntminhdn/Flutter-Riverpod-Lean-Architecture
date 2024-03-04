import 'package:chatview/chatview.dart' as cv;
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import '../../../../../common/index.dart';

void main() {
  late ChatViewModel chatViewModel;
  const initialConversation = FirebaseConversationData(
    id: '1',
    members: [
      FirebaseConversationUserData(userId: '1', email: 'email1', isConversationAdmin: true),
      FirebaseConversationUserData(userId: '2', email: 'email2'),
    ],
  );

  setUp(() {
    when(() => ref.messageDataMapper('1')).thenReturn(messageDataMapper);

    chatViewModel = ChatViewModel(ref, initialConversation);
  });

  group('initState', () {
    group('test', () {
      const conversation = FirebaseConversationData(
        id: '1',
        members: [
          FirebaseConversationUserData(userId: '1', email: 'email1', isConversationAdmin: true),
          FirebaseConversationUserData(userId: '2', email: 'email2'),
        ],
      );
      final seed = _chatState(
        const ChatState(conversation: conversation),
      );

      stateNotifierTest(
        'when I am an admin',
        seed: () => [seed],
        setUp: () {
          when(() => appPreferences.userId).thenReturn('1');
        },
        actions: (vm) => vm.initState(),
        expect: () {
          final state1 = seed.copyWithData(isAdmin: true);

          return [seed, state1];
        },
        build: () => chatViewModel,
      );
    });

    group('test', () {
      const conversation = FirebaseConversationData(
        id: '1',
        members: [
          FirebaseConversationUserData(userId: '1', email: 'email1'),
          FirebaseConversationUserData(userId: '2', email: 'email2', isConversationAdmin: true),
        ],
      );
      final seed = _chatState(
        const ChatState(conversation: conversation),
      );

      stateNotifierTest(
        'when I am not an admin',
        seed: () => [seed],
        setUp: () {
          when(() => appPreferences.userId).thenReturn('3');
        },
        actions: (vm) => vm.initState(),
        expect: () {
          final state1 = seed.copyWithData(isAdmin: false);

          return [seed, state1];
        },
        build: () => chatViewModel,
      );
    });
  });

  group('oldestMessage', () {
    test('when `messages` is empty', () {
      chatViewModel.state =
          _chatState(const ChatState(conversation: initialConversation, messages: []));
      final result = chatViewModel.oldestMessage;
      expect(result, null);
    });

    test('when `messages` is not empty', () {
      final message1 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '1',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: 1,
        updatedAt: 1,
        replyMessage: null,
      );
      final message2 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '2',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: 2,
        updatedAt: 2,
        replyMessage: null,
      );

      chatViewModel.state = _chatState(
        ChatState(
          conversation: initialConversation,
          messages: [message1, message2],
        ),
      );
      final result = chatViewModel.oldestMessage;
      expect(
        result,
        message2,
      );
    });
  });

  group('latestMessage', () {
    test('when `messages` is empty', () {
      chatViewModel.state =
          _chatState(const ChatState(conversation: initialConversation, messages: []));
      final result = chatViewModel.latestMessage;
      expect(result, null);
    });

    test('when `messages` is not empty', () {
      final message1 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '1',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: 1,
        updatedAt: 1,
        replyMessage: null,
      );
      final message2 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '2',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: 2,
        updatedAt: 2,
        replyMessage: null,
      );

      chatViewModel.state = _chatState(
        ChatState(
          conversation: initialConversation,
          messages: [message1, message2],
        ),
      );
      final result = chatViewModel.latestMessage;
      expect(
        result,
        message1,
      );
    });
  });

  group('onLoadMore', () {
    group('test', () {
      final seed = _chatState(
        const ChatState(
          conversation: initialConversation,
          messages: [],
          isLastPage: false,
        ),
      );
      stateNotifierTest(
        'when `messsages` is empty',
        seed: () => [seed],
        setUp: () {},
        actions: (vm) => vm.onLoadMore(),
        expect: () {
          return [seed];
        },
        verify: (vm) {
          verifyNever(() => firebaseFirestoreService.getOlderMessages(
                conversationId: initialConversation.id,
                latestMessageId: any(named: 'latestMessageId'),
              ));
        },
        build: () => chatViewModel,
      );
    });

    group('test', () {
      final message1 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '1',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: 1,
        updatedAt: 1,
        replyMessage: null,
      );
      final message2 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '2',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: 2,
        updatedAt: 2,
        replyMessage: null,
      );
      final seed = _chatState(
        ChatState(
          conversation: initialConversation,
          messages: [message1, message2],
          isLastPage: false,
        ),
      );
      stateNotifierTest(
        'when `messsages` is not empty and `olderMessages.length` < `Constant.itemsPerPage`',
        seed: () => [seed],
        setUp: () {
          when(() => firebaseFirestoreService.getOlderMessages(
                conversationId: initialConversation.id,
                latestMessageId: message2.uniqueID,
              )).thenAnswer((_) async => []);
          when(() => messageDataMapper.mapToLocalList(any())).thenAnswer((invocation) => []);
          when(() => appDatabase.putMessages(any())).thenAnswer((_) async => {});
        },
        actions: (vm) => vm.onLoadMore(),
        expect: () {
          final state1 = seed.copyWithData(isLastPage: true);

          return [seed, state1];
        },
        verify: (vm) {
          verify(() => appDatabase.putMessages([])).called(1);
        },
        build: () => chatViewModel,
      );
    });

    group('test', () {
      final message1 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '1',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: 1,
        updatedAt: 1,
        replyMessage: null,
      );
      final message2 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '2',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: 2,
        updatedAt: 2,
        replyMessage: null,
      );
      final seed = _chatState(
        ChatState(
          conversation: initialConversation,
          messages: [message1, message2],
          isLastPage: false,
        ),
      );

      final olderFirestoreMessages = List.generate(
        Constant.itemsPerPage,
        (index) => FirebaseMessageData(
          id: '1',
          senderId: '1',
          message: 'message',
          type: MessageType.text,
          createdAt: DateTime(2023, 1, 18),
          updatedAt: DateTime(2023, 1, 18),
          replyMessage: null,
        ),
      );

      final olderLocalMessages = List.generate(
        Constant.itemsPerPage,
        (index) => LocalMessageData(
          userId: '1',
          conversationId: '1',
          uniqueID: '1',
          senderId: '1',
          message: 'message',
          type: MessageType.text,
          status: MessageStatus.sent,
          createdAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
          updatedAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
          replyMessage: null,
        ),
      );
      stateNotifierTest(
        'when `messsages` is not empty and `olderMessages.length` >= `Constant.itemsPerPage`',
        seed: () => [seed],
        setUp: () {
          when(() => firebaseFirestoreService.getOlderMessages(
                conversationId: initialConversation.id,
                latestMessageId: message2.uniqueID,
              )).thenAnswer((_) async => olderFirestoreMessages);
          when(() => messageDataMapper.mapToLocalList(any()))
              .thenAnswer((invocation) => olderLocalMessages);
          when(() => appDatabase.putMessages(any())).thenAnswer((_) async => {});
        },
        actions: (vm) => vm.onLoadMore(),
        expect: () {
          final state1 = seed.copyWithData(isLastPage: false);

          return [seed, state1];
        },
        verify: (vm) {
          verify(() => appDatabase.putMessages(olderLocalMessages)).called(1);
        },
        build: () => chatViewModel,
      );
    });
  });

  group('listenToLocalmessages', () {
    group('test', () {
      final message1 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '1',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: 1,
        updatedAt: 1,
        replyMessage: null,
      );
      final message2 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '2',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: 2,
        updatedAt: 2,
        replyMessage: null,
      );
      final seed = _chatState(
        const ChatState(
          conversation: initialConversation,
        ),
      );

      stateNotifierTest(
        'when `messsages` is not empty',
        seed: () => [seed],
        setUp: () {
          when(() => appDatabase.getMessagesStream(initialConversation.id)).thenAnswer((_) {
            return Stream.fromIterable([
              [message1, message2],
            ]);
          });
        },
        actions: (vm) => vm.listenToLocalmessages(),
        expect: () {
          final state1 = seed.copyWithData(messages: [message1, message2]);

          return [seed, state1];
        },
        build: () => chatViewModel,
      );
    });
  });

  group('listenToMessagesFromFirestore', () {
    group('test', () {
      final firebaseMessage1 = FirebaseMessageData(
        id: '1',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        createdAt: DateTime(2023, 1, 18),
        updatedAt: DateTime(2023, 1, 18),
        replyMessage: null,
      );
      final firebaseMessage2 = FirebaseMessageData(
        id: '2',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        createdAt: DateTime(2023, 1, 18),
        updatedAt: DateTime(2023, 1, 18),
        replyMessage: null,
      );
      final localMessage1 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '1',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
        updatedAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
        replyMessage: null,
      );
      final localMessage2 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '2',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
        updatedAt: DateTime(2023, 1, 18).millisecondsSinceEpoch,
        replyMessage: null,
      );

      const limit = 10;

      stateNotifierTest(
        'when `onConnectivityChanged` emits `true`',
        setUp: () {
          when(() => firebaseFirestoreService.getMessagesStream(
                conversationId: initialConversation.id,
                limit: limit,
              )).thenAnswer(
            (_) {
              return Stream.fromIterable([
                [firebaseMessage1, firebaseMessage2],
              ]);
            },
          );
          when(() => connectivityHelper.onConnectivityChanged).thenAnswer((_) {
            return Stream.fromIterable([true]);
          });
          when(() => messageDataMapper.mapToLocalList([firebaseMessage1, firebaseMessage2]))
              .thenReturn([localMessage1, localMessage2]);
          when(() => appDatabase.putMessages([localMessage1, localMessage2]))
              .thenAnswer((_) async => {});
        },
        actions: (vm) => vm.listenToMessagesFromFirestore(limit),
        verify: (vm) {
          verify(() => appDatabase.putMessages([localMessage1, localMessage2])).called(1);
        },
        build: () => chatViewModel,
      );
    });

    group('test', () {
      final firebaseMessage1 = FirebaseMessageData(
        id: '1',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        createdAt: DateTime(2023, 1, 18),
        updatedAt: DateTime(2023, 1, 18),
        replyMessage: null,
      );
      final firebaseMessage2 = FirebaseMessageData(
        id: '2',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        createdAt: DateTime(2023, 1, 18),
        updatedAt: DateTime(2023, 1, 18),
        replyMessage: null,
      );
      const limit = 10;

      stateNotifierTest(
        'when `onConnectivityChanged` emits `false`',
        setUp: () {
          when(() => firebaseFirestoreService.getMessagesStream(
                conversationId: initialConversation.id,
                limit: limit,
              )).thenAnswer(
            (_) {
              return Stream.fromIterable([
                [firebaseMessage1, firebaseMessage2],
              ]);
            },
          );
          when(() => connectivityHelper.onConnectivityChanged).thenAnswer((_) {
            return Stream.fromIterable([false]);
          });
        },
        actions: (vm) => vm.listenToMessagesFromFirestore(limit),
        verify: (vm) {
          verifyNever(() => appDatabase.putMessages(any()));
        },
        build: () => chatViewModel,
      );
    });

    group('test', () {
      const limit = 10;
      stateNotifierTest(
        'when `firebaseFirestoreService.getMessagesStream` emits an error',
        setUp: () {
          when(() => firebaseFirestoreService.getMessagesStream(
                conversationId: initialConversation.id,
                limit: limit,
              )).thenAnswer((_) {
            return Stream.error('error');
          });
          when(() => connectivityHelper.onConnectivityChanged).thenAnswer((_) {
            return Stream.value(true);
          });
        },
        actions: (vm) => vm.listenToMessagesFromFirestore(limit),
        verify: (vm) {
          verifyNever(() => appDatabase.putMessages(any()));
        },
        build: () => chatViewModel,
      );
    });
  });

  group('listenToConversationDetail', () {
    group('test', () {
      const newConversation = FirebaseConversationData(
        id: '1',
        members: [
          FirebaseConversationUserData(userId: '1', email: 'email1'),
          FirebaseConversationUserData(
            userId: '2',
            email: 'email2',
            isConversationAdmin: true,
          ),
          FirebaseConversationUserData(userId: '3', email: 'email3'),
        ],
      );
      final seed = _chatState(
        const ChatState(
          conversation: initialConversation,
        ),
      );
      stateNotifierTest(
        'when `getConversationDetailStream` emits events',
        seed: () => [seed],
        setUp: () {
          when(() => firebaseFirestoreService.getConversationDetailStream(initialConversation.id))
              .thenAnswer((_) {
            return Stream.fromIterable([newConversation]);
          });
          when(() => appPreferences.userId).thenReturn('1');
        },
        actions: (vm) => vm.listenToConversationDetail(),
        expect: () {
          final state1 = seed.copyWithData(
            conversation: newConversation,
            isAdmin: false,
          );

          return [seed, state1];
        },
        build: () => chatViewModel,
      );
    });
  });

  group('deleteConversation', () {
    group('test', () {
      final seed = _chatState(
        const ChatState(
          conversation: initialConversation,
        ),
      );
      stateNotifierTest(
        'when `conversation` is not null',
        seed: () => [seed],
        setUp: () {
          when(() => sharedViewModel.deleteConversation(initialConversation))
              .thenAnswer((_) async => {});
          when(() => navigator.pop()).thenAnswer((_) async => true);
        },
        actions: (vm) => vm.deleteConversation(),
        verify: (vm) {
          verify(() => sharedViewModel.deleteConversation(initialConversation)).called(1);
          verify(() => navigator.pop()).called(1);
        },
        build: () => chatViewModel,
      );
    });
  });

  group('sendMessage', () {
    group('test', () {
      final now = DateTime(2024, 1, 18);
      final localMessage1 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '1',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: 1,
        updatedAt: 1,
        replyMessage: null,
      );
      final localMessage2 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '2',
        senderId: '2',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: 2,
        updatedAt: 2,
        replyMessage: null,
      );
      const newMessageId = 'doc123';
      const userId = '1';
      const message = 'messy';
      final seed = _chatState(
        ChatState(
          conversation: initialConversation,
          messages: [localMessage1, localMessage2],
        ),
      );
      final newLocalMessage = LocalMessageData(
        userId: userId,
        conversationId: initialConversation.id,
        uniqueID: newMessageId,
        senderId: userId,
        message: message,
        type: MessageType.text,
        status: MessageStatus.sending,
        createdAt: now.millisecondsSinceEpoch,
        updatedAt: now.millisecondsSinceEpoch,
        replyMessage: null,
      );
      final newRemoteMessage = FirebaseMessageData(
        id: newMessageId,
        senderId: userId,
        message: message,
        type: MessageType.text,
        createdAt: now,
        updatedAt: now,
        replyMessage: null,
      );
      stateNotifierTest(
        'when `clock.now` > `latestMessageCreatedAt` and `replyMessage` is null',
        seed: () => [seed],
        setUp: () {
          when(() => appPreferences.userId).thenReturn(userId);
          when(() => firebaseFirestoreService.createMessageId(initialConversation.id))
              .thenReturn(newMessageId);
          when(() => messageDataMapper.mapToRemote(newLocalMessage)).thenReturn(newRemoteMessage);
          when(() => appDatabase.putMessage(newLocalMessage)).thenAnswer((_) async => {});
          when(() => firebaseFirestoreService.createMessage(
                currentUserId: userId,
                conversationId: initialConversation.id,
                message: newRemoteMessage,
              )).thenAnswer((_) async => {});
        },
        actions: (vm) => withClock(Clock.fixed(now), () {
          vm.sendMessage(message: message, replyMessage: null);
        }),
        verify: (vm) {
          verify(() => appDatabase.putMessage(newLocalMessage)).called(1);
          verify(() => firebaseFirestoreService.createMessage(
                currentUserId: userId,
                conversationId: initialConversation.id,
                message: newRemoteMessage,
              )).called(1);
        },
        build: () => chatViewModel,
      );
    });

    group('test', () {
      final now = DateTime(1994, 1, 18);
      final latestMessageCreatedAt = DateTime(2023, 1, 18);
      final newMessageCreatedAt = latestMessageCreatedAt.millisecondsSinceEpoch + 1;
      final localMessage1 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '1',
        senderId: '1',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: latestMessageCreatedAt.millisecondsSinceEpoch,
        updatedAt: latestMessageCreatedAt.millisecondsSinceEpoch,
        replyMessage: null,
      );
      final localMessage2 = LocalMessageData(
        userId: '1',
        conversationId: '1',
        uniqueID: '2',
        senderId: '2',
        message: 'message',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: latestMessageCreatedAt.millisecondsSinceEpoch,
        updatedAt: latestMessageCreatedAt.millisecondsSinceEpoch,
        replyMessage: null,
      );
      const newMessageId = 'doc123';
      const userId = '1';
      const message = 'messy';
      final seed = _chatState(
        ChatState(
          conversation: initialConversation,
          messages: [localMessage1, localMessage2],
        ),
      );
      final newLocalMessage = LocalMessageData(
        userId: userId,
        conversationId: initialConversation.id,
        uniqueID: newMessageId,
        senderId: userId,
        message: message,
        type: MessageType.text,
        status: MessageStatus.sending,
        createdAt: newMessageCreatedAt,
        updatedAt: newMessageCreatedAt,
        replyMessage: LocalReplyMessageData(
          conversationId: '1',
          userId: userId,
          repplyToMessageId: '1',
          type: MessageType.text,
          repplyToMessage: 'message',
          replyByUserId: userId,
          replyToUserId: '2',
        ),
      );
      final newRemoteMessage = FirebaseMessageData(
        id: newMessageId,
        senderId: userId,
        message: message,
        type: MessageType.text,
        createdAt: latestMessageCreatedAt,
        updatedAt: latestMessageCreatedAt,
        replyMessage: const FirebaseReplyMessageData(
          replyToMessageId: '1',
          type: MessageType.text,
          replyToMessage: 'message',
          replyByUserId: userId,
          replyToUserId: '2',
        ),
      );
      stateNotifierTest(
        'when `clock.now` < `latestMessageCreatedAt` and `replyMessage` is not null',
        seed: () => [seed],
        setUp: () {
          when(() => appPreferences.userId).thenReturn(userId);
          when(() => firebaseFirestoreService.createMessageId(initialConversation.id))
              .thenReturn(newMessageId);
          when(() => messageDataMapper.mapToRemote(newLocalMessage)).thenReturn(newRemoteMessage);
          when(() => appDatabase.putMessage(newLocalMessage)).thenAnswer((_) async => {});
          when(() => firebaseFirestoreService.createMessage(
                currentUserId: userId,
                conversationId: initialConversation.id,
                message: newRemoteMessage,
              )).thenAnswer((_) async => {});
        },
        actions: (vm) => withClock(Clock.fixed(now), () {
          vm.sendMessage(
            message: message,
            replyMessage: const cv.ReplyMessage(
              messageId: '1',
              messageType: cv.MessageType.text,
              message: 'message',
              replyTo: '2',
            ),
          );
        }),
        verify: (vm) {
          verify(() => appDatabase.putMessage(newLocalMessage)).called(1);
          verify(() => firebaseFirestoreService.createMessage(
                currentUserId: userId,
                conversationId: initialConversation.id,
                message: newRemoteMessage,
              )).called(1);
        },
        build: () => chatViewModel,
      );
    });
  });
}

CommonState<ChatState> _chatState(ChatState data) => CommonState(data: data);

extension ChatStateExt on CommonState<ChatState> {
  CommonState<ChatState> copyWithData({
    FirebaseConversationData? conversation,
    List<LocalMessageData>? messages,
    bool? isLastPage,
    bool? isAdmin,
  }) {
    return copyWith(
      data: data.copyWith(
        conversation: conversation ?? data.conversation,
        messages: messages ?? data.messages,
        isLastPage: isLastPage ?? data.isLastPage,
        isAdmin: isAdmin ?? data.isAdmin,
      ),
    );
  }
}
