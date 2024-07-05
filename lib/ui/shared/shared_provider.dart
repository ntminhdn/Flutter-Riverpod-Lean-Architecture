import 'package:dartx/dartx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../index.dart';

final backgroundProvider = Provider.autoDispose<AssetGenImage>(
  (ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);

    return isDarkMode ? image.darkBackground : image.background;
  },
);

final languageCodeProvider = StateProvider<LanguageCode>(
  (ref) {
    ref.listenSelf((previous, next) {
      ref.appPreferences.saveLanguageCode(next.value);
    });

    return LanguageCode.fromValue(ref.appPreferences.languageCode);
  },
);

final isDarkModeProvider = StateProvider<bool>(
  (ref) {
    ref.listenSelf((previous, next) {
      ref.appPreferences.saveIsDarkMode(next);
    });

    return ref.appPreferences.isDarkMode;
  },
);

final filteredConversationsProvider = Provider.autoDispose<List<FirebaseConversationData>>(
  (ref) {
    final conversations =
        ref.watch(contactListViewModelProvider.select((value) => value.data.conversationList));
    final keyword = ref.watch(contactListViewModelProvider.select((value) => value.data.keyword));
    final allConversationsMembers = ref.watch(conversationMembersMapProvider);
    final filteredConversationsMembers = allConversationsMembers.filter(
      (element) =>
          element.value.joinToString(transform: (e) => e.email).containsIgnoreCase(keyword.trim()),
    );

    return conversations
        .filter(
          (conversation) {
            // ignore:avoid-collection-methods-with-unrelated-types
            if (allConversationsMembers.containsKey(conversation.id)) {
              // ignore:avoid-collection-methods-with-unrelated-types
              return filteredConversationsMembers.containsKey(conversation.id);
            } else {
              return conversation.members
                  .joinToString(transform: (e) => e.email)
                  .containsIgnoreCase(keyword.trim());
            }
          },
        )
        .map((e) => e.copyWith(
              // ignore:avoid-collection-methods-with-unrelated-types
              members: allConversationsMembers[e.id] ?? e.members,
            ))
        .toList();
  },
);

final conversationNameProvider = Provider.autoDispose.family<String, String>((ref, conversationId) {
  final currentUser = ref.watch(currentUserProvider);
  final members =
      ref.watch(conversationMembersMapProvider.select((value) => value[conversationId]));

  members?.removeWhere((element) => element.userId == currentUser.id);

  return members?.joinToString(transform: (e) => e.email) ?? '';
});

final conversationMembersMapProvider =
    StateProvider<Map<String, List<FirebaseConversationUserData>>>((ref) => {});

final conversationMembersProvider =
    Provider.autoDispose.family<List<FirebaseConversationUserData>, String>((ref, conversationId) {
  return ref
          .watch(conversationMembersMapProvider)[conversationId]
          ?.distinctBy((element) => element.userId)
          .toList() ??
      [];
});

final currentUserProvider = StateProvider<FirebaseUserData>(
  (ref) {
    ref.listenSelf((previous, next) {
      ref.appPreferences.saveUserId(next.id);
      ref.appPreferences.saveEmail(next.email);
    });

    return const FirebaseUserData();
  },
);
