import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class MockRenameConversationViewModel extends StateNotifier<CommonState<RenameConversationState>>
    with Mock
    implements RenameConversationViewModel {
  MockRenameConversationViewModel(super.state);
}

void main() {
  group('RenameConversationPage', () {
    const conversation = FirebaseConversationData(id: '1');

    testGoldens(
      TestUtil.description('when members is empty'),
      (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'rename_conversation_page/${TestUtil.filename('when_members_is_empty')}',
          widget: const RenameConversationPage(conversation: conversation),
          overrides: [
            renameConversationViewModelProvider.overrideWith(
              (_, __) => MockRenameConversationViewModel(
                const CommonState(
                  data: RenameConversationState(),
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
    testGoldens(
      TestUtil.description('when members is not empty'),
      (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'rename_conversation_page/${TestUtil.filename('when_members_is_not_empty')}',
          widget: const RenameConversationPage(conversation: conversation),
          overrides: [
            renameConversationViewModelProvider.overrideWith(
              (_, __) => MockRenameConversationViewModel(
                const CommonState(
                  data: RenameConversationState(members: [
                    FirebaseConversationUserData(userId: '1', email: 'Dog'),
                    FirebaseConversationUserData(userId: '2', email: 'Cat'),
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
  });
}
