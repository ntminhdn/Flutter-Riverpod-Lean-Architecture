import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:chatview/chatview.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../index.dart';

@RoutePage()
class ChatPage extends BasePage<ChatState,
    AutoDisposeStateNotifierProvider<ChatViewModel, CommonState<ChatState>>> {
  const ChatPage({
    required this.conversation,
    super.key,
  });

  final FirebaseConversationData conversation;

  @override
  AutoDisposeStateNotifierProvider<ChatViewModel, CommonState<ChatState>> get provider =>
      chatViewModelProvider(conversation);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useEffect(
      () {
        Future.microtask(() {
          ref.read(provider.notifier).init();
        });

        return () {};
      },
      [],
    );

    final chatController = useMemoized(() => ChatController(
          scrollController: scrollController,
          chatUsers: conversation.members.map((e) => e.toChatUser()).toList(),
        )..messageList = ref
            .read(provider.select((value) => value.data.messages))
            .map((e) => e.toMessage())
            .toList());

    final currentUser = ref.watch(currentUserProvider.select((value) {
      return value.toChatUser();
    }));

    ref.listen(conversationMembersProvider(conversation.id), (previous, next) {
      if (!next.isNullOrEmpty) {
        final members = next.map((e) => e.toChatUser()).toList();
        chatController.chatUsers =
            [...members, currentUser].distinctBy((element) => element.id).toList();
      }
    });

    ref.listen(provider.select((value) => value.data.messages), (previous, next) {
      if (previous?.length != next.length) {
        ref.read(provider.notifier).listenToMessagesFromFirestore(next.length);
      }

      chatController.messageList = next.map((e) => e.toMessage()).toList();
    });

    final title = ref.watch(conversationNameProvider(conversation.id));
    final isAdmin = ref.watch(provider.select((value) => value.data.isAdmin));

    return CommonScaffold(
      appBar: _buildAppBar(title: title, isAdmin: isAdmin, ref: ref),
      hideKeyboardWhenTouchOutside: true,
      body: SafeArea(
        child: ChatView(
          currentUser: currentUser,
          chatController: chatController,
          loadingWidget: SizedBox(
            height: 3.rps,
            child: LinearProgressIndicator(
              backgroundColor: cl.white,
              color: cl.black,
            ),
          ),
          loadMoreData: () => ref.read(provider.notifier).onLoadMore(),
          isLastPage: ref.watch(provider.select((value) => value.data.isLastPage)),
          featureActiveConfig: featureActiveConfig(),
          chatViewState: chatViewState,
          chatViewStateConfig: chatViewStateConfig,
          chatBackgroundConfig: chatBackgroundConfig,
          sendMessageConfig: sendMessageConfig,
          chatBubbleConfig: chatBubbleConfig,
          replyPopupConfig: replyPopupConfig,
          repliedMessageConfig: repliedMessageConfig,
          swipeToReplyConfig: swipeToReplyConfig,
          items: [
            MenuItem(
              text: l10n.renameConversationMembers,
              action: () async {
                await _showRenameConversation(ref);
              },
            ),
            MenuItem(
              text: l10n.deleteThisConversation,
              action: () async {
                final isConfirm = await ref.read(appNavigatorProvider).showDialog(
                      CommonPopup.confirmDialog(l10n.doYouWantToDeleteThisConversation),
                    );
                if (isConfirm == true) {
                  unawaited(ref.read(provider.notifier).deleteConversation());
                }
              },
            ),
          ],
          onSendTap: (message, replyMessage, messageType) =>
              ref.read(provider.notifier).sendMessage(
                    message: message,
                    replyMessage: replyMessage.message.isEmpty ? null : replyMessage,
                  ),
          onMoreMenuBuilder: (message, index) => MoreMenuIconButton(
            onCopy: () => Clipboard.setData(ClipboardData(text: message.message)),
            onReply: () => chatController.showReplyView(message),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({
    String? title,
    required bool isAdmin,
    required WidgetRef ref,
  }) {
    return CommonAppBar.back(
      text: title,
      actions: [
        if (isAdmin)
          IconButton(
            onPressed: () {
              ref.read(appNavigatorProvider).push(
                    AllUsersRoute(
                      action: AllUsersPageAction.addMembers,
                      conversation: ref.read(provider.select((value) => value.data.conversation)),
                    ),
                  );
            },
            icon: Icon(
              Icons.group_add,
              color: cl.black,
              size: 24.rps,
            ),
          ),
      ],
    );
  }

  FeatureActiveConfig featureActiveConfig() => const FeatureActiveConfig(
        lastSeenAgoBuilderVisibility: false,
        receiptsBuilderVisibility: true,
        enablePagination: true,
        enableSwipeToSeeTime: false,
        enableDoubleTapToLike: false,
        enableReactionPopup: false,
        enableChatSeparator: false,
        enableOtherUserProfileAvatar: false,
        enableCurrentUserProfileAvatar: false,
        enableReplySnackBar: false,
      );

  ChatViewState get chatViewState => ChatViewState.hasMessages;

  ChatViewStateConfiguration get chatViewStateConfig => ChatViewStateConfiguration(
        loadingWidgetConfig: ChatViewStateWidgetConfiguration(
          loadingIndicatorColor: cl.black,
        ),
      );

  ChatBackgroundConfiguration get chatBackgroundConfig => ChatBackgroundConfiguration(
        listViewPadding: EdgeInsets.only(
          bottom: 16.rps,
          top: 16.rps,
        ),
        backgroundColor: cl.white,
      );

  SendMessageConfiguration get sendMessageConfig => SendMessageConfiguration(
        textFieldBackgroundColor: cl.grey2,
        replyMessageColor: cl.grey1,
        replyDialogColor: cl.black3,
        // ignore: avoid_hard_coded_colors
        replyTitleColor: Colors.white,
        // ignore: avoid_hard_coded_colors
        closeIconColor: Colors.white,
        enableCameraImagePicker: false,
        allowRecordingVoice: false,
        enableGalleryImagePicker: false,
      );

  ChatBubbleConfiguration get chatBubbleConfig => ChatBubbleConfiguration(
        outgoingChatBubbleConfig: ChatBubble(
          linkPreviewConfig: null,
          repliedBackgroundColor: cl.black,
          receiptsWidgetConfig: const ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
          color: cl.black,
          textStyle: ts(color: cl.white, fontSize: 14.rps),
        ),
        inComingChatBubbleConfig: ChatBubble(
          linkPreviewConfig: null,
          repliedBackgroundColor: cl.grey1,
          textStyle: ts(color: cl.black, fontSize: 14.rps),
          senderNameTextStyle: ts(color: cl.black, fontSize: 14.rps),
          color: cl.grey1,
        ),
      );

  ReplyPopupConfiguration get replyPopupConfig => ReplyPopupConfiguration(
        backgroundColor: cl.black3,
        buttonTextStyle: ts(color: cl.white, fontSize: 14.rps),
        topBorderColor: cl.black2,
      );

  RepliedMessageConfiguration get repliedMessageConfig => RepliedMessageConfiguration(
        backgroundColor: cl.black2,
        verticalBarColor: cl.white,
        repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
          enableHighlightRepliedMsg: true,
          highlightColor: cl.red1,
          highlightScale: 1.1,
        ),
        textStyle: ts(
          color: cl.white,
          fontSize: 14.rps,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.25,
        ),
        replyTitleTextStyle: ts(color: cl.white, fontSize: 14.rps),
      );

  SwipeToReplyConfiguration get swipeToReplyConfig => SwipeToReplyConfiguration(
        replyIconColor: cl.white,
      );

  Future<void> _showRenameConversation(WidgetRef ref) async {
    await ref.read(appNavigatorProvider).push(RenameConversationRoute(
          conversation: ref.read(provider.select((value) => value.data.conversation)),
        ));
  }
}
