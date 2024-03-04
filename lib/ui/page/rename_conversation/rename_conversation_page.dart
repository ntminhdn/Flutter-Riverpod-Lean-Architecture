import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

@RoutePage()
class RenameConversationPage extends BasePage<
    RenameConversationState,
    AutoDisposeStateNotifierProvider<RenameConversationViewModel,
        CommonState<RenameConversationState>>> {
  const RenameConversationPage({required this.conversation, super.key});

  @override
  AutoDisposeStateNotifierProvider<RenameConversationViewModel,
          CommonState<RenameConversationState>>
      get provider => renameConversationViewModelProvider(conversation);

  final FirebaseConversationData conversation;

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
      appBar: CommonAppBar.back(text: l10n.members),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer(builder: (context, ref, child) {
                final members = ref.watch(provider.select((value) => value.data.members)).toList();

                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 1, child: Divider(indent: 68.rps)),
                  padding: EdgeInsets.zero,
                  itemCount: members.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {},
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
                              AvatarView(
                                text: members[index].email,
                                width: 36.rps,
                                height: 36.rps,
                              ),
                              SizedBox(width: 16.rps),
                              Expanded(
                                child: CommonText(
                                  members[index].email,
                                  style: ts(
                                    color: cl.black,
                                    fontSize: 16.rps,
                                  ),
                                ),
                              ),
                              InkWell(
                                child: Icon(
                                  Icons.edit,
                                  size: 20.rps,
                                  color: cl.black,
                                ),
                                onTap: () async {
                                  await ref.read(appNavigatorProvider).showDialog(
                                        CommonPopup.renameConversationDialog(
                                          email: members[index].email,
                                          onSubmit: (nickname) async {
                                            ref.read(provider.notifier).renameUser(
                                                  memberId: members[index].userId,
                                                  nickname: nickname,
                                                );
                                          },
                                        ),
                                      );
                                },
                              ),
                              SizedBox(width: 14.rps),
                            ],
                          ),
                          SizedBox(height: 16.rps),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
