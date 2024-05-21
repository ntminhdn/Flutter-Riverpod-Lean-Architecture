import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class MockSettingViewModel extends StateNotifier<CommonState<SettingState>>
    with Mock
    implements SettingViewModel {
  MockSettingViewModel(super.state);
}

void main() {
  group('SettingPage', () {
    group('test', () {
      void _baseTestGoldens(LanguageCode languageCode) {
        testGoldens(
          TestUtil.description(
              'when theme is ${TestConfig.isDarkMode ? 'dark' : 'light'} and language is $languageCode'),
          (tester) async {
            await tester.testWidgetWithDeviceBuilder(
              filename:
                  'setting/${TestUtil.filename('when_theme_is_${TestConfig.isDarkMode ? 'dark' : 'light'}_and_language_is_$languageCode')}',
              widget: const SettingPage(),
              overrides: [
                settingViewModelProvider.overrideWith(
                  (_) => MockSettingViewModel(
                    const CommonState(
                      data: SettingState(),
                    ),
                  ),
                ),
                isDarkModeProvider.overrideWith((_) => TestConfig.isDarkMode),
                languageCodeProvider.overrideWith((_) => languageCode),
              ],
            );
          },
        );
      }

      _baseTestGoldens(LanguageCode.en);
      _baseTestGoldens(LanguageCode.ja);
    });
  });
}
