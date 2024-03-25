import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  group(
    'SearchTextField',
    () {
      testGoldens(TestUtil.description('when text is empty'), (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'search_text_field/${TestUtil.filename('when_text_is_empty')}',
          widget: const SearchTextField(),
        );
      });

      testGoldens(TestUtil.description('when text is not empty'), (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'search_text_field/${TestUtil.filename('when_text_is_not_empty')}',
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
