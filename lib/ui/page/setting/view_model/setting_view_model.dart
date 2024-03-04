import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final settingViewModelProvider =
    StateNotifierProvider.autoDispose<SettingViewModel, CommonState<SettingState>>(
  (ref) => SettingViewModel(),
);

class SettingViewModel extends BaseViewModel<SettingState> {
  SettingViewModel() : super(const CommonState(data: SettingState()));
}
