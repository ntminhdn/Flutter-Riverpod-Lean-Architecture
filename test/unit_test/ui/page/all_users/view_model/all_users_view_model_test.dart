import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import '../../../../../common/index.dart';

void main() {
  group('initState', () {
    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(),
      );
      stateNotifierTest(
        'when conversation input is null',
        seed: () => [seed],
        setUp: () {
          when(() => firebaseFirestoreService.getUsersExceptMembersStream(any()))
              .thenAnswer((invocation) => const Stream.empty());
          when(() => appPreferences.userId).thenReturn('');
        },
        actions: (vm) => vm.initState(),
        expect: () => [
          seed,
          seed,
        ],
        verify: (vm) {
          verify(() => firebaseFirestoreService.getUsersExceptMembersStream(any())).called(1);
        },
        build: () => AllUsersViewModel(null, ref),
      );
    });

    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(),
      );
      stateNotifierTest(
        'when conversation input is not null',
        seed: () => [seed],
        setUp: () {
          when(() => firebaseFirestoreService.getUsersExceptMembersStream(any()))
              .thenAnswer((invocation) => const Stream.empty());
          when(() => appPreferences.userId).thenReturn('');
          when(() => sharedViewModel.getRenamedMembers(
                members: any(named: 'members'),
                conversationId: any(named: 'conversationId'),
              )).thenReturn([]);
        },
        actions: (vm) => vm.initState(),
        expect: () {
          final state1 = seed.copyWithData(
            conversationUsers: [],
            selectedConversationUsers: ['1', '2'],
          );

          return [seed, state1];
        },
        verify: (vm) {
          verify(() => firebaseFirestoreService.getUsersExceptMembersStream(any())).called(1);
        },
        build: () => AllUsersViewModel(
          const FirebaseConversationData(id: '1', members: [
            FirebaseConversationUserData(userId: '1'),
            FirebaseConversationUserData(userId: '2'),
          ]),
          ref,
        ),
      );
    });
  });

  group('isUserChecked', () {
    test('when `selectedUsers` contains `userId`', () {
      final vm = AllUsersViewModel(null, ref);
      vm.state = _allUsersState(const AllUsersState(selectedUsers: ['1']));

      expect(vm.isUserChecked('1'), true);
    });

    test('when `selectedUsers` does not contain `userId`', () {
      final vm = AllUsersViewModel(null, ref);
      vm.state = _allUsersState(const AllUsersState(selectedUsers: ['2']));

      expect(vm.isUserChecked('1'), false);
    });
  });

  group('isConversationUserChecked', () {
    test('when `selectedConversationUsers` contains `userId`', () {
      final vm = AllUsersViewModel(null, ref);
      vm.state = _allUsersState(const AllUsersState(selectedConversationUsers: ['1']));

      expect(vm.isConversationUserChecked('1'), true);
    });

    test('when `selectedConversationUsers` does not contain `userId`', () {
      final vm = AllUsersViewModel(null, ref);
      vm.state = _allUsersState(const AllUsersState(selectedConversationUsers: ['2']));

      expect(vm.isConversationUserChecked('1'), false);
    });
  });

  group('selectUser', () {
    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(
          selectedUsers: ['1'],
        ),
      );
      stateNotifierTest(
        'when `selectedUsers` contains `userId`',
        seed: () => [seed],
        actions: (vm) => vm.selectUser('1'),
        expect: () {
          final state1 = seed.copyWithData(selectedUsers: ['1', '1']);
          return [seed, state1];
        },
        build: () => AllUsersViewModel(null, ref),
      );
    });

    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(
          selectedUsers: ['2'],
        ),
      );
      stateNotifierTest(
        'when `selectedUsers` does not contain `userId`',
        seed: () => [seed],
        actions: (vm) => vm.selectUser('1'),
        expect: () {
          final state1 = seed.copyWithData(selectedUsers: ['2', '1']);
          return [seed, state1];
        },
        build: () => AllUsersViewModel(null, ref),
      );
    });
  });

  group('unselectUser', () {
    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(
          selectedUsers: ['1', '2'],
        ),
      );
      stateNotifierTest(
        'when `selectedUsers` contains `userId`',
        seed: () => [seed],
        actions: (vm) => vm.unselectUser('1'),
        expect: () {
          final state1 = seed.copyWithData(selectedUsers: ['2']);
          return [seed, state1];
        },
        build: () => AllUsersViewModel(null, ref),
      );
    });

    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(
          selectedUsers: ['2'],
        ),
      );
      stateNotifierTest(
        'when `selectedUsers` does not contain `userId`',
        seed: () => [seed],
        actions: (vm) => vm.unselectUser('1'),
        expect: () {
          return [seed, seed];
        },
        build: () => AllUsersViewModel(null, ref),
      );
    });
  });

  group('selectConversationUser', () {
    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(
          selectedConversationUsers: ['1'],
        ),
      );
      stateNotifierTest(
        'when `selectedConversationUsers` contains `userId`',
        seed: () => [seed],
        actions: (vm) => vm.selectConversationUser('1'),
        expect: () {
          final state1 = seed.copyWithData(selectedConversationUsers: ['1', '1']);
          return [seed, state1];
        },
        build: () => AllUsersViewModel(null, ref),
      );
    });

    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(
          selectedConversationUsers: ['2'],
        ),
      );
      stateNotifierTest(
        'when `selectedConversationUsers` does not contain `userId`',
        seed: () => [seed],
        actions: (vm) => vm.selectConversationUser('1'),
        expect: () {
          final state1 = seed.copyWithData(selectedConversationUsers: ['2', '1']);
          return [seed, state1];
        },
        build: () => AllUsersViewModel(null, ref),
      );
    });
  });

  group('unselectConversationUser', () {
    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(
          selectedConversationUsers: ['1', '2'],
        ),
      );
      stateNotifierTest(
        'when `selectedConversationUsers` contains `userId`',
        seed: () => [seed],
        actions: (vm) => vm.unselectConversationUser('1'),
        expect: () {
          final state1 = seed.copyWithData(selectedConversationUsers: ['2']);
          return [seed, state1];
        },
        build: () => AllUsersViewModel(null, ref),
      );
    });

    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(
          selectedConversationUsers: ['2'],
        ),
      );
      stateNotifierTest(
        'when `selectedConversationUsers` does not contain `userId`',
        seed: () => [seed],
        actions: (vm) => vm.unselectConversationUser('1'),
        expect: () {
          return [seed, seed];
        },
        build: () => AllUsersViewModel(null, ref),
      );
    });
  });

  group('createConversation', () {
    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(
          selectedUsers: ['1', '2'],
          allUsersExceptMembers: [
            FirebaseUserData(id: '1', email: 'email1'),
            FirebaseUserData(id: '2', email: 'email2'),
            FirebaseUserData(id: '3', email: 'email3'),
            FirebaseUserData(id: '4', email: 'email4'),
          ],
        ),
      );

      const conversation = FirebaseConversationData();
      stateNotifierTest(
        'createConversation',
        seed: () => [seed],
        setUp: () {
          when(() => appPreferences.userId).thenReturn('5');
          when(() => appPreferences.email).thenReturn('email5');
          when(() => firebaseFirestoreService.createConversation(any()))
              .thenAnswer((_) async => conversation);
        },
        actions: (vm) => vm.createConversation(),
        verify: (vm) {
          verify(() => firebaseFirestoreService.createConversation(any(
                that: isA<List<FirebaseConversationUserData>>()
                    .having((e) => e.length, 'length', 3)
                    .having(
                      (e) =>
                          e.any((e) => e.userId == '5' && e.isConversationAdmin) &&
                          e.any((e) => e.userId == '1' && !e.isConversationAdmin) &&
                          e.any((e) => e.userId == '2' && !e.isConversationAdmin),
                      'elements',
                      true,
                    ),
              ))).called(1);

          verify(() => navigator.popAndPush(ChatRoute(conversation: conversation)));
        },
        build: () => AllUsersViewModel(null, ref),
      );
    });
  });

  group('addMembers', () {
    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(
          selectedUsers: ['1', '2'],
          allUsersExceptMembers: [
            FirebaseUserData(id: '1', email: 'email1'),
            FirebaseUserData(id: '2', email: 'email2'),
            FirebaseUserData(id: '3', email: 'email3'),
            FirebaseUserData(id: '4', email: 'email4'),
          ],
        ),
      );
      stateNotifierTest(
        'when conversation input is null',
        seed: () => [seed],
        actions: (vm) => vm.addMembers(),
        verify: (vm) {
          verifyNever(() => firebaseFirestoreService.addMembers(
                conversationId: any(named: 'conversationId'),
                members: any(named: 'members'),
              ));
          verifyNever(() => navigator.pop());
        },
        build: () => AllUsersViewModel(null, ref),
      );
    });

    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(
          selectedUsers: ['1', '2'],
          selectedConversationUsers: ['4', '5'],
          allUsersExceptMembers: [
            FirebaseUserData(id: '1', email: 'email1'),
            FirebaseUserData(id: '2', email: 'email2'),
            FirebaseUserData(id: '3', email: 'email3'),
            FirebaseUserData(id: '4', email: 'email4'),
          ],
          conversationUsers: [
            FirebaseConversationUserData(userId: '3', email: 'email3'),
            FirebaseConversationUserData(userId: '4', email: 'email4'),
            FirebaseConversationUserData(userId: '5', email: 'email5'),
          ],
        ),
      );
      stateNotifierTest(
        'when conversation input is not null',
        seed: () => [seed],
        setUp: () {
          when(() => appPreferences.userId).thenReturn('5');
          when(() => firebaseFirestoreService.addMembers(
                conversationId: any(named: 'conversationId'),
                members: any(named: 'members'),
              )).thenAnswer((_) async => {});
        },
        actions: (vm) => vm.addMembers(),
        verify: (vm) {
          verify(() => firebaseFirestoreService.addMembers(
                conversationId: '1',
                members: any(
                  named: 'members',
                  that: isA<List<FirebaseConversationUserData>>()
                      .having((e) => e.length, 'length', 4)
                      .having(
                        (e) =>
                            e.any((e) => e.userId == '5' && e.isConversationAdmin) &&
                            e.any((e) => e.userId == '1' && !e.isConversationAdmin) &&
                            e.any((e) => e.userId == '2' && !e.isConversationAdmin) &&
                            e.any((e) => e.userId == '4' && !e.isConversationAdmin),
                        'elements',
                        true,
                      ),
                ),
              )).called(1);
          verify(() => navigator.pop()).called(1);
        },
        build: () => AllUsersViewModel(const FirebaseConversationData(id: '1'), ref),
      );
    });
  });

  group('setKeyWord', () {
    group('test', () {
      final seed = _allUsersState(
        const AllUsersState(),
      );
      stateNotifierTest(
        'setKeyWord',
        seed: () => [seed],
        actions: (vm) => vm.setKeyWord('keyword'),
        expect: () {
          final state1 = seed.copyWithData(keyword: 'keyword');
          return [seed, state1];
        },
        build: () => AllUsersViewModel(null, ref),
      );
    });
  });
}

CommonState<AllUsersState> _allUsersState(AllUsersState data) => CommonState(data: data);

extension AllUsersStateExt on CommonState<AllUsersState> {
  CommonState<AllUsersState> copyWithData({
    String? keyword,
    List<FirebaseUserData>? allUsersExceptMembers,
    List<String>? selectedUsers,
    List<FirebaseConversationUserData>? conversationUsers,
    List<String>? selectedConversationUsers,
  }) {
    return copyWith(
      data: data.copyWith(
        keyword: keyword ?? data.keyword,
        allUsersExceptMembers: allUsersExceptMembers ?? data.allUsersExceptMembers,
        selectedUsers: selectedUsers ?? data.selectedUsers,
        conversationUsers: conversationUsers ?? data.conversationUsers,
        selectedConversationUsers: selectedConversationUsers ?? data.selectedConversationUsers,
      ),
    );
  }
}
