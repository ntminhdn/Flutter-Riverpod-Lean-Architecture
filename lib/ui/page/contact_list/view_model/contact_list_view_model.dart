import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final contactListViewModelProvider =
    StateNotifierProvider.autoDispose<ContactListViewModel, CommonState<ContactListState>>(
  (ref) => ContactListViewModel(ref),
);

class ContactListViewModel extends BaseViewModel<ContactListState> {
  ContactListViewModel(this._ref)
      : super(
          const CommonState(data: ContactListState()),
        );

  final Ref _ref;

  StreamSubscription<List<FirebaseConversationData>>? _conversationsSubscription;

  void init() {
    listenToConversations();
  }

  void listenToConversations() {
    _conversationsSubscription?.cancel();
    final userId = _ref.appPreferences.userId;
    _conversationsSubscription =
        _ref.firebaseFirestoreService.getConversationsStream(userId).listen((event) {
      runCatching(
        action: () async {
          data = data.copyWith(conversationList: event);
          _ref.update<Map<String, List<FirebaseConversationUserData>>>(
            conversationMembersMapProvider,
            (state) => state.plusAll(mapToConversationMembers(event)),
          );
        },
        handleLoading: false,
      );
    });
  }

  @visibleForTesting
  Map<String, List<FirebaseConversationUserData>> mapToConversationMembers(
    List<FirebaseConversationData> conversations,
  ) {
    return conversations.associate((element) => MapEntry(
          element.id,
          _ref.sharedViewModel.getRenamedMembers(
            members: element.members,
            conversationId: element.id,
          ),
        ));
  }

  void setKeyWord(String keyword) {
    data = data.copyWith(keyword: keyword.trim());
  }

  Future<void> deleteConversation(FirebaseConversationData conversation) async {
    data = data.copyWith(
      conversationList: data.conversationList.minus(conversation),
    );
    await runCatching(
      action: () async {
        await _ref.sharedViewModel.deleteConversation(conversation);
      },
      doOnError: (e) async {
        data = data.copyWith(
          conversationList: data.conversationList.plus(conversation),
        );
      },
      handleLoading: false,
    );
  }

  @override
  void dispose() {
    _conversationsSubscription?.cancel();
    _conversationsSubscription = null;
    super.dispose();
  }
}
