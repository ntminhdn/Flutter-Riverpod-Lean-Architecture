import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'main_state.freezed.dart';

@freezed
class MainState extends BaseState with _$MainState {
  const factory MainState() = _MainState;
}
