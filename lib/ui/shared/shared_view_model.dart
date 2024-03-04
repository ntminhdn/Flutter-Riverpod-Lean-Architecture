import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../index.dart';

final sharedViewModelProvider = Provider((_ref) => SharedViewModel(_ref));

class SharedViewModel {
  SharedViewModel(this._ref);

  final Ref _ref;

  Future<String> get deviceToken async {
    final deviceToken = await _ref.firebaseMessagingService.deviceToken;
    if (deviceToken != null) {
      await _ref.appPreferences.saveDeviceToken(deviceToken);
    }

    return deviceToken ?? '';
  }

  Future<void> logout() async {
    try {
      final deviceToken = await this.deviceToken;
      final userId = _ref.appPreferences.userId;
      await _ref.firebaseFirestoreService.updateCurrentUser(userId: userId, data: {
        FirebaseUserData.keyDeviceIds: [],
        FirebaseUserData.keyDeviceTokens: FieldValue.arrayRemove([deviceToken]),
      });
      await _ref.appPreferences.clearCurrentUserData();
      await _ref.firebaseAuthService.signOut();
      _ref.update<FirebaseUserData>(currentUserProvider, (state) => const FirebaseUserData());
      await _ref.nav.replaceAll([const LoginRoute()]);
    } catch (e) {
      await _ref.nav.replaceAll([const LoginRoute()]);
    }
  }

  List<FirebaseConversationUserData> getRenamedMembers({
    required List<FirebaseConversationUserData> members,
    required String conversationId,
  }) {
    return members
        .map((e) => e.copyWith(
              email: _ref.appPreferences.getUserNickname(
                    conversationId: conversationId,
                    memberId: e.userId,
                  ) ??
                  e.email,
            ))
        .toList();
  }

  Future<void> deleteConversation(FirebaseConversationData conversation) async {
    await _ref.firebaseFirestoreService.deleteConversation(conversation.id);
    await _ref.appDatabase.removeMessagesByConversationId(conversation.id);
  }
}
