import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../index.dart';

final firebaseFirestoreServiceProvider = Provider<FirebaseFirestoreService>(
  (ref) => getIt.get<FirebaseFirestoreService>(),
);

@LazySingleton()
class FirebaseFirestoreService {
  static const _pathMessages = 'messages';
  static const _pathConversations = 'conversations';
  static const _pathUsers = 'users';

  CollectionReference<Map<String, dynamic>> get _userCollection =>
      FirebaseFirestore.instance.collection(_pathUsers);

  CollectionReference<Map<String, dynamic>> get _conversationCollection =>
      FirebaseFirestore.instance.collection(_pathConversations);

  CollectionReference<Map<String, dynamic>> _messageCollection(
    String conversationId,
  ) =>
      FirebaseFirestore.instance
          .collection(_pathConversations)
          .doc(conversationId)
          .collection(_pathMessages);

  Future<FirebaseUserData> getCurrentUser(String userId) async {
    final documentSnapshot = await _userCollection.doc(userId).get();

    return FirebaseUserData.fromJson(
      documentSnapshot.data() as Map<String, dynamic>,
    );
  }

  Future<void> updateCurrentUser({
    required String userId,
    required Map<Object, Object?> data,
  }) async {
    await _userCollection.doc(userId).update(data);
  }

  Future<void> putUserToFireStore({
    required String userId,
    required FirebaseUserData user,
  }) async {
    final createdAt = FieldValue.serverTimestamp();
    final doc = _userCollection.doc(userId);
    await doc.set({
      ...user.toJson(),
      FirebaseUserData.keyCreatedAt: createdAt,
      FirebaseUserData.keyUpdatedAt: createdAt,
    });
  }

  Future<void> deleteUser(String id) async {
    await _userCollection.doc(id).delete();
  }

  Future<void> deleteConversation(String id) async {
    await _conversationCollection.doc(id).delete();
  }

  Stream<List<FirebaseConversationData>> getConversationsStream(String userId) {
    return _conversationCollection
        .where(FirebaseConversationData.keyMemberIds, arrayContains: userId)
        .orderBy(FirebaseConversationData.keyUpdatedAt, descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => FirebaseConversationData.fromJson(e.data())).toList();
    });
  }

  Stream<FirebaseUserData> getUserDetailStream(String userId) {
    return _userCollection.doc(userId).snapshots().map((e) {
      return FirebaseUserData.fromJson(e.data() ?? {});
    });
  }

  Stream<List<FirebaseUserData>> getUsersExceptMembersStream(
    List<String> members,
  ) {
    return _userCollection
        .where(FirebaseUserData.keyId, whereNotIn: members)
        .orderBy(FirebaseUserData.keyId)
        .orderBy(FirebaseUserData.keyUpdatedAt, descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return FirebaseUserData.fromJson(e.data());
      }).toList();
    });
  }

  Future<FirebaseConversationData> createConversation(
    List<FirebaseConversationUserData> members,
  ) async {
    final createdAt = FieldValue.serverTimestamp();

    final collection = _conversationCollection.doc();

    final conversation = FirebaseConversationData(
      id: collection.id,
      lastMessage: '',
      lastMessageType: MessageType.text,
      memberIds: members.map((e) => e.userId).toList(),
      members: members,
    );
    await collection.set(
      {
        ...conversation.toJson(),
        FirebaseConversationData.keyCreatedAt: createdAt,
        FirebaseConversationData.keyUpdatedAt: createdAt,
      },
    );

    Log.d('Added conversation ${conversation.id}');

    return conversation;
  }

  Future<void> addMembers({
    required String conversationId,
    required List<FirebaseConversationUserData> members,
  }) async {
    await _conversationCollection.doc(conversationId).update({
      FirebaseConversationData.keyMembers: members.map((e) => e.toJson()).toList(),
      FirebaseConversationData.keyMemberIds: members.map((e) => e.userId).toList(),
    });
  }

  Future<List<FirebaseMessageData>> getOlderMessages({
    required String latestMessageId,
    required String conversationId,
  }) async {
    final messagesCollection = _messageCollection(conversationId);
    final prevDocument = await messagesCollection.doc(latestMessageId).get();

    final querySnapshot = await messagesCollection
        .orderBy(
          FirebaseMessageData.keyCreatedAt,
          descending: true,
        )
        .startAfterDocument(prevDocument)
        .limit(Constant.itemsPerPage)
        .get();

    return querySnapshot.docs.map((e) => FirebaseMessageData.fromJson(e.data())).toList();
  }

  Stream<List<FirebaseMessageData>> getMessagesStream({
    required String conversationId,
    required int limit,
  }) {
    return _messageCollection(conversationId)
        .orderBy(FirebaseMessageData.keyCreatedAt, descending: true)
        .limit(limit)
        .snapshots()
        .map((event) {
      return event.docs
          .map(
            (e) => FirebaseMessageData.fromJson(e.data()),
          )
          .toList();
    });
  }

  Stream<FirebaseConversationData?> getConversationDetailStream(String conversationId) {
    return _conversationCollection.doc(conversationId).snapshots().map((event) {
      final data = event.data();

      return data == null ? null : FirebaseConversationData.fromJson(data);
    });
  }

  String createMessageId(String conversationId) {
    return _messageCollection(conversationId).doc().id;
  }

  Future<void> createMessage({
    required String currentUserId,
    required String conversationId,
    required FirebaseMessageData message,
  }) async {
    final doc = _messageCollection(conversationId).doc(message.id);

    final createdAt = FieldValue.serverTimestamp();

    await Future.wait([
      doc.set(
        {
          ...message.toJson(),
          FirebaseMessageData.keyCreatedAt: createdAt,
          FirebaseMessageData.keyUpdatedAt: createdAt,
        },
      ),
      _conversationCollection.doc(conversationId).update({
        FirebaseConversationData.keyLastMessage: message.message,
        FirebaseConversationData.keyLastMessageType: message.type.code,
        FirebaseConversationData.keyUpdatedAt: createdAt,
      }),
    ]);
  }
}
