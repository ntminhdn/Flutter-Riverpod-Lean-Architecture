import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  group('languageCodeProvider', () {
    test('when `appPreferences.languageCode` is not empty', () {
      when(() => appPreferences.languageCode).thenReturn(Constant.en);
      when(() => appPreferences.saveLanguageCode(Constant.en)).thenAnswer((_) async => true);
      final expectedValue = LanguageCode.fromValue(Constant.en);

      final container = TestUtil.createContainer(
        overrides: [
          appPreferencesProvider.overrideWith((_) => appPreferences),
        ],
      );

      final result = container.read(languageCodeProvider);
      expect(result, expectedValue);
      verify(() => appPreferences.saveLanguageCode(Constant.en)).called(1);
    });

    test('when `appPreferences.languageCode` is empty', () {
      when(() => appPreferences.languageCode).thenReturn('');
      when(() => appPreferences.saveLanguageCode(LanguageCode.defaultValue.value))
          .thenAnswer((_) async => true);
      const expectedValue = LanguageCode.defaultValue;

      final container = TestUtil.createContainer(
        overrides: [
          appPreferencesProvider.overrideWith((_) => appPreferences),
        ],
      );

      final result = container.read(languageCodeProvider);
      expect(result, expectedValue);
      verify(() => appPreferences.saveLanguageCode(LanguageCode.defaultValue.value)).called(1);
    });
  });

  group('isDarkModeProvider', () {
    test('when `appPreferences.isDarkMode` is not empty', () {
      when(() => appPreferences.isDarkMode).thenReturn(true);
      when(() => appPreferences.saveIsDarkMode(true)).thenAnswer((_) async => true);
      const expectedValue = true;

      final container = TestUtil.createContainer(
        overrides: [
          appPreferencesProvider.overrideWith((_) => appPreferences),
        ],
      );

      final result = container.read(isDarkModeProvider);
      expect(result, expectedValue);
      verify(() => appPreferences.saveIsDarkMode(true)).called(1);
    });

    test('when `appPreferences.isDarkMode` is empty', () {
      when(() => appPreferences.isDarkMode).thenReturn(false);
      when(() => appPreferences.saveIsDarkMode(false)).thenAnswer((_) async => true);
      const expectedValue = false;

      final container = TestUtil.createContainer(
        overrides: [
          appPreferencesProvider.overrideWith((_) => appPreferences),
        ],
      );

      final result = container.read(isDarkModeProvider);
      expect(result, expectedValue);
      verify(() => appPreferences.saveIsDarkMode(false)).called(1);
    });
  });

  group('conversationNameProvider', () {
    setUp(() {
      when(() => appPreferences.saveUserId(any())).thenAnswer((_) async => true);
      when(() => appPreferences.saveEmail(any())).thenAnswer((_) async => true);
    });

    test('when `conversationMembersMap` does not contain `conversationId`', () {
      final container = TestUtil.createContainer(
        overrides: [
          conversationMembersMapProvider.overrideWith((_) => {
                'conversationId1': const [],
              }),
          appPreferencesProvider.overrideWith((_) => appPreferences),
        ],
      );

      final result = container.read(conversationNameProvider('otherConversationId'));
      expect(result, '');
    });

    test('when `conversationMembersMap` contains `conversationId` but its value is empty', () {
      final container = TestUtil.createContainer(
        overrides: [
          conversationMembersMapProvider.overrideWith((_) => {
                'conversationId1': [],
              }),
          appPreferencesProvider.overrideWith((_) => appPreferences),
        ],
      );

      final result = container.read(conversationNameProvider('conversationId1'));
      expect(result, '');
    });

    test(
      'when `currentUserProvider` is empty '
      'and `conversationMembersMap` contains `conversationId` and its value is not empty',
      () {
        final container = TestUtil.createContainer(
          overrides: [
            conversationMembersMapProvider.overrideWith((_) => {
                  'conversationId1': [
                    const FirebaseConversationUserData(userId: 'id1', email: 'email1'),
                    const FirebaseConversationUserData(userId: 'id2', email: 'email2'),
                  ],
                }),
            appPreferencesProvider.overrideWith((_) => appPreferences),
          ],
        );

        final result = container.read(conversationNameProvider('conversationId1'));
        expect(result, 'email1, email2');
      },
    );

    test(
      'when `currentUserProvider` is not empty and `conversationMembersMap` contains current user '
      'and `conversationMembersMap` contains `conversationId` and its value is not empty',
      () {
        final container = TestUtil.createContainer(
          overrides: [
            currentUserProvider
                .overrideWith((_) => const FirebaseUserData(id: 'id1', email: 'email1')),
            conversationMembersMapProvider.overrideWith((_) => {
                  'conversationId1': [
                    const FirebaseConversationUserData(userId: 'id1', email: 'email1'),
                    const FirebaseConversationUserData(userId: 'id2', email: 'email2'),
                  ],
                }),
          ],
        );

        final result = container.read(conversationNameProvider('conversationId1'));
        expect(result, 'email2');
      },
    );

    test(
      'when `currentUserProvider` is not empty and `conversationMembersMap` does not contain current user '
      'and `conversationMembersMap` contains `conversationId` and its value is not empty',
      () {
        final container = TestUtil.createContainer(
          overrides: [
            currentUserProvider
                .overrideWith((_) => const FirebaseUserData(id: 'id3', email: 'email3')),
            conversationMembersMapProvider.overrideWith((_) => {
                  'conversationId1': [
                    const FirebaseConversationUserData(userId: 'id1', email: 'email1'),
                    const FirebaseConversationUserData(userId: 'id2', email: 'email2'),
                  ],
                }),
          ],
        );

        final result = container.read(conversationNameProvider('conversationId1'));
        expect(result, 'email1, email2');
      },
    );
  });

  group('filteredConversationsProvider', () {
    group('when `conversations` is empty', () {
      group('when `keyword` is empty', () {
        test('when `conversationMembersMap` is empty', () {
          const expectedValue = <FirebaseConversationData>[];

          final container = TestUtil.createContainer(
            overrides: [
              contactListViewModelProvider.overrideWith(
                (_) => _MockContactListViewModel(conversationList: [], keyword: ''),
              ),
              conversationMembersMapProvider.overrideWith((_) => {}),
            ],
          );

          final result = container.read(filteredConversationsProvider);
          expect(result, expectedValue);
        });

        test('when `conversationMembersMap` is not empty', () {
          const expectedValue = <FirebaseConversationData>[];

          final container = TestUtil.createContainer(
            overrides: [
              contactListViewModelProvider.overrideWith(
                (_) => _MockContactListViewModel(conversationList: [], keyword: ''),
              ),
              conversationMembersMapProvider.overrideWith((_) => {
                    'id1': [
                      const FirebaseConversationUserData(userId: 'id1', email: 'email1'),
                    ],
                    'id2': [
                      const FirebaseConversationUserData(userId: 'id2', email: 'email2'),
                    ],
                  }),
            ],
          );

          final result = container.read(filteredConversationsProvider);
          expect(result, expectedValue);
        });
      });

      group('when `keyword` is not empty', () {
        test('when `conversationMembersMap` is empty', () {
          const expectedValue = <FirebaseConversationData>[];

          final container = TestUtil.createContainer(
            overrides: [
              contactListViewModelProvider.overrideWith(
                (_) => _MockContactListViewModel(conversationList: [], keyword: 'keyword'),
              ),
              conversationMembersMapProvider.overrideWith((_) => {}),
            ],
          );

          final result = container.read(filteredConversationsProvider);
          expect(result, expectedValue);
        });

        test('when `conversationMembersMap` is not empty', () {
          const expectedValue = <FirebaseConversationData>[];

          final container = TestUtil.createContainer(
            overrides: [
              contactListViewModelProvider.overrideWith(
                (_) => _MockContactListViewModel(conversationList: [], keyword: 'keyword'),
              ),
              conversationMembersMapProvider.overrideWith((_) => {
                    'id1': [
                      const FirebaseConversationUserData(userId: 'id1', email: 'email1'),
                    ],
                    'id2': [
                      const FirebaseConversationUserData(userId: 'id2', email: 'email2'),
                    ],
                  }),
            ],
          );

          final result = container.read(filteredConversationsProvider);
          expect(result, expectedValue);
        });
      });
    });

    group('when `conversations` is not empty', () {
      group('when `keyword` is empty', () {
        test('when `conversationMembersMap` is empty', () {
          const dummyConversations = [
            FirebaseConversationData(id: 'id1', members: [
              FirebaseConversationUserData(userId: 'id1', email: 'email1'),
            ]),
            FirebaseConversationData(id: 'id2', members: [
              FirebaseConversationUserData(userId: 'id2', email: 'email2'),
            ]),
          ];
          const expectedValue = <FirebaseConversationData>[
            FirebaseConversationData(id: 'id1', members: [
              FirebaseConversationUserData(userId: 'id1', email: 'email1'),
            ]),
            FirebaseConversationData(id: 'id2', members: [
              FirebaseConversationUserData(userId: 'id2', email: 'email2'),
            ]),
          ];

          final container = TestUtil.createContainer(
            overrides: [
              contactListViewModelProvider.overrideWith(
                (_) => _MockContactListViewModel(
                  conversationList: dummyConversations,
                  keyword: '',
                ),
              ),
              conversationMembersMapProvider.overrideWith((_) => {}),
            ],
          );

          final result = container.read(filteredConversationsProvider);
          expect(result, expectedValue);
        });

        test('when `conversationMembersMap` is not empty', () {
          const dummyConversations = [
            FirebaseConversationData(id: 'id1', members: [
              FirebaseConversationUserData(userId: 'id1', email: 'email1'),
            ]),
            FirebaseConversationData(id: 'id2', members: [
              FirebaseConversationUserData(userId: 'id2', email: 'email2'),
            ]),
          ];
          const dummyConversationMembersMap = {
            'id1': [
              FirebaseConversationUserData(userId: 'id1', email: 'nickname1'),
            ],
            'id2': [
              FirebaseConversationUserData(userId: 'id2', email: 'nickname2'),
            ],
          };
          const expectedValue = <FirebaseConversationData>[
            FirebaseConversationData(id: 'id1', members: [
              FirebaseConversationUserData(userId: 'id1', email: 'nickname1'),
            ]),
            FirebaseConversationData(id: 'id2', members: [
              FirebaseConversationUserData(userId: 'id2', email: 'nickname2'),
            ]),
          ];

          final container = TestUtil.createContainer(
            overrides: [
              contactListViewModelProvider.overrideWith(
                (_) => _MockContactListViewModel(
                  conversationList: dummyConversations,
                  keyword: '',
                ),
              ),
              conversationMembersMapProvider.overrideWith((_) => dummyConversationMembersMap),
            ],
          );

          final result = container.read(filteredConversationsProvider);
          expect(result, expectedValue);
        });
      });
      group('when `keyword` is not empty', () {
        test('when `conversationMembersMap` does not contain any conversationIds', () {
          const dummyConversations = [
            FirebaseConversationData(id: 'id1', members: [
              FirebaseConversationUserData(userId: 'id1', email: 'minh'),
            ]),
            FirebaseConversationData(id: 'id2', members: [
              FirebaseConversationUserData(userId: 'id2', email: 'duy'),
            ]),
          ];
          const expectedValue = [
            FirebaseConversationData(id: 'id2', members: [
              FirebaseConversationUserData(userId: 'id2', email: 'duy'),
            ]),
          ];

          final container = TestUtil.createContainer(
            overrides: [
              contactListViewModelProvider.overrideWith(
                (_) => _MockContactListViewModel(
                  conversationList: dummyConversations,
                  keyword: 'du',
                ),
              ),
              conversationMembersMapProvider.overrideWith((_) => {}),
            ],
          );

          final result = container.read(filteredConversationsProvider);
          expect(result, expectedValue);
        });

        test('when `conversationMembersMap` contains all conversationId', () {
          const dummyConversations = [
            FirebaseConversationData(id: 'id1', members: [
              FirebaseConversationUserData(userId: 'id1', email: 'minh'),
            ]),
            FirebaseConversationData(id: 'id2', members: [
              FirebaseConversationUserData(userId: 'id2', email: 'duy'),
            ]),
          ];
          const dummyConversationMembersMap = {
            'id1': [
              FirebaseConversationUserData(userId: 'id1', email: 'kin'),
            ],
            'id2': [
              FirebaseConversationUserData(userId: 'id2', email: 'duy map'),
            ],
          };
          const expectedValue = [
            FirebaseConversationData(id: 'id1', members: [
              FirebaseConversationUserData(userId: 'id1', email: 'kin'),
            ]),
          ];

          final container = TestUtil.createContainer(
            overrides: [
              contactListViewModelProvider.overrideWith(
                (_) => _MockContactListViewModel(
                  conversationList: dummyConversations,
                  keyword: 'ki',
                ),
              ),
              conversationMembersMapProvider.overrideWith((_) => dummyConversationMembersMap),
            ],
          );

          final result = container.read(filteredConversationsProvider);
          expect(result, expectedValue);
        });

        test('when `conversationMembersMap` contains some conversationId', () {
          const dummyConversations = [
            FirebaseConversationData(id: 'id1', members: [
              FirebaseConversationUserData(userId: 'id1', email: 'minh'),
            ]),
            FirebaseConversationData(id: 'id2', members: [
              FirebaseConversationUserData(userId: 'id2', email: 'king'),
            ]),
          ];
          const dummyConversationMembersMap = {
            'id1': [
              FirebaseConversationUserData(userId: 'id1', email: 'kin'),
            ],
          };
          const expectedValue = [
            FirebaseConversationData(id: 'id1', members: [
              FirebaseConversationUserData(userId: 'id1', email: 'kin'),
            ]),
            FirebaseConversationData(id: 'id2', members: [
              FirebaseConversationUserData(userId: 'id2', email: 'king'),
            ]),
          ];

          final container = TestUtil.createContainer(
            overrides: [
              contactListViewModelProvider.overrideWith(
                (_) => _MockContactListViewModel(
                  conversationList: dummyConversations,
                  keyword: 'ki',
                ),
              ),
              conversationMembersMapProvider.overrideWith((_) => dummyConversationMembersMap),
            ],
          );

          final result = container.read(filteredConversationsProvider);
          expect(result, expectedValue);
        });
      });
    });
  });
}

class _MockContactListViewModel extends StateNotifier<CommonState<ContactListState>>
    with Mock
    implements ContactListViewModel {
  _MockContactListViewModel({
    required List<FirebaseConversationData> conversationList,
    required String keyword,
  }) : super(CommonState<ContactListState>(
          data: ContactListState(
            conversationList: conversationList,
            keyword: keyword,
          ),
        ));
}
