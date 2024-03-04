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
      void _baseTestGoldens(bool isDarkMode, LanguageCode languageCode) {
        testGoldens(
          TestUtil.description(
              'when theme is ${isDarkMode ? 'dark' : 'light'} and language is $languageCode',
              isDarkMode),
          (tester) async {
            await tester.testWidgetWithDeviceBuilder(
              isDarkMode: isDarkMode,
              filename:
                  'setting/${TestUtil.filename('when_theme_is_${isDarkMode ? 'dark' : 'light'}_and_language_is_$languageCode', isDarkMode)}',
              widget: const SettingPage(),
              overrides: [
                settingViewModelProvider.overrideWith(
                  (_) => MockSettingViewModel(
                    const CommonState(
                      data: SettingState(),
                    ),
                  ),
                ),
                isDarkModeProvider.overrideWith((_) => isDarkMode),
                languageCodeProvider.overrideWith((_) => languageCode),
              ],
            );
          },
        );
      }

      _baseTestGoldens(true, LanguageCode.en);
      _baseTestGoldens(false, LanguageCode.en);
      _baseTestGoldens(true, LanguageCode.ja);
      _baseTestGoldens(false, LanguageCode.ja);
    });
  });
}
