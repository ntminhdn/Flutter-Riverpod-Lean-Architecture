import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:file/local.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import 'index.dart';

Future<void> main() async {
  l10n = await AppString.delegate.load(TestConfig.l10nTestLocale);

  setUpAll(() async {
    // ViewModels
    registerFallbackValue(_MockConversationMembersMapStateController());
    registerFallbackValue(_MockCurrentUserStateController());

    // others
    registerFallbackValue(RequestOptions());
    registerFallbackValue(DioException(requestOptions: RequestOptions()));
    registerFallbackValue(
      AppFirebaseAuthException(kind: AppFirebaseAuthExceptionKind.invalidEmail),
    );
    registerFallbackValue(const FirebaseUserData());
    registerFallbackValue(const FirebaseConversationData());
    registerFallbackValue(const PageRouteInfo(''));
    registerFallbackValue(_FakeCommonPopup());
    registerFallbackValue(const RemoteMessage());
    registerFallbackValue(DioException(requestOptions: RequestOptions()));
    registerFallbackValue(RestMethod.get);
  });

  setUp(() {
    initializeDateFormatting();

    when(() => ref.read(appNavigatorProvider)).thenReturn(navigator);
    when(() => ref.read(exceptionHandlerProvider)).thenReturn(exceptionHandler);
    when(() => ref.read(appPreferencesProvider)).thenReturn(appPreferences);
    when(() => ref.read(appDatabaseProvider)).thenReturn(appDatabase);
    when(() => ref.read(appApiServiceProvider)).thenReturn(appApiService);
    when(() => ref.read(refreshTokenApiServiceProvider)).thenReturn(refreshTokenApiService);
    when(() => ref.read(loadMoreUsersExecutorProvider)).thenReturn(loadMoreUsersExecutor);
    when(() => ref.read(firebaseFirestoreServiceProvider)).thenReturn(firebaseFirestoreService);
    when(() => ref.read(firebaseAuthServiceProvider)).thenReturn(firebaseAuthService);
    when(() => ref.firebaseMessagingService).thenReturn(firebaseMessagingService);
    when(() => ref.read(firebaseMessagingServiceProvider)).thenReturn(firebaseMessagingService);
    when(() => ref.read(remoteMessageAppNotificationMapperProvider))
        .thenReturn(remoteMessageAppNotificationMapper);
    when(() => ref.read(analyticsHelperProvider)).thenReturn(analyticsHelper);
    when(() => ref.read(connectivityHelperProvider)).thenReturn(connectivityHelper);
    when(() => ref.read(crashlyticsHelperProvider)).thenReturn(crashlyticsHelper);
    when(() => ref.read(deepLinkHelperProvider)).thenReturn(deepLinkHelper);
    when(() => ref.read(deviceHelperProvider)).thenReturn(deviceHelper);
    when(() => ref.read(localPushNotificationHelperProvider))
        .thenReturn(localPushNotificationHelper);
    when(() => ref.read(packageHelperProvider)).thenReturn(packageHelper);
    when(() => ref.read(permissionHelperProvider)).thenReturn(permissionHelper);
    when(() => ref.read(sharedViewModelProvider)).thenReturn(sharedViewModel);
    when(() => ref.read(conversationMembersMapProvider.notifier))
        .thenReturn(conversationMembersMapStateController);
    when(() => ref.read(currentUserProvider.notifier)).thenReturn(currentUserStateController);
  });

  tearDown(() {
    resetMocktailState();
  });
}

// Fakes
class _FakeCommonPopup extends Fake implements CommonPopup {}

// Mocks
class MockCacheManager extends Mock implements BaseCacheManager {
  final fileSystem = const LocalFileSystem();

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool? withProgress,
  }) async* {
    final file = fileSystem.file('test/assets/mock_image.jpg');

    yield FileInfo(
      file,
      FileSource.Cache,
      DateTime(2050),
      url,
    );
  }
}

class MockInvalidCacheManager extends Mock implements BaseCacheManager {
  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool? withProgress,
  }) async* {
    throw HttpExceptionWithStatus(
      404,
      'Invalid statusCode 404',
      uri: Uri.parse(url),
    );
  }
}

class _MockRef extends Mock implements Ref {}

class _MockNavigator extends Mock implements AppNavigator {}

class _MockExceptionHandler extends Mock implements ExceptionHandler {}

class _MockAppPreferences extends Mock implements AppPreferences {}

class _MockAppDatabase extends Mock implements AppDatabase {}

class _MockAppApiService extends Mock implements AppApiService {}

class _MockRefreshTokenApiService extends Mock implements RefreshTokenApiService {}

class _MockLoadMoreUsersExecutor extends Mock implements LoadMoreUsersExecutor {}

class _MockFirebaseFirestoreService extends Mock implements FirebaseFirestoreService {}

class _MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

class _MockFirebaseMessagingService extends Mock implements FirebaseMessagingService {}

class _MockMessageDataMapper extends Mock implements MessageDataMapper {}

class _MockRemoteMessageAppNotificationMapper extends Mock
    implements RemoteMessageAppNotificationMapper {}

class _MockAnalyticsHelper extends Mock implements AnalyticsHelper {}

class _MockConnectivityHelper extends Mock implements ConnectivityHelper {}

class _MockCrashlyticsHelper extends Mock implements CrashlyticsHelper {}

class _MockDeepLinkHelper extends Mock implements DeepLinkHelper {}

class _MockDeviceHelper extends Mock implements DeviceHelper {}

class _MockLocalPushNotificationHelper extends Mock implements LocalPushNotificationHelper {}

class _MockPackageHelper extends Mock implements PackageHelper {}

class _MockPermissionHelper extends Mock implements PermissionHelper {}

class _MockSharedViewModel extends Mock implements SharedViewModel {}

class _MockConversationMembersMapStateController extends Mock
    implements StateController<Map<String, List<FirebaseConversationUserData>>> {}

class _MockCurrentUserStateController extends Mock implements StateController<FirebaseUserData> {}

final ref = _MockRef();
final navigator = _MockNavigator();
final exceptionHandler = _MockExceptionHandler();
final appPreferences = _MockAppPreferences();
final appDatabase = _MockAppDatabase();
final appApiService = _MockAppApiService();
final refreshTokenApiService = _MockRefreshTokenApiService();
final loadMoreUsersExecutor = _MockLoadMoreUsersExecutor();
final firebaseFirestoreService = _MockFirebaseFirestoreService();
final firebaseAuthService = _MockFirebaseAuthService();
final firebaseMessagingService = _MockFirebaseMessagingService();
final messageDataMapper = _MockMessageDataMapper();
final remoteMessageAppNotificationMapper = _MockRemoteMessageAppNotificationMapper();
final analyticsHelper = _MockAnalyticsHelper();
final connectivityHelper = _MockConnectivityHelper();
final crashlyticsHelper = _MockCrashlyticsHelper();
final deepLinkHelper = _MockDeepLinkHelper();
final deviceHelper = _MockDeviceHelper();
final localPushNotificationHelper = _MockLocalPushNotificationHelper();
final packageHelper = _MockPackageHelper();
final permissionHelper = _MockPermissionHelper();
final sharedViewModel = _MockSharedViewModel();
final conversationMembersMapStateController = _MockConversationMembersMapStateController();
final currentUserStateController = _MockCurrentUserStateController();
