import 'package:clock/clock.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../index.dart';

final messageDataMapperProvider = Provider.autoDispose.family<MessageDataMapper, String>(
  (ref, conversationId) => getIt.get<MessageDataMapper>(
    param1: getIt.get<AppPreferences>(),
    param2: conversationId,
  ),
);

@Injectable()
class MessageDataMapper extends BaseDataMapper<FirebaseMessageData, LocalMessageData>
    with DataMapperMixin {
  MessageDataMapper(
    @factoryParam this._appPreferences,
    @factoryParam this._conversationId,
  );

  final AppPreferences _appPreferences;
  final String _conversationId;

  @override
  LocalMessageData mapToLocal(FirebaseMessageData? data) {
    return LocalMessageData(
      userId: _appPreferences.userId,
      conversationId: _conversationId,
      uniqueID: data?.id ?? '',
      senderId: data?.senderId ?? '',
      message: data?.message ?? '',
      type: data?.type ?? MessageType.text,
      status: MessageStatus.sent,
      createdAt: data?.createdAt?.millisecondsSinceEpoch ?? clock.now().millisecondsSinceEpoch,
      updatedAt: data?.updatedAt?.millisecondsSinceEpoch ?? clock.now().millisecondsSinceEpoch,
      replyMessage: data?.replyMessage == null
          ? null
          : LocalReplyMessageData(
              userId: _appPreferences.userId,
              repplyToMessageId: data?.replyMessage?.replyToMessageId ?? '',
              type: data?.replyMessage?.type ?? MessageType.text,
              repplyToMessage: data?.replyMessage?.replyToMessage ?? '',
              replyByUserId: data?.replyMessage?.replyByUserId ?? '',
              replyToUserId: data?.replyMessage?.replyToUserId ?? '',
            ),
    );
  }

  @override
  FirebaseMessageData mapToRemote(LocalMessageData data) {
    return FirebaseMessageData(
      id: data.uniqueID,
      senderId: data.senderId,
      message: data.message,
      type: data.type,
      replyMessage: data.replyMessage == null
          ? null
          : FirebaseReplyMessageData(
              replyToMessageId: data.replyMessage!.repplyToMessageId,
              type: data.replyMessage!.type,
              replyToMessage: data.replyMessage!.repplyToMessage,
              replyByUserId: data.replyMessage!.replyByUserId,
              replyToUserId: data.replyMessage!.replyToUserId,
            ),
    );
  }
}
