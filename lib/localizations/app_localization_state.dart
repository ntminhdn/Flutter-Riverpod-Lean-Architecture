import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'app_localization_state.freezed.dart';

@freezed
class AppLocalizationState extends BaseState with _$AppLocalizationState {
  const AppLocalizationState._();

  const factory AppLocalizationState({
    @Default(LanguageCode.ja) LanguageCode languageCode,
    AppString? localization,
  }) = _AppLocalizationState;
}
