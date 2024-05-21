import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class MockAllUsersViewModel extends StateNotifier<CommonState<AllUsersState>>
    with Mock
    implements AllUsersViewModel {
  MockAllUsersViewModel(super.state);
}

void main() {
  group('AllUsersPage', () {
    testGoldens(
      TestUtil.description(
          'when all users is not empty and members is empty and add button is enabled'),
      (tester) async {
        const selectedUserId = '1';
        final vm = MockAllUsersViewModel(
          const CommonState(
            data: AllUsersState(
              allUsersExceptMembers: [
                FirebaseUserData(id: selectedUserId, email: 'duynn'),
                FirebaseUserData(id: '2', email: 'ntminhdn'),
              ],
              selectedUsers: [selectedUserId],
            ),
          ),
        );

        when(() => vm.isUserChecked(selectedUserId)).thenReturn(true);
        when(() => vm.isUserChecked('2')).thenReturn(false);

        await tester.testWidgetWithDeviceBuilder(
          filename:
              'all_users_page/${TestUtil.filename('when_all_users_is_not_empty_and_members_is_empty_and_add_button_is_enabled')}',
          widget: const AllUsersPage(action: AllUsersPageAction.createNewConversation),
          overrides: [
            allUsersViewModelProvider.overrideWith(
              (_, __) => vm,
            ),
          ],
        );
      },
    );

    testGoldens(
      TestUtil.description(
          'when all users is empty and members is empty and add button is disabled'),
      (tester) async {
        final vm = MockAllUsersViewModel(
          const CommonState(
            data: AllUsersState(),
          ),
        );

        await tester.testWidgetWithDeviceBuilder(
          filename:
              'all_users_page/${TestUtil.filename('when_all_users_is_empty_and_members_is_empty_and_add_button_is_disabled')}',
          widget: const AllUsersPage(action: AllUsersPageAction.createNewConversation),
          overrides: [
            allUsersViewModelProvider.overrideWith(
              (_, __) => vm,
            ),
          ],
        );
      },
    );

    testGoldens(
      TestUtil.description(
          'when members is not empty and all users is not empty and add button is enabled'),
      (tester) async {
        const selectedUserId = '1';
        const me = FirebaseConversationUserData(userId: '3', email: 'thinhnd');
        final vm = MockAllUsersViewModel(
          const CommonState(
            data: AllUsersState(
              allUsersExceptMembers: [
                FirebaseUserData(id: selectedUserId, email: 'duynn'),
                FirebaseUserData(id: '2', email: 'ntminhdn'),
              ],
              selectedUsers: [selectedUserId],
              conversationUsers: [
                me,
                FirebaseConversationUserData(userId: '4', email: 'vulv'),
                FirebaseConversationUserData(userId: '5', email: 'namdv'),
              ],
            ),
          ),
        );

        when(() => vm.isUserChecked(selectedUserId)).thenReturn(true);
        when(() => vm.isUserChecked('2')).thenReturn(false);

        when(() => vm.isConversationUserChecked(me.userId)).thenReturn(true);
        when(() => vm.isConversationUserChecked(any(that: isNot(me.userId)))).thenReturn(false);

        await tester.testWidgetWithDeviceBuilder(
          filename:
              'all_users_page/${TestUtil.filename('when_members_is_not_empty_and_all_users_is_not_empty_and_add_button_is_enabled')}',
          widget: const AllUsersPage(action: AllUsersPageAction.addMembers),
          overrides: [
            allUsersViewModelProvider.overrideWith(
              (_, __) => vm,
            ),
            currentUserProvider.overrideWith((ref) => FirebaseUserData(
                  id: me.userId,
                  email: me.email,
                )),
          ],
        );
      },
    );

    testGoldens(
      TestUtil.description(
          'when members is not empty and all users is empty and add button is disabled'),
      (tester) async {
        const me = FirebaseConversationUserData(userId: '3', email: 'thinhnd');
        final vm = MockAllUsersViewModel(
          const CommonState(
            data: AllUsersState(
              conversationUsers: [
                me,
                FirebaseConversationUserData(userId: '4', email: 'vulv'),
                FirebaseConversationUserData(userId: '5', email: 'namdv'),
              ],
            ),
          ),
        );

        when(() => vm.isConversationUserChecked(any())).thenReturn(true);

        await tester.testWidgetWithDeviceBuilder(
          filename:
              'all_users_page/${TestUtil.filename('when_members_is_not_empty_and_all_users_is_empty_and_add_button_is_disabled')}',
          widget: const AllUsersPage(action: AllUsersPageAction.addMembers),
          onCreate: (tester, key) async {
            final textFieldFinder = find.byType(TextField).isDescendantOf(find.byKey(key), find);
            expect(textFieldFinder, findsExactly(1));

            await tester.enterText(
              textFieldFinder,
              'abcd',
            );
          },
          overrides: [
            allUsersViewModelProvider.overrideWith(
              (_, __) => vm,
            ),
            currentUserProvider.overrideWith((ref) => FirebaseUserData(
                  id: me.userId,
                  email: me.email,
                )),
          ],
        );
      },
    );
  });
}
