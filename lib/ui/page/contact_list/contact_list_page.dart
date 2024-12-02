import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

@RoutePage()
class ContactListPage extends BasePage<ContactListState,
    AutoDisposeStateNotifierProvider<ContactListViewModel, CommonState<ContactListState>>> {
  const ContactListPage({super.key});

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.contactList);

  @override
  AutoDisposeStateNotifierProvider<ContactListViewModel, CommonState<ContactListState>>
      get provider => contactListViewModelProvider;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        Future.microtask(() {
          ref.read(provider.notifier).init();
        });

        return () {};
      },
      [],
    );

    final email = ref.watch(currentUserProvider.select((value) => value.email));

    return CommonScaffold(
      hideKeyboardWhenTouchOutside: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 16.rps,
                left: 16.rps,
                right: 16.rps,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final isVipMember =
                            ref.watch(currentUserProvider.select((value) => value.isVip));

                        return Row(
                          children: [
                            AvatarView(text: email),
                            SizedBox(width: 16.rps),
                            Flexible(
                              child: CommonText(
                                email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20.rps,
                                  fontWeight: FontWeight.w500,
                                  color: color.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.rps),
                            Visibility(
                              visible: isVipMember,
                              child: Icon(
                                Icons.local_police,
                                size: 20.rps,
                                color: color.green1,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.rps),
            Padding(
              padding: EdgeInsets.only(
                left: 6.rps,
                right: 6.rps,
                bottom: 6.rps,
              ),
              child: Row(
                children: [
                  SizedBox(width: 12.rps),
                  Expanded(
                    child: CommonText(
                      l10n.conversations,
                      style: TextStyle(
                        fontSize: 20.rps,
                        fontWeight: FontWeight.w500,
                        color: color.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => ref.read(appNavigatorProvider).push(AllUsersRoute(
                          action: AllUsersPageAction.createNewConversation,
                        )),
                    icon: Icon(
                      Icons.add,
                      color: color.black,
                      size: 24.rps,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16.rps,
                right: 16.rps,
                bottom: 6.rps,
              ),
              child: SearchTextField(
                onChanged: (value) => ref.read(provider.notifier).setKeyWord(value),
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final filteredConversations = ref.watch(filteredConversationsProvider);

                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 1.rps, child: CommonDivider(indent: 68.rps)),
                    padding: EdgeInsets.zero,
                    itemCount: filteredConversations.length,
                    itemBuilder: (context, index) {
                      final conversation = filteredConversations[index];
                      final conversationName = ref.watch(conversationNameProvider(conversation.id));

                      return CommonInkWell(
                        onTap: () {
                          ref.read(appNavigatorProvider).push(ChatRoute(
                                conversation: conversation,
                              ));
                        },
                        child: Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            ref.read(provider.notifier).deleteConversation(conversation);
                          },
                          confirmDismiss: (direction) async {
                            return await ref.read(appNavigatorProvider).showDialog(
                                  CommonPopup.confirmDialog(
                                    message: l10n.deleteConversationConfirm,
                                  ),
                                );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 16.rps,
                              right: 16.rps,
                            ),
                            // ignore: missing_expanded_or_flexible
                            child: Column(
                              children: [
                                SizedBox(height: 16.rps),
                                Row(
                                  children: [
                                    AvatarView(
                                      text: conversationName,
                                      width: 36.rps,
                                      height: 36.rps,
                                    ),
                                    SizedBox(width: 20.rps),
                                    Expanded(
                                      // ignore: missing_expanded_or_flexible
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            conversationName,
                                            style: TextStyle(
                                              fontSize: 16.rps,
                                              fontWeight: FontWeight.w500,
                                              color: color.black,
                                            ),
                                          ),
                                          if (conversation.lastMessage.isNotEmpty)
                                            CommonText(
                                              conversation.lastMessage,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13.rps,
                                                color: color.black,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.rps),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
