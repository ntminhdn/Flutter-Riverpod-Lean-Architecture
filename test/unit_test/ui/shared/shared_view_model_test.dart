import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  late SharedViewModel sharedViewModel;

  setUp(() {
    sharedViewModel = SharedViewModel(ref);
  });

  group('deviceToken', () {
    test('when `firebaseMessagingService.deviceToken` returns a non-null value', () async {
      const dummyDeviceToken = 'token123';
      const expectedDeviceToken = 'token123';

      when(() => firebaseMessagingService.deviceToken).thenAnswer((_) async => dummyDeviceToken);
      when(() => appPreferences.saveDeviceToken(dummyDeviceToken)).thenAnswer((_) async => true);
      final result = await sharedViewModel.deviceToken;

      expect(result, expectedDeviceToken);
      verify(() => appPreferences.saveDeviceToken(dummyDeviceToken)).called(1);
    });

    test('when `firebaseMessagingService.deviceToken` returns null', () async {
      const String? dummyDeviceToken = null;
      const expectedDeviceToken = '';

      when(() => firebaseMessagingService.deviceToken).thenAnswer((_) async => dummyDeviceToken);
      final result = await sharedViewModel.deviceToken;

      expect(result, expectedDeviceToken);
      verifyNever(() => appPreferences.saveDeviceToken(any()));
    });

    test('when `firebaseMessagingService.deviceToken` throws an error', () async {
      final dummyError = Exception();
      const expectedError = throwsException;

      when(() => firebaseMessagingService.deviceToken).thenThrow(dummyError);

      expect(sharedViewModel.deviceToken, expectedError);
      verifyNever(() => appPreferences.saveDeviceToken(any()));
    });
  });

  group('getRenamedMembers', () {
    test('when `members` is not empty and `getUserNickname` returns non-null values', () {
      const dummyMembers = [
        FirebaseConversationUserData(userId: 'id1', email: 'email1'),
        FirebaseConversationUserData(userId: 'id2', email: 'email2'),
      ];
      const expectedMembers = [
        FirebaseConversationUserData(userId: 'id1', email: 'nickname1'),
        FirebaseConversationUserData(userId: 'id2', email: 'nickname2'),
      ];

      when(() => appPreferences.getUserNickname(
            conversationId: 'conversationId',
            memberId: 'id1',
          )).thenAnswer((_) => 'nickname1');

      when(() => appPreferences.getUserNickname(
            conversationId: 'conversationId',
            memberId: 'id2',
          )).thenAnswer((_) => 'nickname2');

      final result = sharedViewModel.getRenamedMembers(
        members: dummyMembers,
        conversationId: 'conversationId',
      );

      expect(result, expectedMembers);
    });

    test('when `members` is not empty and `getUserNickname` returns null values', () {
      const dummyMembers = [
        FirebaseConversationUserData(userId: 'id1', email: 'email1'),
        FirebaseConversationUserData(userId: 'id2', email: 'email2'),
      ];
      final expectedMembers = dummyMembers.toList();

      when(() => appPreferences.getUserNickname(
            conversationId: 'conversationId',
            memberId: 'id1',
          )).thenAnswer((_) => null);

      when(() => appPreferences.getUserNickname(
            conversationId: 'conversationId',
            memberId: 'id2',
          )).thenAnswer((_) => null);

      final result = sharedViewModel.getRenamedMembers(
        members: dummyMembers,
        conversationId: 'conversationId',
      );

      expect(result, expectedMembers);
    });

    test('when `members` is empty', () {
      const dummyMembers = <FirebaseConversationUserData>[];
      const expectedMembers = <FirebaseConversationUserData>[];

      final result = sharedViewModel.getRenamedMembers(
        members: dummyMembers,
        conversationId: 'conversationId',
      );

      expect(result, expectedMembers);
    });
  });

  group('logout', () {
    const dummyDeviceToken = 'token123';
    const dummyUserId = 'userId';
    const dummyUserData = FirebaseUserData(
      id: dummyUserId,
      deviceIds: [],
      deviceTokens: [dummyDeviceToken],
    );

    setUp(() {
      when(() => firebaseMessagingService.deviceToken).thenAnswer((_) async => dummyDeviceToken);
      when(() => appPreferences.saveDeviceToken(dummyDeviceToken)).thenAnswer((_) async => true);
      when(() => appPreferences.userId).thenReturn(dummyUserId);
      when(() => firebaseFirestoreService.updateCurrentUser(
            userId: dummyUserId,
            data: {
              FirebaseUserData.keyDeviceIds: [],
              FirebaseUserData.keyDeviceTokens: FieldValue.arrayRemove([dummyDeviceToken]),
            },
          )).thenAnswer((_) async => true);
      when(() => appPreferences.clearCurrentUserData()).thenAnswer((_) async => true);
      when(() => firebaseAuthService.signOut()).thenAnswer((_) async => true);
      when(() => currentUserStateController.update(any())).thenReturn(dummyUserData);
      when(() => navigator.replaceAll([const LoginRoute()])).thenAnswer((_) async => true);
    });

    test('when loggout success', () async {
      await sharedViewModel.logout();

      verify(() => firebaseFirestoreService.updateCurrentUser(
            userId: dummyUserId,
            data: {
              FirebaseUserData.keyDeviceIds: [],
              FirebaseUserData.keyDeviceTokens: FieldValue.arrayRemove([dummyDeviceToken]),
            },
          )).called(1);
      verify(() => appPreferences.clearCurrentUserData()).called(1);
      verify(() => firebaseAuthService.signOut()).called(1);
      verify(() => currentUserStateController.update(any())).called(1);
      verify(() => navigator.replaceAll([const LoginRoute()])).called(1);
    });

    test('when `firebaseFirestoreService.updateCurrentUser` throws an error', () async {
      final dummyError = Exception();
      when(() => firebaseFirestoreService.updateCurrentUser(
            userId: dummyUserId,
            data: {
              FirebaseUserData.keyDeviceIds: [],
              FirebaseUserData.keyDeviceTokens: FieldValue.arrayRemove([dummyDeviceToken]),
            },
          )).thenThrow(dummyError);

      await sharedViewModel.logout();

      verify(() => firebaseFirestoreService.updateCurrentUser(
            userId: dummyUserId,
            data: {
              FirebaseUserData.keyDeviceIds: [],
              FirebaseUserData.keyDeviceTokens: FieldValue.arrayRemove([dummyDeviceToken]),
            },
          )).called(1);
      verifyNever(() => appPreferences.clearCurrentUserData());
      verifyNever(() => firebaseAuthService.signOut());
      verifyNever(() => currentUserStateController.update(any()));
      verify(() => navigator.replaceAll([const LoginRoute()])).called(1);
    });

    test('when `firebaseAuthService.signOut` throws an error', () async {
      final dummyError = Exception();
      when(() => firebaseAuthService.signOut()).thenThrow(dummyError);

      await sharedViewModel.logout();

      verify(() => firebaseFirestoreService.updateCurrentUser(
            userId: dummyUserId,
            data: {
              FirebaseUserData.keyDeviceIds: [],
              FirebaseUserData.keyDeviceTokens: FieldValue.arrayRemove([dummyDeviceToken]),
            },
          )).called(1);
      verify(() => appPreferences.clearCurrentUserData()).called(1);
      verify(() => firebaseAuthService.signOut()).called(1);
      verifyNever(() => currentUserStateController.update(any()));
      verify(() => navigator.replaceAll([const LoginRoute()])).called(1);
    });
  });

  group('deleteConversation', () {
    const dummyConversation = FirebaseConversationData(id: 'id', members: []);

    setUp(() {
      when(() => firebaseFirestoreService.deleteConversation('id')).thenAnswer((_) async => true);
      when(() => appDatabase.removeMessagesByConversationId('id')).thenAnswer((_) async => 0);
    });

    test('when `firebaseFirestoreService.deleteConversation` success', () async {
      await sharedViewModel.deleteConversation(dummyConversation);

      verify(() => firebaseFirestoreService.deleteConversation(dummyConversation.id)).called(1);
      verify(() => appDatabase.removeMessagesByConversationId(dummyConversation.id)).called(1);
    });

    test('when `firebaseFirestoreService.deleteConversation` throws an error', () async {
      final dummyError = Exception();
      when(() => firebaseFirestoreService.deleteConversation('id')).thenThrow(dummyError);

      expect(
        sharedViewModel.deleteConversation(dummyConversation),
        throwsA(dummyError),
      );

      verify(() => firebaseFirestoreService.deleteConversation('id')).called(1);
      verifyNever(() => appDatabase.removeMessagesByConversationId('id'));
    });
  });
}
