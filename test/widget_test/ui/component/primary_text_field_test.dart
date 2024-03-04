import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  group(
    'PrimaryTextField',
    () {
      void _baseTestGoldens({
        required String description,
        required String filename,
        required Widget widget,
        Future<void> Function(WidgetTester, Key)? onCreate,
      }) {
        testGoldens(description, (tester) async {
          await tester.testWidgetWithDeviceBuilder(
            filename: 'primary_text_field/$filename',
            widget: widget,
            onCreate: onCreate,
          );
        });

        testGoldens('$description dark mode', (tester) async {
          await tester.testWidgetWithDeviceBuilder(
            filename: 'primary_text_field/dark_mode/$filename',
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
          widget: PrimaryTextField(
            title: 'Email',
            hintText: 'Email',
            controller: TextEditingController(text: ''),
          ),
        );
      });

      group('test', () {
        _baseTestGoldens(
          description: 'when text is not empty',
          filename: 'text_is_not_empty',
          widget: PrimaryTextField(
            title: 'Email',
            hintText: 'Email',
            controller: TextEditingController(text: 'ntminh'),
          ),
        );
      });

      group('test', () {
        _baseTestGoldens(
          description: 'when has suffixIcon',
          filename: 'has_suffixIcon',
          widget: PrimaryTextField(
            title: 'Password',
            hintText: 'Password',
            controller: TextEditingController(text: ''),
            suffixIcon: CommonImage.svg(
              svgPath: Assets.images.camera,
              foregroundColor: Colors.black,
            ),
          ),
        );
      });

      group('test', () {
        _baseTestGoldens(
          description: 'when keyboardType is TextInputType.visiblePassword',
          filename: 'keyboardType_is_TextInputType.visiblePassword',
          widget: PrimaryTextField(
            title: 'Password',
            hintText: 'Password',
            controller: TextEditingController(text: '123456'),
            keyboardType: TextInputType.visiblePassword,
          ),
        );
      });

      group('test', () {
        _baseTestGoldens(
          description: 'when tapping on the eye icon once',
          filename: 'when_tapping_on_the_eye_icon_once',
          widget: PrimaryTextField(
            title: 'Password',
            hintText: 'Password',
            controller: TextEditingController(text: '123456'),
            keyboardType: TextInputType.visiblePassword,
          ),
          onCreate: (tester, key) async {
            final eyeIconFinder =
                find.byType(GestureDetector).isDescendantOf(find.byKey(key), find);

            expect(eyeIconFinder, findsOneWidget);

            await tester.tap(eyeIconFinder);
          },
        );
      });
    },
  );
}
