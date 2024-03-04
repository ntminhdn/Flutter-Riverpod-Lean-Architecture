import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class MockContactListViewModel extends StateNotifier<CommonState<ContactListState>>
    with Mock
    implements ContactListViewModel {
  MockContactListViewModel(super.state);
}

void main() {
  group('ContactListPage', () {
    group('test', () {
      void _baseTestGoldens(bool isDarkMode) {
        testGoldens(
          TestUtil.description('when conversationList is empty', isDarkMode),
          (tester) async {
            await tester.testWidgetWithDeviceBuilder(
              isDarkMode: isDarkMode,
              filename:
                  'contact_list_page/${TestUtil.filename('when_conversationList_is_empty', isDarkMode)}',
              widget: const ContactListPage(),
              overrides: [
                contactListViewModelProvider.overrideWith(
                  (_) => MockContactListViewModel(
                    const CommonState(
                      data: ContactListState(),
                    ),
                  ),
                ),
                currentUserProvider.overrideWith((ref) => const FirebaseUserData(
                      id: '1',
                      email: 'ntminhdn@gmail.com',
                    )),
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
          TestUtil.description('when conversationList is not empty', isDarkMode),
          (tester) async {
            await tester.testWidgetWithDeviceBuilder(
              isDarkMode: isDarkMode,
              filename:
                  'contact_list_page/${TestUtil.filename('when_conversationList_is_not_empty', isDarkMode)}',
              widget: const ContactListPage(),
              onCreate: (tester, key) async {
                final textFieldFinder =
                    find.byType(TextField).isDescendantOf(find.byKey(key), find);
                expect(textFieldFinder, findsOneWidget);

                await tester.enterText(textFieldFinder, 'dog');
              },
              overrides: [
                contactListViewModelProvider.overrideWith(
                  (_) => MockContactListViewModel(
                    const CommonState(
                      data: ContactListState(conversationList: [
                        FirebaseConversationData(id: '1'),
                        FirebaseConversationData(id: '2'),
                      ]),
                    ),
                  ),
                ),
                currentUserProvider.overrideWith((ref) => const FirebaseUserData(
                      id: '1',
                      email: 'duynn@gmail.com',
                    )),
                conversationNameProvider.overrideWith(
                  (ref, conversationId) => conversationId == '1' ? 'Dog, Cat' : 'Fish',
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
          TestUtil.description('when current user is vip member', isDarkMode),
          (tester) async {
            await tester.testWidgetWithDeviceBuilder(
              isDarkMode: isDarkMode,
              filename:
                  'contact_list_page/${TestUtil.filename('when_current_user_is_vip_member', isDarkMode)}',
              widget: const ContactListPage(),
              overrides: [
                contactListViewModelProvider.overrideWith(
                  (_) => MockContactListViewModel(
                    const CommonState(
                      data: ContactListState(),
                    ),
                  ),
                ),
                currentUserProvider.overrideWith((ref) => const FirebaseUserData(
                      id: '1',
                      email: 'ntminhdnlonglonglonglonglong@gmail.com',
                      isVip: true,
                    )),
              ],
            );
          },
        );
      }

      _baseTestGoldens(true);
      _baseTestGoldens(false);
    });
  });
}
