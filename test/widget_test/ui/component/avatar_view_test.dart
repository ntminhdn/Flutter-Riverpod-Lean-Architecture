import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  group(
    'AvatarView',
    () {
      void _baseTestGoldens({
        required String description,
        required String filename,
        required Widget widget,
      }) {
        testGoldens(description, (tester) async {
          await tester.testWidgetWithDeviceBuilder(
            filename: 'avatar_view/$filename',
            widget: UnconstrainedBox(child: widget),
            isDarkMode: false,
          );
        });

        testGoldens('$description dark mode', (tester) async {
          await tester.testWidgetWithDeviceBuilder(
            filename: 'avatar_view/dark_mode/$filename',
            widget: UnconstrainedBox(child: widget),
            isDarkMode: true,
          );
        });
      }

      group('test', () {
        _baseTestGoldens(
          description: 'when text is empty',
          filename: 'text_is_empty',
          widget: const AvatarView(text: ''),
        );
      });

      group('test', () {
        _baseTestGoldens(
          description: 'when text is not empty',
          filename: 'text_is_not_empty',
          widget: const AvatarView(text: 'Minh'),
        );
      });

      group('test', () {
        _baseTestGoldens(
          description: 'when isActive is true',
          filename: 'isActive_is_true',
          widget: const AvatarView(text: 'Minh', isActive: true),
        );
      });

      group('test', () {
        _baseTestGoldens(
          description: 'when backgroundColor is red textColor is blue',
          filename: 'backgroundColor_is_red_textColor_is_blue',
          widget: const AvatarView(
            text: 'Minh',
            backgroundColor: Colors.red,
            textStyle: TextStyle(color: Colors.blue, fontSize: 28),
          ),
        );
      });
    },
  );
}
