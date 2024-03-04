import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import '../../../../../common/index.dart';

void main() {
  group('initState', () {
    group('test', () {
      final seed = _renameConversationState(
        const RenameConversationState(),
      );
      const dummyConversationId = '1';
      const dummyMembers = [
        FirebaseConversationUserData(userId: '1', email: 'email1'),
        FirebaseConversationUserData(userId: '2', email: 'email2'),
        FirebaseConversationUserData(userId: '3', email: 'email3'),
      ];
      const dummyFilteredMembers = [
        FirebaseConversationUserData(userId: '1', email: 'email1'),
        FirebaseConversationUserData(userId: '2', email: 'email2'),
      ];
      const expectedMembers = [
        FirebaseConversationUserData(userId: '1', email: 'nickname1'),
        FirebaseConversationUserData(userId: '2', email: 'nickname2'),
      ];

      stateNotifierTest(
        'when conversation input is not null',
        seed: () => [seed],
        setUp: () {
          when(() => appPreferences.userId).thenReturn('3');
          when(() => sharedViewModel.getRenamedMembers(
                members: dummyFilteredMembers,
                conversationId: dummyConversationId,
              )).thenReturn(expectedMembers);
        },
        actions: (vm) => vm.initState(),
        expect: () {
          final state1 = seed.copyWithData(members: expectedMembers);

          return [seed, state1];
        },
        build: () => RenameConversationViewModel(
          const FirebaseConversationData(id: dummyConversationId, members: dummyMembers),
          ref,
        ),
      );
    });
  });

  group('renameUser', () {
    group('test', () {
      const renamedUserId = '1';
      const oldNickName = 'nickname1';
      const newNickName = 'newNickname1';

      const notRenamedMember = FirebaseConversationUserData(userId: '2', email: 'nickname2');

      const dummyRenamedMembers = [
        FirebaseConversationUserData(userId: renamedUserId, email: oldNickName),
        notRenamedMember,
      ];
      final seed = _renameConversationState(
        const RenameConversationState(
          members: dummyRenamedMembers,
        ),
      );

      const expectedRenamedMembers = [
        FirebaseConversationUserData(userId: renamedUserId, email: newNickName),
        notRenamedMember,
      ];
      const dummyConversationId = '1';

      stateNotifierTest(
        'when conversation input is not null',
        seed: () => [seed],
        setUp: () {
          when(() => appPreferences.saveUserNickname(
                conversationId: dummyConversationId,
                memberId: renamedUserId,
                nickname: newNickName,
              )).thenAnswer((_) async => true);
          when(() => sharedViewModel.getRenamedMembers(
                members: dummyRenamedMembers,
                conversationId: dummyConversationId,
              )).thenReturn(expectedRenamedMembers);
          when(() => conversationMembersMapStateController.update(any()))
              .thenAnswer((invocation) => {});
        },
        actions: (vm) => vm.renameUser(
          memberId: renamedUserId,
          nickname: newNickName,
        ),
        expect: () {
          final state1 = seed.copyWithData(members: expectedRenamedMembers);

          return [seed, state1];
        },
        verify: (vm) {
          verify(() => conversationMembersMapStateController.update(any())).called(1);
        },
        build: () => RenameConversationViewModel(
          const FirebaseConversationData(id: dummyConversationId),
          ref,
        ),
      );
    });
  });
}

CommonState<RenameConversationState> _renameConversationState(RenameConversationState data) =>
    CommonState(data: data);

extension RenameConversationStateExt on CommonState<RenameConversationState> {
  CommonState<RenameConversationState> copyWithData({
    List<FirebaseConversationUserData>? members,
  }) {
    return copyWith(
      data: data.copyWith(
        members: members ?? data.members,
      ),
    );
  }
}
