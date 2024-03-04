// ignore_for_file: variable_type_mismatch
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import '../../../../../common/index.dart';

void main() {
  late ContactListViewModel contactListViewModel;

  setUp(() {
    contactListViewModel = ContactListViewModel(ref);
  });

  group('mapToConversationMembers', () {
    test('when `conversations` is not empty', () {
      const conversation1 = FirebaseConversationData(
        id: '1',
        members: [
          FirebaseConversationUserData(userId: '1', email: 'email1'),
          FirebaseConversationUserData(userId: '2', email: 'email2'),
        ],
      );
      const conversation2 = FirebaseConversationData(
        id: '2',
        members: [
          FirebaseConversationUserData(userId: '3', email: 'email3'),
          FirebaseConversationUserData(userId: '4', email: 'email4'),
        ],
      );
      const conversations = [conversation1, conversation2];
      const expected = {
        '1': [
          FirebaseConversationUserData(userId: '1', email: 'nickname1'),
          FirebaseConversationUserData(userId: '2', email: 'email2'),
        ],
        '2': [
          FirebaseConversationUserData(userId: '3', email: 'nickname3'),
          FirebaseConversationUserData(userId: '4', email: 'nickname4'),
        ],
      };

      when(() => sharedViewModel.getRenamedMembers(
            members: conversation1.members,
            conversationId: conversation1.id,
          )).thenReturn(const [
        FirebaseConversationUserData(userId: '1', email: 'nickname1'),
        FirebaseConversationUserData(userId: '2', email: 'email2'),
      ]);
      when(() => sharedViewModel.getRenamedMembers(
            members: conversation2.members,
            conversationId: conversation2.id,
          )).thenReturn(const [
        FirebaseConversationUserData(userId: '3', email: 'nickname3'),
        FirebaseConversationUserData(userId: '4', email: 'nickname4'),
      ]);

      final result = contactListViewModel.mapToConversationMembers(conversations);

      expect(result, expected);
    });

    test('when `conversations` is empty', () {
      const conversations = <FirebaseConversationData>[];
      const expected = <String, List<FirebaseConversationUserData>>{};

      final result = contactListViewModel.mapToConversationMembers(conversations);

      expect(result, expected);
    });
  });

  group('listenToConversations', () {
    group('test', () {
      final seed = _contactListState(const ContactListState());

      stateNotifierTest(
        'when `getConversationsStream` does not emit any events',
        seed: () => [seed],
        setUp: () {
          const userId = 'abc12';
          when(() => appPreferences.userId).thenReturn(userId);
          when(() => firebaseFirestoreService.getConversationsStream(userId))
              .thenAnswer((_) => Stream.fromIterable([]));
        },
        actions: (vm) => vm.listenToConversations(),
        expect: () {
          return [seed];
        },
        build: () => contactListViewModel,
      );
    });

    group('test', () {
      const conversation1 = FirebaseConversationData(
        id: '1',
        members: [
          FirebaseConversationUserData(userId: '1', email: 'email1'),
          FirebaseConversationUserData(userId: '2', email: 'email2'),
        ],
      );
      const conversation2 = FirebaseConversationData(
        id: '2',
        members: [
          FirebaseConversationUserData(userId: '3', email: 'email3'),
          FirebaseConversationUserData(userId: '4', email: 'email4'),
        ],
      );
      final seed = _contactListState(const ContactListState());

      stateNotifierTest(
        'when `getConversationsStream` emits events',
        seed: () => [seed],
        setUp: () {
          const userId = 'abc12';
          when(() => appPreferences.userId).thenReturn(userId);
          when(() => firebaseFirestoreService.getConversationsStream(userId))
              .thenAnswer((_) => Stream.fromIterable([
                    const [conversation1, conversation2],
                  ]));
        },
        actions: (vm) => vm.listenToConversations(),
        expect: () {
          final state1 = seed.copyWithData(conversationList: [conversation1, conversation2]);
          return [seed, state1];
        },
        verify: (vm) {
          verify(() => conversationMembersMapStateController.update(any())).called(1);
        },
        build: () => contactListViewModel,
      );
    });
  });

  group('deleteConversation', () {
    group('test', () {
      const conversation1 = FirebaseConversationData(id: '1');
      const conversation2 = FirebaseConversationData(id: '2');
      final seed = _contactListState(
        const ContactListState(
          conversationList: [
            conversation1,
            conversation2,
          ],
        ),
      );

      stateNotifierTest(
        'when `conversationList` contains `conversation`',
        seed: () => [seed],
        setUp: () {
          when(() => sharedViewModel.deleteConversation(conversation1)).thenAnswer((_) async => {});
        },
        actions: (vm) => vm.deleteConversation(conversation1),
        expect: () {
          final state1 = seed.copyWithData(
            conversationList: const [conversation2],
          );
          return [seed, state1];
        },
        build: () => contactListViewModel,
      );
    });

    group('test', () {
      const conversation1 = FirebaseConversationData(id: '1');
      const conversation2 = FirebaseConversationData(id: '2');
      final seed = _contactListState(
        const ContactListState(conversationList: [conversation2]),
      );

      stateNotifierTest(
        'when `conversationList` does not contain `conversation`',
        seed: () => [seed],
        setUp: () {
          when(() => sharedViewModel.deleteConversation(conversation1)).thenAnswer((_) async => {});
        },
        actions: (vm) => vm.deleteConversation(conversation1),
        expect: () {
          return [seed, seed];
        },
        build: () => contactListViewModel,
      );
    });

    group('test', () {
      const conversation1 = FirebaseConversationData(id: '1');
      const conversation2 = FirebaseConversationData(id: '2');
      final seed = _contactListState(
        const ContactListState(
          conversationList: [
            conversation1,
            conversation2,
          ],
        ),
      );
      final exception = AppUncaughtException(rootException: Exception());

      stateNotifierTest(
        'when `deleteConversation` failed',
        seed: () => [seed],
        setUp: () {
          when(() => sharedViewModel.deleteConversation(conversation1)).thenThrow(exception);
        },
        actions: (vm) => vm.deleteConversation(conversation1),
        expect: () {
          final state1 = seed.copyWithData(
            conversationList: const [conversation2],
          );
          final state2 =
              state1.copyWithData(conversationList: const [conversation2, conversation1]);
          final state3 = state2.copyWith(appException: exception);
          return [seed, state1, state2, state3];
        },
        build: () => contactListViewModel,
      );
    });
  });
}

CommonState<ContactListState> _contactListState(ContactListState data) => CommonState(data: data);

extension ContactListStateExt on CommonState<ContactListState> {
  CommonState<ContactListState> copyWithData({
    String? keyword,
    List<FirebaseConversationData>? conversationList,
  }) {
    return copyWith(
      data: data.copyWith(
        keyword: keyword ?? data.keyword,
        conversationList: conversationList ?? data.conversationList,
      ),
    );
  }
}
