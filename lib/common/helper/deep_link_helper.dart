import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../index.dart';

final deepLinkHelperProvider = Provider<DeepLinkHelper>(
  (ref) => getIt.get<DeepLinkHelper>(),
);

@LazySingleton()
class DeepLinkHelper {
  DeepLinkHelper(
    this._navigator,
    this._appPreferences,
  );

  final AppNavigator _navigator;
  final AppPreferences _appPreferences;

  static const String emailResetPassword = 'email';
  static const String tokenResetPassword = 'token';

  late final appLinks = AppLinks();
  StreamSubscription<String>? _appLinksSubscription;

  void listenToDeepLinks() {
    _appLinksSubscription = appLinks.stringLinkStream.listen((event) {
      if (event == Constant.resetPasswordLink && !_appPreferences.isLoggedIn) {
        _navigator.replaceAll([const LoginRoute()]);
      }
    });
  }

  void dispose() {
    _appLinksSubscription?.cancel();
  }
}
