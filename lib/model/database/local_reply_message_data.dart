import 'package:chatview/chatview.dart' as cv;
import 'package:isar/isar.dart';

import '../../index.dart';

part 'local_reply_message_data.g.dart';

@embedded
class LocalReplyMessageData {
  LocalReplyMessageData({
    this.userId = '',
    this.conversationId = '',
    this.repplyToMessageId = '',
    this.type = MessageType.text,
    this.repplyToMessage = '',
    this.replyByUserId = '',
    this.replyToUserId = '',
  });

  String userId;
  String conversationId;
  String repplyToMessageId;
  @Enumerated(EnumType.value, 'code')
  MessageType type;
  String repplyToMessage;
  String replyByUserId;
  String replyToUserId;

  @override
  String toString() {
    return 'LocalReplyMessageData{userId: $userId, conversationId: $conversationId, repplyToMessageId: $repplyToMessageId, type: $type, repplyToMessage: $repplyToMessage, replyByUserId: $replyByUserId, replyToUserId: $replyToUserId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalReplyMessageData &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          conversationId == other.conversationId &&
          repplyToMessageId == other.repplyToMessageId &&
          type == other.type &&
          repplyToMessage == other.repplyToMessage &&
          replyByUserId == other.replyByUserId &&
          replyToUserId == other.replyToUserId;

  @override
  int get hashCode =>
      userId.hashCode ^
      conversationId.hashCode ^
      repplyToMessageId.hashCode ^
      type.hashCode ^
      repplyToMessage.hashCode ^
      replyByUserId.hashCode ^
      replyToUserId.hashCode;

  cv.ReplyMessage toReplyMessage() {
    return cv.ReplyMessage(
      message: repplyToMessage,
      messageType: type.toChatViewMessageType(),
      messageId: repplyToMessageId,
      replyTo: replyToUserId,
      replyBy: replyByUserId,
    );
  }
}
