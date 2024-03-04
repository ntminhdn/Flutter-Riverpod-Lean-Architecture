import 'package:chatview/chatview.dart' as cv;
import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'code')
enum MessageType {
  @JsonValue(0)
  text(0),
  @JsonValue(1)
  image(1),
  @JsonValue(2)
  video(2),
  @JsonValue(3)
  voice(3),
  @JsonValue(4)
  custom(4);

  const MessageType(this.code);
  factory MessageType.fromChatViewMessageType(cv.MessageType type) {
    switch (type) {
      case cv.MessageType.text:
        return MessageType.text;
      case cv.MessageType.image:
        return MessageType.image;
      case cv.MessageType.voice:
        return MessageType.voice;
      case cv.MessageType.custom:
        return MessageType.custom;
    }
  }
  final int code;

  cv.MessageType toChatViewMessageType() {
    switch (this) {
      case MessageType.text:
        return cv.MessageType.text;
      case MessageType.image:
        return cv.MessageType.image;
      case MessageType.video:
        return cv.MessageType.image;
      case MessageType.voice:
        return cv.MessageType.voice;
      case MessageType.custom:
        return cv.MessageType.custom;
    }
  }
}
