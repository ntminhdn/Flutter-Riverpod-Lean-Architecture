import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../index.dart';

extension WidgetRefExt on WidgetRef {
  AppNavigator get nav => read(appNavigatorProvider);
  ExceptionHandler get exceptionHandler => read(exceptionHandlerProvider);
  AnalyticsHelper get analyticsHelper => read(analyticsHelperProvider);
  CrashlyticsHelper get crashlyticsHelper => read(crashlyticsHelperProvider);
  ConnectivityHelper get connectivityHelper => read(connectivityHelperProvider);

  // ignore: prefer_named_parameters
  T update<T>(StateProvider<T> provider, T Function(T) cb) {
    return read(provider.notifier).update(cb);
  }
}

extension RefExt on Ref {
  // ui
  AppNavigator get nav => read(appNavigatorProvider);
  ExceptionHandler get exceptionHandler => read(exceptionHandlerProvider);

  // local
  AppPreferences get appPreferences => read(appPreferencesProvider);
  AppDatabase get appDatabase => read(appDatabaseProvider);

  // api
  AppApiService get appApiService => read(appApiServiceProvider);
  RefreshTokenApiService get refreshTokenApiService => read(refreshTokenApiServiceProvider);
  LoadMoreUsersExecutor get loadMoreUsersExecutor => read(loadMoreUsersExecutorProvider);

  // firebase
  FirebaseFirestoreService get firebaseFirestoreService => read(firebaseFirestoreServiceProvider);
  FirebaseAuthService get firebaseAuthService => read(firebaseAuthServiceProvider);
  FirebaseMessagingService get firebaseMessagingService => read(firebaseMessagingServiceProvider);

  // mapper
  MessageDataMapper messageDataMapper(String conversationId) =>
      read(messageDataMapperProvider(conversationId));
  RemoteMessageAppNotificationMapper get remoteMessageAppNotificationMapper =>
      read(remoteMessageAppNotificationMapperProvider);

  // helper
  AnalyticsHelper get analyticsHelper => read(analyticsHelperProvider);
  ConnectivityHelper get connectivityHelper => read(connectivityHelperProvider);
  CrashlyticsHelper get crashlyticsHelper => read(crashlyticsHelperProvider);
  DeepLinkHelper get deepLinkHelper => read(deepLinkHelperProvider);
  DeviceHelper get deviceHelper => read(deviceHelperProvider);
  LocalPushNotificationHelper get localPushNotificationHelper =>
      read(localPushNotificationHelperProvider);
  PackageHelper get packageHelper => read(packageHelperProvider);
  PermissionHelper get permissionHelper => read(permissionHelperProvider);
  SharedViewModel get sharedViewModel => read(sharedViewModelProvider);

  // ignore: prefer_named_parameters
  T update<T>(StateProvider<T> provider, T Function(T) cb) {
    return read(provider.notifier).update(cb);
  }
}
