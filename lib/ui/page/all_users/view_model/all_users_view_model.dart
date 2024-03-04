import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final allUsersViewModelProvider = StateNotifierProvider.autoDispose
    .family<AllUsersViewModel, CommonState<AllUsersState>, FirebaseConversationData?>(
  (ref, conversation) => AllUsersViewModel(
    conversation,
    ref,
  ),
);

class AllUsersViewModel extends BaseViewModel<AllUsersState> {
  // ignore: prefer_named_parameters
  AllUsersViewModel(
    this._conversation,
    this._ref,
  ) : super(const CommonState(data: AllUsersState()));

  final FirebaseConversationData? _conversation;
  final Ref _ref;
  StreamSubscription<List<FirebaseUserData>>? _usersSubscription;

  void initState() {
    final initialMembers = _conversation?.members ?? [];
    final selectedConversationUsers = initialMembers.map((e) => e.userId).toList();
    data = data.copyWith(
      conversationUsers: _conversation == null
          ? []
          : _ref.sharedViewModel.getRenamedMembers(
              members: initialMembers,
              conversationId: _conversation.id,
            ),
      selectedConversationUsers: selectedConversationUsers,
    );

    listenToUsers(selectedConversationUsers);
  }

  @override
  void dispose() {
    _usersSubscription?.cancel();
    _usersSubscription = null;
    super.dispose();
  }

  void listenToUsers(List<String> selectedUsers) {
    _usersSubscription?.cancel();
    _usersSubscription = _ref.firebaseFirestoreService
        .getUsersExceptMembersStream(
      selectedUsers.isNotEmpty ? selectedUsers : [_ref.appPreferences.userId],
    )
        .listen(
      (users) {
        data = data.copyWith(allUsersExceptMembers: users);
      },
    );
  }

  bool isUserChecked(String userId) {
    return data.selectedUsers.contains(userId);
  }

  bool isConversationUserChecked(String userId) {
    return data.selectedConversationUsers.contains(userId);
  }

  void selectUser(String userId) {
    data = data.copyWith(
      selectedUsers: data.selectedUsers.plus(userId),
    );
  }

  void unselectUser(String userId) {
    final newList = data.selectedUsers.minus(userId);
    data = data.copyWith(
      selectedUsers: newList,
    );
  }

  void selectConversationUser(String userId) {
    data = data.copyWith(
      selectedConversationUsers: data.selectedConversationUsers.plus(
        userId,
      ),
    );
  }

  void unselectConversationUser(String userId) {
    final newList = data.selectedConversationUsers.minus(userId);
    data = data.copyWith(
      selectedConversationUsers: newList,
    );
  }

  Future<void> createConversation() async {
    await runCatching(action: () async {
      final membersExceptMe = data.allUsersExceptMembers
          .filter((element) => data.selectedUsers.contains(element.id))
          .toList();

      final currentUserId = _ref.appPreferences.userId;
      final me = FirebaseUserData(
        id: currentUserId,
        email: _ref.appPreferences.email,
      );

      final users = [me, ...membersExceptMe].distinctBy((e) => e.id);

      final members = users
          .map(
            (e) => FirebaseConversationUserData(
              userId: e.id,
              email: AppUtil.randomName(),
              isConversationAdmin: e.id == currentUserId,
            ),
          )
          .toList();

      final conversation = await _ref.firebaseFirestoreService.createConversation(members);
      await _ref.nav.popAndPush(
        ChatRoute(conversation: conversation),
      );
    });
  }

  Future<void> addMembers() async {
    if (_conversation == null) {
      return;
    }

    await runCatching(action: () async {
      final currentId = _ref.appPreferences.userId;
      final currentMembers = data.conversationUsers
          .filter((element) => data.selectedConversationUsers.contains(element.userId))
          .toList();
      final newMembers = data.allUsersExceptMembers
          .filter((element) => data.selectedUsers.contains(element.id))
          .toList();

      final list1 = currentMembers.map((e) => FirebaseConversationUserData(
            userId: e.userId,
            email: e.email,
            isConversationAdmin: e.userId == currentId,
          ));

      final list2 = newMembers.map((e) => FirebaseConversationUserData(
            userId: e.id,
            email: AppUtil.randomName(),
            isConversationAdmin: false,
          ));

      final newList = [...list1, ...list2].distinctBy((e) => e.userId).toList();

      await _ref.firebaseFirestoreService.addMembers(
        conversationId: _conversation.id,
        members: newList,
      );

      await _ref.nav.pop();
    });
  }

  void setKeyWord(String keyword) {
    data = data.copyWith(
      keyword: keyword.trim(),
    );
  }
}
