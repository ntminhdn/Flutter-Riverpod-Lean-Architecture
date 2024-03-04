import 'package:dartx/dartx.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'all_users_state.freezed.dart';

@freezed
class AllUsersState extends BaseState with _$AllUsersState {
  const AllUsersState._();

  const factory AllUsersState({
    @Default('') String keyword,
    @Default(<FirebaseUserData>[]) List<FirebaseUserData> allUsersExceptMembers,
    @Default(<String>[]) List<String> selectedUsers, // ban đầu rỗng
    @Default(<FirebaseConversationUserData>[]) List<FirebaseConversationUserData> conversationUsers,
    @Default(<String>[]) List<String> selectedConversationUsers, // ban đầu = conversationUsers
  }) = _AllUsersState;

  List<FirebaseUserData> get filteredUsers {
    return allUsersExceptMembers
        .filter((element) => element.email.containsIgnoreCase(keyword))
        .toList();
  }

  bool get isAddButtonEnabled => selectedUsers.isNotEmpty || selectedConversationUsers.length > 1;
}
