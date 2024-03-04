import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('isAddButtonEnabled', () {
    test('when `selectedUsers` is empty', () async {
      const allUsersState = AllUsersState(selectedUsers: []);
      expect(allUsersState.isAddButtonEnabled, false);
    });

    test('when `selectedUsers` is not empty', () async {
      const allUsersState = AllUsersState(selectedUsers: ['1']);
      expect(allUsersState.isAddButtonEnabled, true);
    });

    test('when `selectedConversationUsers.length` <= 1', () async {
      const allUsersState = AllUsersState(selectedConversationUsers: ['1']);
      expect(allUsersState.isAddButtonEnabled, false);
    });

    test('when `selectedConversationUsers.length` > 1', () async {
      const allUsersState = AllUsersState(selectedConversationUsers: ['1', '2']);
      expect(allUsersState.isAddButtonEnabled, true);
    });
  });

  group('filteredUsers', () {
    test('when `keyword` is empty', () async {
      const allUsersState = AllUsersState(
        allUsersExceptMembers: [
          FirebaseUserData(email: 'a'),
          FirebaseUserData(email: 'b'),
        ],
      );
      expect(allUsersState.filteredUsers, const [
        FirebaseUserData(email: 'a'),
        FirebaseUserData(email: 'b'),
      ]);
    });

    test('when `keyword` is not empty', () async {
      const allUsersState = AllUsersState(
        keyword: 'a',
        allUsersExceptMembers: [
          FirebaseUserData(email: 'a'),
          FirebaseUserData(email: 'b'),
        ],
      );
      expect(allUsersState.filteredUsers, const [
        FirebaseUserData(email: 'a'),
      ]);
    });
  });
}
