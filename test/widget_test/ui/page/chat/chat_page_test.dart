import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class MockChatViewModel extends StateNotifier<CommonState<ChatState>>
    with Mock
    implements ChatViewModel {
  MockChatViewModel(super.state);
}

void main() {
  group('ChatPage', () {
    group('test', () {
      void _baseTestGoldens(bool isDarkMode) {
        testGoldens(
          TestUtil.description('when `messages` is empty', isDarkMode),
          (tester) async {
            const currentUserId = '1';
            const members = [
              FirebaseConversationUserData(
                userId: currentUserId,
                isConversationAdmin: true,
                email: 'Dog',
              ),
              FirebaseConversationUserData(userId: '2', isConversationAdmin: false, email: 'Cat'),
            ];
            const conversation = FirebaseConversationData(
              id: '1',
              members: members,
            );
            const me = FirebaseUserData(
              id: currentUserId,
              email: 'ntminhdn@gmail.com',
            );

            await tester.testWidgetWithDeviceBuilder(
              isDarkMode: isDarkMode,
              filename: 'chat_page/${TestUtil.filename('when_messages_is_empty', isDarkMode)}',
              widget: const ChatPage(conversation: conversation),
              overrides: [
                chatViewModelProvider.overrideWith(
                  (_, conversation) => MockChatViewModel(
                    CommonState(
                      data: ChatState(
                        conversation: conversation,
                        messages: [],
                      ),
                    ),
                  ),
                ),
                currentUserProvider.overrideWith((ref) => me),
                conversationMembersMapProvider.overrideWith(
                  (_) => {conversation.id: members},
                ),
                conversationNameProvider.overrideWith(
                  (_, __) => 'Dog, Cat',
                ),
              ],
            );
          },
        );
      }

      _baseTestGoldens(true);
      _baseTestGoldens(false);
    });

    group('test', () {
      void _baseTestGoldens(bool isDarkMode) {
        testGoldens(
          TestUtil.description('when `messages` is not empty', isDarkMode),
          (tester) async {
            const currentUserId = '1';
            const thinhId = '2';
            const duyId = '3';
            const members = [
              FirebaseConversationUserData(
                userId: currentUserId,
                isConversationAdmin: true,
                email: 'Dog',
              ),
              FirebaseConversationUserData(
                  userId: thinhId, isConversationAdmin: false, email: 'Cat'),
              FirebaseConversationUserData(
                  userId: duyId, isConversationAdmin: false, email: 'duynn'),
            ];
            const renamedMembers = [
              FirebaseConversationUserData(
                userId: currentUserId,
                isConversationAdmin: true,
                email: 'Dog',
              ),
              FirebaseConversationUserData(
                  userId: thinhId, isConversationAdmin: false, email: 'Cat'),
              FirebaseConversationUserData(userId: duyId, isConversationAdmin: false, email: 'Pig'),
            ];
            const conversationId = '99';
            const conversation = FirebaseConversationData(
              id: conversationId,
              members: members,
            );
            const me = FirebaseUserData(
              id: currentUserId,
              email: 'ntminhdn@gmail.com',
            );

            await tester.testWidgetWithDeviceBuilder(
              filename: 'chat_page/${TestUtil.filename('when_messages_is_not_empty', isDarkMode)}',
              widget: const ChatPage(conversation: conversation),
              overrides: [
                chatViewModelProvider.overrideWith(
                  (_, conversation) => MockChatViewModel(
                    CommonState(
                      data: ChatState(
                        conversation: conversation,
                        messages: [
                          LocalMessageData(
                            uniqueID: '8',
                            conversationId: conversationId,
                            senderId: currentUserId,
                            message: '?????',
                            createdAt: 1,
                            status: MessageStatus.sent,
                          ),
                          LocalMessageData(
                            uniqueID: '6',
                            conversationId: conversationId,
                            senderId: thinhId,
                            replyMessage: LocalReplyMessageData(
                              repplyToMessage: 'I\'m fine. Thank you. And you you you you?',
                              replyByUserId: thinhId,
                              replyToUserId: duyId,
                              conversationId: conversationId,
                              repplyToMessageId: '5',
                            ),
                            message:
                                'Very long long long long long long long long long long long long long long long long long long long long long long long long long long text',
                            createdAt: 1,
                            status: MessageStatus.sent,
                          ),
                          LocalMessageData(
                            uniqueID: '7',
                            conversationId: conversationId,
                            senderId: currentUserId,
                            message: 'Dmm. Lost the connection',
                            createdAt: 1,
                            status: MessageStatus.sending,
                          ),
                          LocalMessageData(
                            uniqueID: '7',
                            conversationId: conversationId,
                            senderId: currentUserId,
                            message: 'Ahhhhhhhhhhhh',
                            createdAt: 1,
                            status: MessageStatus.failed,
                          ),
                          LocalMessageData(
                            uniqueID: '5',
                            conversationId: conversationId,
                            senderId: duyId,
                            replyMessage: LocalReplyMessageData(
                              repplyToMessage: 'How are you?',
                              replyByUserId: duyId,
                              replyToUserId: currentUserId,
                              conversationId: conversationId,
                              repplyToMessageId: '4',
                            ),
                            message: 'I\'m fine. Thank you. And you you you you?',
                            createdAt: 1,
                            status: MessageStatus.sent,
                          ),
                          LocalMessageData(
                            uniqueID: '4',
                            conversationId: conversationId,
                            senderId: currentUserId,
                            replyMessage: LocalReplyMessageData(
                              repplyToMessage: 'Hello',
                              replyByUserId: currentUserId,
                              replyToUserId: currentUserId,
                              conversationId: conversationId,
                              repplyToMessageId: '1',
                            ),
                            message: 'How are you?',
                            createdAt: 1,
                            status: MessageStatus.sent,
                          ),
                          LocalMessageData(
                            uniqueID: '3',
                            conversationId: conversationId,
                            senderId: thinhId,
                            message: 'Hola',
                            createdAt: 1,
                            status: MessageStatus.sent,
                          ),
                          LocalMessageData(
                            uniqueID: '2',
                            conversationId: conversationId,
                            senderId: duyId,
                            message: 'Hi',
                            createdAt: 1,
                            status: MessageStatus.sent,
                          ),
                          LocalMessageData(
                            uniqueID: '1',
                            conversationId: conversationId,
                            senderId: currentUserId,
                            message: 'Hello',
                            createdAt: 1,
                            status: MessageStatus.sent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                currentUserProvider.overrideWith((ref) => me),
                conversationMembersMapProvider.overrideWith(
                  (_) => {conversation.id: renamedMembers},
                ),
                conversationNameProvider.overrideWith(
                  (_, __) => 'Dog, Cat, duynn',
                ),
              ],
              isDarkMode: isDarkMode,
            );
          },
        );
      }

      _baseTestGoldens(true);
      _baseTestGoldens(false);
    });

    group('test', () {
      void _baseTestGoldens(bool isDarkMode) {
        testGoldens(
          TestUtil.description('when user is typing', isDarkMode),
          (tester) async {
            const currentUserId = '1';
            const members = [
              FirebaseConversationUserData(
                userId: currentUserId,
                isConversationAdmin: true,
                email: 'Dog',
              ),
              FirebaseConversationUserData(userId: '2', isConversationAdmin: false, email: 'Cat'),
            ];
            const conversation = FirebaseConversationData(
              id: '1',
              members: members,
            );
            const me = FirebaseUserData(
              id: currentUserId,
              email: 'ntminhdn@gmail.com',
            );

            await tester.testWidgetWithDeviceBuilder(
              filename: 'chat_page/${TestUtil.filename('when_user_is_typing', isDarkMode)}',
              widget: const ChatPage(conversation: conversation),
              onCreate: (tester, key) async {
                final textFieldFinder =
                    find.byType(TextField).isDescendantOf(find.byKey(key), find);
                expect(textFieldFinder, findsOneWidget);

                await tester.enterText(textFieldFinder, 'dog and cat');
              },
              overrides: [
                chatViewModelProvider.overrideWith(
                  (_, conversation) => MockChatViewModel(
                    CommonState(
                      data: ChatState(
                        conversation: conversation,
                        messages: [],
                      ),
                    ),
                  ),
                ),
                currentUserProvider.overrideWith((ref) => me),
                conversationMembersMapProvider.overrideWith(
                  (_) => {conversation.id: members},
                ),
                conversationNameProvider.overrideWith(
                  (_, __) => 'Dog, Cat',
                ),
              ],
              isDarkMode: isDarkMode,
            );
          },
        );
      }

      _baseTestGoldens(true);
      _baseTestGoldens(false);
    });

    group('test', () {
      void _baseTestGoldens(bool isDarkMode) {
        testGoldens(
          TestUtil.description('when users are replying themselves', isDarkMode),
          (tester) async {
            const currentUserId = '1';
            const members = [
              FirebaseConversationUserData(
                userId: currentUserId,
                isConversationAdmin: true,
                email: 'Dog',
              ),
              FirebaseConversationUserData(userId: '2', isConversationAdmin: false, email: 'Cat'),
            ];
            const conversation = FirebaseConversationData(
              id: '1',
              members: members,
            );
            const me = FirebaseUserData(
              id: currentUserId,
              email: 'duynn@gmail.com',
            );

            await tester.testWidgetWithDeviceBuilder(
              filename:
                  'chat_page/${TestUtil.filename('when_users_are_replying_themselves', isDarkMode)}',
              widget: const ChatPage(conversation: conversation),
              onCreate: (tester, key) async {
                await tester.pump(5.seconds);
                final moreMenuIconFinder =
                    find.byType(MoreMenuIconButton).isDescendantOf(find.byKey(key), find);
                expect(moreMenuIconFinder, findsOneWidget);
                await tester.tap(moreMenuIconFinder);
                await tester.pump();
                final replyFinder = find.text(l10n.reply);
                await tester.tap(replyFinder);
              },
              overrides: [
                chatViewModelProvider.overrideWith(
                  (_, conversation) => MockChatViewModel(
                    CommonState(
                      data: ChatState(
                        conversation: conversation,
                        messages: [
                          LocalMessageData(
                            uniqueID: '1',
                            conversationId: conversation.id,
                            senderId: currentUserId,
                            message: 'Hello',
                            createdAt: 1,
                            status: MessageStatus.sent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                currentUserProvider.overrideWith((ref) => me),
                conversationMembersMapProvider.overrideWith(
                  (_) => {conversation.id: members},
                ),
                conversationNameProvider.overrideWith(
                  (_, __) => 'Dog, Cat',
                ),
              ],
              isDarkMode: isDarkMode,
            );
          },
        );
      }

      _baseTestGoldens(true);
      _baseTestGoldens(false);
    });

    group('test', () {
      void _baseTestGoldens(bool isDarkMode) {
        testGoldens(
          TestUtil.description('when users are replying to other users', isDarkMode),
          (tester) async {
            const currentUserId = '1';
            const otherUserId = '2';
            const members = [
              FirebaseConversationUserData(
                userId: currentUserId,
                isConversationAdmin: true,
                email: 'Dog',
              ),
              FirebaseConversationUserData(
                userId: otherUserId,
                isConversationAdmin: false,
                email: 'Cat',
              ),
            ];
            const conversation = FirebaseConversationData(
              id: '1',
              members: members,
            );
            const me = FirebaseUserData(
              id: currentUserId,
              email: 'duynn@gmail.com',
            );

            await tester.testWidgetWithDeviceBuilder(
              filename:
                  'chat_page/${TestUtil.filename('when_users_are_replying_to_other_users', isDarkMode)}',
              widget: const ChatPage(conversation: conversation),
              onCreate: (tester, key) async {
                await tester.pump(5.seconds);
                final moreMenuIconFinder =
                    find.byType(MoreMenuIconButton).isDescendantOf(find.byKey(key), find);
                expect(moreMenuIconFinder, findsOneWidget);
                await tester.tap(moreMenuIconFinder);
                await tester.pump();
                final replyFinder = find.text(l10n.reply);
                await tester.tap(replyFinder);
              },
              overrides: [
                chatViewModelProvider.overrideWith(
                  (_, conversation) => MockChatViewModel(
                    CommonState(
                      data: ChatState(
                        conversation: conversation,
                        messages: [
                          LocalMessageData(
                            uniqueID: '1',
                            conversationId: conversation.id,
                            senderId: otherUserId,
                            message: 'Hello',
                            createdAt: 1,
                            status: MessageStatus.sent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                currentUserProvider.overrideWith((ref) => me),
                conversationMembersMapProvider.overrideWith(
                  (_) => {conversation.id: members},
                ),
                conversationNameProvider.overrideWith(
                  (_, __) => 'Dog, Cat',
                ),
              ],
              isDarkMode: isDarkMode,
            );
          },
        );
      }

      _baseTestGoldens(true);
      _baseTestGoldens(false);
    });

    group('test', () {
      void _baseTestGoldens(bool isDarkMode) {
        testGoldens(TestUtil.description('when displaying the menu', isDarkMode), (tester) async {
          const currentUserId = '1';
          const members = [
            FirebaseConversationUserData(
              userId: currentUserId,
              isConversationAdmin: true,
              email: 'Dog',
            ),
            FirebaseConversationUserData(userId: '2', isConversationAdmin: false, email: 'Cat'),
          ];
          const conversation = FirebaseConversationData(
            id: '1',
            members: members,
          );
          const me = FirebaseUserData(
            id: currentUserId,
            email: 'ntminh@gmail.com',
          );
          const message = 'Hello';

          await tester.testWidgetWithDeviceBuilder(
            isDarkMode: isDarkMode,
            filename: 'chat_page/${TestUtil.filename('when_displaying_the_menu', isDarkMode)}',
            widget: const ChatPage(conversation: conversation),
            onCreate: (tester, key) async {
              await tester.pump(5.seconds);
              final menuFinder = find
                  .byType(IconButton)
                  .isAncestorOf(find.byType(AnimatedIcon), find)
                  .isDescendantOf(find.byKey(key), find);
              await tester.tap(menuFinder);
              await tester.pumpAndSettle();
            },
            overrides: [
              chatViewModelProvider.overrideWith(
                (_, conversation) => MockChatViewModel(
                  CommonState(
                    data: ChatState(
                      conversation: conversation,
                      messages: [
                        LocalMessageData(
                          uniqueID: '1',
                          conversationId: conversation.id,
                          senderId: currentUserId,
                          message: message,
                          createdAt: 1,
                          status: MessageStatus.sent,
                        ),
                        LocalMessageData(
                          uniqueID: '1',
                          conversationId: conversation.id,
                          senderId: currentUserId,
                          message: message,
                          createdAt: 1,
                          status: MessageStatus.sent,
                        ),
                        LocalMessageData(
                          uniqueID: '1',
                          conversationId: conversation.id,
                          senderId: currentUserId,
                          message: message,
                          createdAt: 1,
                          status: MessageStatus.sent,
                        ),
                        LocalMessageData(
                          uniqueID: '1',
                          conversationId: conversation.id,
                          senderId: currentUserId,
                          message: message,
                          createdAt: 1,
                          status: MessageStatus.sent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              currentUserProvider.overrideWith((ref) => me),
              conversationMembersMapProvider.overrideWith(
                (_) => {conversation.id: members},
              ),
              conversationNameProvider.overrideWith(
                (_, __) => 'Dog, Cat',
              ),
            ],
          );
        });
      }

      _baseTestGoldens(true);
      _baseTestGoldens(false);
    });
  });
}
