import 'package:chatview/chatview.dart' as cv;
import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('fromChatViewMessageType', () {
    test('when type is `text`', () async {
      final result = MessageType.fromChatViewMessageType(cv.MessageType.text);
      expect(result, MessageType.text);
    });

    test('when type is `image`', () async {
      final result = MessageType.fromChatViewMessageType(cv.MessageType.image);
      expect(result, MessageType.image);
    });

    test('when type is `voice`', () async {
      final result = MessageType.fromChatViewMessageType(cv.MessageType.voice);
      expect(result, MessageType.voice);
    });

    test('when type is `custom`', () async {
      final result = MessageType.fromChatViewMessageType(cv.MessageType.custom);
      expect(result, MessageType.custom);
    });
  });

  group('toChatViewMessageType', () {
    test('when type is `text`', () async {
      final result = MessageType.text.toChatViewMessageType();
      expect(result, cv.MessageType.text);
    });

    test('when type is `image`', () async {
      final result = MessageType.image.toChatViewMessageType();
      expect(result, cv.MessageType.image);
    });

    test('when type is `video`', () async {
      final result = MessageType.video.toChatViewMessageType();
      expect(result, cv.MessageType.image);
    });

    test('when type is `voice`', () async {
      final result = MessageType.voice.toChatViewMessageType();
      expect(result, cv.MessageType.voice);
    });

    test('when type is `custom`', () async {
      final result = MessageType.custom.toChatViewMessageType();
      expect(result, cv.MessageType.custom);
    });
  });
}
