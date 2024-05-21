import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  group(
    'AvatarView',
    () {
      testGoldens(TestUtil.description('when text is empty'), (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'avatar_view/${TestUtil.filename('when_text_is_empty')}',
          widget: const UnconstrainedBox(child: AvatarView(text: '')),
        );
      });

      testGoldens(TestUtil.description('when text is not empty'), (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'avatar_view/${TestUtil.filename('when_text_is_not_empty')}',
          widget: const UnconstrainedBox(child: AvatarView(text: 'Minh')),
        );
      });

      testGoldens(TestUtil.description('when isActive is true'), (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'avatar_view/${TestUtil.filename('when_isActive_is_true')}',
          widget: const UnconstrainedBox(child: AvatarView(text: 'Minh', isActive: true)),
        );
      });

      testGoldens(
        TestUtil.description('when backgroundColor is red textColor is blue'),
        (tester) async {
          await tester.testWidgetWithDeviceBuilder(
            filename:
                'avatar_view/${TestUtil.filename('when_backgroundColor_is_red_textColor_is_blue')}',
            widget: const UnconstrainedBox(
              child: AvatarView(
                text: 'Minh',
                backgroundColor: Colors.red,
                textStyle: TextStyle(color: Colors.blue, fontSize: 28),
              ),
            ),
          );
        },
      );
    },
  );
}
