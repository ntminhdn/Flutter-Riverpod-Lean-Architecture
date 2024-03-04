import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  late SettingViewModel settingViewModel;

  setUp(() {
    settingViewModel = SettingViewModel();
  });

  group('initialState', () {
    test('initialState', () async {
      expect(settingViewModel.state, _settingState(const SettingState()));
    });
  });
}

CommonState<SettingState> _settingState(SettingState data) => CommonState(data: data);
