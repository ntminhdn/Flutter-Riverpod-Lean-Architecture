import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  group(
    'MoreMenuIconButton',
    () {
      testGoldens(TestUtil.description('when it is normal state'), (tester) async {
        await tester.testWidgetWithWidgetBuilder(
          filename: 'more_menu_icon_button/${TestUtil.filename('when_it_is_normal_state')}',
          widget: MoreMenuIconButton(onCopy: () {}, onReply: () {}),
          mergeIntoSingleImage: false,
        );
      });
    },
  );
}
