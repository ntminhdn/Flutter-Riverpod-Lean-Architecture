import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'contact_list_state.freezed.dart';

@freezed
class ContactListState extends BaseState with _$ContactListState {
  const ContactListState._();

  const factory ContactListState({
    @Default('') String keyword,
    @Default(<FirebaseConversationData>[]) List<FirebaseConversationData> conversationList,
  }) = _ContactListState;
}
