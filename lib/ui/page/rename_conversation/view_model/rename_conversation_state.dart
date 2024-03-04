import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'rename_conversation_state.freezed.dart';

@freezed
class RenameConversationState extends BaseState with _$RenameConversationState {
  const RenameConversationState._();

  const factory RenameConversationState({
    @Default(<FirebaseConversationUserData>[]) List<FirebaseConversationUserData> members,
  }) = _RenameConversationState;
}
