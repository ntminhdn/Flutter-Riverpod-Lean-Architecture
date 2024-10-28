import 'package:chatview/chatview.dart' as cv;
import 'package:isar/isar.dart';

import '../../index.dart';

part 'local_reply_message_data.g.dart';

@embedded
class LocalReplyMessageData {
  LocalReplyMessageData({
    this.userId = '',
    this.conversationId = '',
    this.replyToMessageId = '',
    this.type = MessageType.text,
    this.replyToMessage = '',
    this.replyByUserId = '',
    this.replyToUserId = '',
  });

  String userId;
  String conversationId;
  String replyToMessageId;
  @Enumerated(EnumType.value, 'code')
  MessageType type;
  String replyToMessage;
  String replyByUserId;
  String replyToUserId;

  @override
  String toString() {
    return 'LocalReplyMessageData{userId: $userId, conversationId: $conversationId, replyToMessageId: $replyToMessageId, type: $type, replyToMessage: $replyToMessage, replyByUserId: $replyByUserId, replyToUserId: $replyToUserId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalReplyMessageData &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          conversationId == other.conversationId &&
          replyToMessageId == other.replyToMessageId &&
          type == other.type &&
          replyToMessage == other.replyToMessage &&
          replyByUserId == other.replyByUserId &&
          replyToUserId == other.replyToUserId;

  @override
  int get hashCode =>
      userId.hashCode ^
      conversationId.hashCode ^
      replyToMessageId.hashCode ^
      type.hashCode ^
      replyToMessage.hashCode ^
      replyByUserId.hashCode ^
      replyToUserId.hashCode;

  cv.ReplyMessage toReplyMessage() {
    return cv.ReplyMessage(
      message: replyToMessage,
      messageType: type.toChatViewMessageType(),
      messageId: replyToMessageId,
      replyTo: replyToUserId,
      replyBy: replyByUserId,
    );
  }
}
