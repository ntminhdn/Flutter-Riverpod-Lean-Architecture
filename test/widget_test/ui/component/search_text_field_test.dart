import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  group(
    'SearchTextField',
    () {
      void _baseTestGoldens({
        required String description,
        required String filename,
        required Widget widget,
        Future<void> Function(WidgetTester, Key)? onCreate,
      }) {
        testGoldens(description, (tester) async {
          await tester.testWidgetWithDeviceBuilder(
            filename: 'search_text_field/$filename',
            widget: widget,
            onCreate: onCreate,
          );
        });

        testGoldens('$description dark mode', (tester) async {
          await tester.testWidgetWithDeviceBuilder(
            filename: 'search_text_field/dark_mode/$filename',
            widget: widget,
            isDarkMode: true,
            onCreate: onCreate,
          );
        });
      }

      group('test', () {
        _baseTestGoldens(
          description: 'when text is empty',
          filename: 'text_is_empty',
          widget: const SearchTextField(),
        );
      });

      group('test', () {
        _baseTestGoldens(
          description: 'when text is not empty',
          filename: 'text_is_not_empty',
          widget: const SearchTextField(),
          onCreate: (tester, key) async {
            final textFieldFinder = find.byType(TextField).isDescendantOf(find.byKey(key), find);
            expect(textFieldFinder, findsOneWidget);

            await tester.enterText(textFieldFinder, 'ntminh');
          },
        );
      });
    },
  );
}
