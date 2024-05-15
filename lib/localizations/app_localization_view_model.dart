import 'dart:async';
import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';
import 'app_localization_state.dart';

final appLocalizationViewModelProvider =
    StateNotifierProvider.autoDispose<AppLocalizationViewModel, CommonState<AppLocalizationState>>(
  (ref) => AppLocalizationViewModel(languageCode: ref.watch(languageCodeProvider)),
);

class AppLocalizationViewModel extends BaseViewModel<AppLocalizationState> {
  AppLocalizationViewModel({
    required LanguageCode languageCode,
  })  : _languageCode = languageCode,
        super(const CommonState(data: AppLocalizationState())) {
    final appString = lookupAppString(Locale.fromSubtags(languageCode: _languageCode.localeCode));
    data = data.copyWith(languageCode: _languageCode, localization: appString);
  }

  final LanguageCode _languageCode;
}
