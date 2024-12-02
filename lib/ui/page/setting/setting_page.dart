import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

@RoutePage()
class SettingPage extends BasePage<SettingState,
    AutoDisposeStateNotifierProvider<SettingViewModel, CommonState<SettingState>>> {
  const SettingPage({super.key});

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.setting);

  @override
  AutoDisposeStateNotifierProvider<SettingViewModel, CommonState<SettingState>> get provider =>
      settingViewModelProvider;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return CommonScaffold(
      appBar: CommonAppBar.back(text: l10n.settings),
      body: SafeArea(
        // ignore: missing_expanded_or_flexible
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final isDarkTheme = ref.watch(isDarkModeProvider);

                return SwitchListTile.adaptive(
                  title: CommonText(
                    l10n.darkTheme,
                    style: style(
                      fontSize: 14.rps,
                      color: color.black,
                    ),
                  ),
                  value: isDarkTheme,
                  onChanged: (isDarkTheme) =>
                      ref.update<bool>(isDarkModeProvider, (_) => isDarkTheme),
                );
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final languageCode = ref.watch(languageCodeProvider);

                return SwitchListTile.adaptive(
                  title: CommonText(
                    l10n.japanese,
                    style: style(
                      fontSize: 14.rps,
                      color: color.black,
                    ),
                  ),
                  value: languageCode == LanguageCode.ja,
                  onChanged: (isJa) => ref.update<LanguageCode>(
                    languageCodeProvider,
                    (state) => isJa ? LanguageCode.ja : LanguageCode.en,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
