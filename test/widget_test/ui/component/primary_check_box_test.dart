import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  group(
    'PrimaryCheckBox',
    () {
      void _baseTestGoldens({
        required String description,
        required String filename,
        required Widget widget,
      }) {
        testGoldens(description, (tester) async {
          await tester.testWidgetWithDeviceBuilder(
            filename: 'primary_check_box/$filename',
            widget: widget,
          );
        });

        testGoldens('$description dark mode', (tester) async {
          await tester.testWidgetWithDeviceBuilder(
            filename: 'primary_check_box/dark_mode/$filename',
            widget: widget,
            isDarkMode: true,
          );
        });
      }

      group('test', () {
        _baseTestGoldens(
          description: 'when text is null and init value is false and isEnabled is false',
          filename: 'text_is_null_and_init_value_is_false_and_isEnabled_is_false',
          widget: const PrimaryCheckBox(
            text: null,
            initValue: false,
            isEnabled: false,
          ),
        );
      });

      group('test', () {
        _baseTestGoldens(
          description: 'when text is not null and init value is true and isEnabled is true',
          filename: 'text_is_not_null_and_init_value_is_true_and_isEnabled_is_true',
          widget: PrimaryCheckBox(
            text: Text('long long long long text' * 10),
            initValue: true,
            isEnabled: true,
          ),
        );
      });

      group('test', () {
        _baseTestGoldens(
          description: 'when text is not null and init value is true and isEnabled is false',
          filename: 'text_is_not_null_and_init_value_is_true_and_isEnabled_is_false',
          widget: const PrimaryCheckBox(
            text: Text('Minh'),
            initValue: true,
            isEnabled: false,
          ),
        );
      });
    },
  );
}
