import 'package:chatview/chatview.dart' as cv;
import 'package:isar/isar.dart';

import '../../index.dart';

part 'local_message_data.g.dart';

@collection
class LocalMessageData {
  LocalMessageData({
    this.uniqueID = '',
    this.userId = '',
    this.conversationId = '',
    this.senderId = '',
    this.type = MessageType.text,
    this.status = MessageStatus.sending,
    this.message = '',
    this.createdAt = 0,
    this.updatedAt = 0,
    this.replyMessage,
  }) : assert(createdAt > 0);

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  String uniqueID;
  String userId;
  String conversationId;
  String senderId;
  @Enumerated(EnumType.value, 'code')
  MessageType type;
  @Enumerated(EnumType.value, 'code')
  MessageStatus status;
  String message;
  int createdAt;
  int updatedAt;
  LocalReplyMessageData? replyMessage;

  @override
  String toString() {
    return 'LocalMessageData{id: $id, uniqueID: $uniqueID, userId: $userId, conversationId: $conversationId, senderId: $senderId, type: $type, status: $status, message: $message, createdAt: $createdAt, updatedAt: $updatedAt, replyMessage: $replyMessage}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalMessageData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          uniqueID == other.uniqueID &&
          userId == other.userId &&
          conversationId == other.conversationId &&
          senderId == other.senderId &&
          type == other.type &&
          status == other.status &&
          message == other.message &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          replyMessage == other.replyMessage;

  @override
  int get hashCode =>
      id.hashCode ^
      uniqueID.hashCode ^
      userId.hashCode ^
      conversationId.hashCode ^
      senderId.hashCode ^
      type.hashCode ^
      status.hashCode ^
      message.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      replyMessage.hashCode;

  cv.Message toMessage() {
    return cv.Message(
      id: uniqueID,
      message: message,
      sendBy: senderId,
      replyMessage: replyMessage?.toReplyMessage() ?? const cv.ReplyMessage(),
      messageType: type.toChatViewMessageType(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      status: status.toChatViewMessageStatus(),
    );
  }
}
