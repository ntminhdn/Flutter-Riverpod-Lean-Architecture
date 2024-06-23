import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  group(
    'PrimaryTextField',
    () {
      testGoldens(TestUtil.description('when text is empty'), (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'primary_text_field/${TestUtil.filename('when_text_is_empty')}',
          widget: PrimaryTextField(
            title: 'Email',
            hintText: 'Email',
            controller: TextEditingController(text: ''),
          ),
        );
      });

      testGoldens(TestUtil.description('when text is not empty'), (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'primary_text_field/${TestUtil.filename('when_text_is_not_empty')}',
          widget: PrimaryTextField(
            title: 'Email',
            hintText: 'Email',
            controller: TextEditingController(text: 'ntminh'),
          ),
        );
      });

      testGoldens(TestUtil.description('when it has suffixIcon'), (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'primary_text_field/${TestUtil.filename('when_it_has_suffixIcon')}',
          widget: PrimaryTextField(
            title: 'Password',
            hintText: 'Password',
            controller: TextEditingController(text: ''),
            suffixIcon: CommonImage.svg(
              path: Assets.images.iconClose,
              foregroundColor: Colors.black,
            ),
          ),
        );
      });

      testGoldens(
        TestUtil.description('when keyboardType is TextInputType.visiblePassword'),
        (tester) async {
          await tester.testWidgetWithDeviceBuilder(
            filename:
                'primary_text_field/${TestUtil.filename('when_keyboardType_is_TextInputType.visiblePassword')}',
            widget: PrimaryTextField(
              title: 'Password',
              hintText: 'Password',
              controller: TextEditingController(text: '123456'),
              keyboardType: TextInputType.visiblePassword,
            ),
          );
        },
      );

      testGoldens(
        TestUtil.description('when tapping on the eye icon once'),
        (tester) async {
          await tester.testWidgetWithDeviceBuilder(
            filename:
                'primary_text_field/${TestUtil.filename('when_tapping_on_the_eye_icon_once')}',
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
        },
      );
    },
  );
}
