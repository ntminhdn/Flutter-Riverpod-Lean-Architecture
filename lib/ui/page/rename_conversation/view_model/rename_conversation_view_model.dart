import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final renameConversationViewModelProvider = StateNotifierProvider.autoDispose.family<
    RenameConversationViewModel, CommonState<RenameConversationState>, FirebaseConversationData>(
  (ref, conversation) => RenameConversationViewModel(
    conversation,
    ref,
  ),
);

class RenameConversationViewModel extends BaseViewModel<RenameConversationState> {
  // ignore: prefer_named_parameters
  RenameConversationViewModel(
    this._conversation,
    this._ref,
  ) : super(const CommonState(data: RenameConversationState()));

  final FirebaseConversationData _conversation;
  final Ref _ref;

  FutureOr<void> initState() {
    final currentUserId = _ref.appPreferences.userId;
    data = data.copyWith(
      members: _ref.sharedViewModel.getRenamedMembers(
        members:
            _conversation.members.filter((element) => element.userId != currentUserId).toList(),
        conversationId: _conversation.id,
      ),
    );
  }

  FutureOr<void> renameUser({
    required String memberId,
    required String nickname,
  }) async {
    await _ref.appPreferences.saveUserNickname(
      conversationId: _conversation.id,
      memberId: memberId,
      nickname: nickname,
    );
    final actualMembers = _ref.sharedViewModel.getRenamedMembers(
      members: data.members,
      conversationId: _conversation.id,
    );
    data = data.copyWith(
      members: actualMembers.toList(),
    );
    _ref.update<Map<String, List<FirebaseConversationUserData>>>(
      conversationMembersMapProvider,
      (state) => state.plus(key: _conversation.id, value: actualMembers),
    );
  }
}
