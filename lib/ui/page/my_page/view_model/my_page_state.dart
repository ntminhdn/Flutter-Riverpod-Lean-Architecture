// ignore_for_file: incorrect_parent_class
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'my_page_state.freezed.dart';

@freezed
class MyPageState extends BaseState with _$MyPageState {
  const MyPageState._();

  const factory MyPageState() = _MyPageState;
}
