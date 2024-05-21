import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

enum AllUsersPageAction {
  createNewConversation,
  addMembers;

  String get title {
    switch (this) {
      case AllUsersPageAction.createNewConversation:
        return l10n.createANewConversation;
      case AllUsersPageAction.addMembers:
        return l10n.addNewMembers;
    }
  }
}

@RoutePage()
class AllUsersPage extends BasePage<AllUsersState,
    AutoDisposeStateNotifierProvider<AllUsersViewModel, CommonState<AllUsersState>>> {
  const AllUsersPage({required this.action, this.conversation, super.key});

  @override
  AutoDisposeStateNotifierProvider<AllUsersViewModel, CommonState<AllUsersState>> get provider =>
      allUsersViewModelProvider(conversation);

  final FirebaseConversationData? conversation;
  final AllUsersPageAction action;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        Future.microtask(() {
          ref.read(provider.notifier).initState();
        });

        return () {};
      },
      [],
    );

    return CommonScaffold(
      hideKeyboardWhenTouchOutside: true,
      appBar: CommonAppBar.back(text: action.title),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 12.rps,
                left: 16.rps,
                right: 16.rps,
                bottom: 6.rps,
              ),
              child: SearchTextField(
                onChanged: (value) => ref.read(provider.notifier).setKeyWord(value),
              ),
            ),
            Expanded(
              child: Consumer(builder: (context, ref, child) {
                final users = ref.watch(provider.select(
                  (value) => value.data.filteredUsers,
                ));

                final members = ref.watch(
                  provider.select((value) => value.data.conversationUsers),
                );

                return ListView.separated(
                  separatorBuilder: (context, index) {
                    final hasMembersList = members.isNotEmpty;
                    final isNotShowDivider = hasMembersList
                        ? () {
                            const membersTitleIndex = 0;
                            final usersTitleIndex = members.length + 1;

                            return index == membersTitleIndex ||
                                index == usersTitleIndex ||
                                index == members.length;
                          }()
                        : index == 0;

                    return isNotShowDivider
                        ? const SizedBox()
                        : SizedBox(
                            height: 1,
                            child: CommonDivider(indent: 60.rps),
                          );
                  },
                  padding: EdgeInsets.zero,
                  itemCount: () {
                    final hasMembersTitle = members.isNotEmpty;
                    final hasUsersTitle = users.isNotEmpty;

                    return members.length +
                        users.length +
                        (hasMembersTitle ? 1 : 0) +
                        (hasUsersTitle ? 1 : 0);
                  }(),
                  itemBuilder: (context, index) {
                    if (members.isNotEmpty && index == 0) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 16.rps,
                          left: 16.rps,
                        ),
                        child: CommonText(
                          l10n.members,
                          style: ts(
                            fontSize: 16.rps,
                            fontWeight: FontWeight.bold,
                            color: cl.black,
                          ),
                        ),
                      );
                    }

                    if (users.isNotEmpty && index == (members.isEmpty ? 0 : members.length + 1)) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 16.rps,
                          left: 16.rps,
                        ),
                        child: CommonText(
                          l10n.allUsers,
                          style: ts(
                            fontSize: 16.rps,
                            fontWeight: FontWeight.bold,
                            color: cl.black,
                          ),
                        ),
                      );
                    }

                    if (members.isNotEmpty && index < members.length + 1) {
                      return _buildMemberItem(
                        ref: ref,
                        index: index - 1,
                        users: members,
                      );
                    }

                    return _buildUserItem(
                      ref: ref,
                      index: () {
                        final membersItemCount = members.length;
                        final membersTitleItemCount = members.isNotEmpty ? 1 : 0;
                        final usersTitleItemCount = users.isNotEmpty ? 1 : 0;

                        return index -
                            membersItemCount -
                            membersTitleItemCount -
                            usersTitleItemCount;
                      }(),
                      users: users,
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16.rps,
                right: 16.rps,
                bottom: 40.rps,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Consumer(builder: (context, ref, child) {
                  final isAddButtonEnabled = ref.watch(provider.select(
                    (value) => value.data.isAddButtonEnabled,
                  ));

                  return ElevatedButton(
                    onPressed: isAddButtonEnabled
                        ? () => action == AllUsersPageAction.createNewConversation
                            ? ref.read(provider.notifier).createConversation()
                            : ref.read(provider.notifier).addMembers()
                        : null,
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        Size(double.infinity, 48.rps),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        cl.black.withOpacity(
                          isAddButtonEnabled ? 1 : 0.5,
                        ),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    child: CommonText(
                      l10n.add,
                      style: ts(
                        fontSize: 18.rps,
                        fontWeight: FontWeight.bold,
                        color: cl.white,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberItem({
    required WidgetRef ref,
    required int index,
    required List<FirebaseConversationUserData> users,
  }) {
    final user = users[index];
    final userId = user.userId;
    final email = user.email;
    final isMe = userId == ref.watch(currentUserProvider.select((value) => value.id));

    return CommonInkWell(
      onTap: isMe
          ? null
          : () {
              ref.read(provider.notifier).isConversationUserChecked(userId)
                  ? ref.read(provider.notifier).unselectConversationUser(userId)
                  : ref.read(provider.notifier).selectConversationUser(userId);
            },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.rps,
          right: 16.rps,
        ),
        child: Column(
          children: [
            SizedBox(height: 16.rps),
            Row(
              children: [
                PrimaryCheckBox(
                  initValue: ref.watch(provider.notifier).isConversationUserChecked(userId),
                  isEnabled: !isMe,
                  onChanged: (value) async => {
                    value
                        ? ref.read(provider.notifier).selectConversationUser(userId)
                        : ref.read(provider.notifier).unselectConversationUser(userId),
                  },
                ),
                SizedBox(width: 8.rps),
                AvatarView(
                  text: email,
                  width: 36.rps,
                  height: 36.rps,
                ),
                SizedBox(width: 16.rps),
                Expanded(
                  child: CommonText(
                    email + (isMe ? l10n.you : ''),
                    style: ts(
                      fontSize: 16.rps,
                      fontWeight: FontWeight.w700,
                      color: cl.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.rps),
          ],
        ),
      ),
    );
  }

  Widget _buildUserItem({
    required WidgetRef ref,
    required int index,
    required List<FirebaseUserData> users,
  }) {
    final userId = users[index].id;

    return CommonInkWell(
      onTap: () {
        ref.read(provider.notifier).isUserChecked(userId)
            ? ref.read(provider.notifier).unselectUser(userId)
            : ref.read(provider.notifier).selectUser(userId);
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.rps,
          right: 16.rps,
        ),
        child: Column(
          children: [
            SizedBox(height: 16.rps),
            Row(
              children: [
                PrimaryCheckBox(
                  initValue: ref.watch(provider.notifier).isUserChecked(userId),
                  onChanged: (value) async => {
                    value
                        ? ref.read(provider.notifier).selectUser(userId)
                        : ref.read(provider.notifier).unselectUser(userId),
                  },
                ),
                SizedBox(width: 8.rps),
                AvatarView(
                  text: users[index].email,
                  width: 36.rps,
                  height: 36.rps,
                ),
                SizedBox(width: 16.rps),
                Expanded(
                  child: CommonText(
                    users[index].email,
                    style: ts(
                      fontSize: 16.rps,
                      fontWeight: FontWeight.w700,
                      color: cl.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.rps),
          ],
        ),
      ),
    );
  }
}
