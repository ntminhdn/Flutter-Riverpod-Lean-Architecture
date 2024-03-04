import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState extends BaseState with _$ChatState {
  const factory ChatState({
    required FirebaseConversationData conversation,
    @Default([]) List<LocalMessageData> messages,
    @Default(false) bool isLastPage,
    @Default(false) bool isAdmin,
  }) = _ChatState;
}
