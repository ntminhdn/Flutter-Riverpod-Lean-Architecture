import 'package:chatview/chatview.dart' as cv;
import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'code')
enum MessageStatus {
  sending(0),
  sent(1),
  failed(2);

  const MessageStatus(this.code);
  final int code;

  cv.MessageStatus toChatViewMessageStatus() {
    switch (this) {
      case MessageStatus.sending:
        return cv.MessageStatus.pending;
      case MessageStatus.sent:
        return cv.MessageStatus.delivered;
      case MessageStatus.failed:
        return cv.MessageStatus.undelivered;
    }
  }
}
