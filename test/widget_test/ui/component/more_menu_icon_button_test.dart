import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  group(
    'MoreMenuIconButton',
    () {
      void _baseTestGoldens({
        required String description,
        required String filename,
        required Widget widget,
      }) {
        testGoldens(description, (tester) async {
          await tester.testWidgetWithWidgetBuilder(
            filename: 'more_menu_icon_button/$filename',
            widget: widget,
            mergeIntoSingleImage: false,
          );
        });

        testGoldens('$description dark mode', (tester) async {
          await tester.testWidgetWithWidgetBuilder(
            filename: 'more_menu_icon_button/dark_mode/$filename',
            widget: widget,
            isDarkMode: true,
            mergeIntoSingleImage: false,
          );
        });
      }

      group('test', () {
        _baseTestGoldens(
          description: 'when it is normal state',
          filename: 'when_it_is_normal_state',
          widget: MoreMenuIconButton(onCopy: () {}, onReply: () {}),
        );
      });
    },
  );
}
