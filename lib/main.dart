import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'index.dart';

// ignore: avoid_unnecessary_async_function
Future<void> main() async => runZonedGuarded(
      _runMyApp,
      (error, stackTrace) => _reportError(error: error, stackTrace: stackTrace),
    );

Future<void> _runMyApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AppInitializer.init();
  final initialResource = _loadInitialResource();
  runApp(ProviderScope(
    observers: [AppProviderObserver()],
    child: MyApp(initialResource: initialResource),
  ));
}

void _reportError({required error, required StackTrace stackTrace}) {
  Log.e(error, stackTrace: stackTrace, name: 'Uncaught exception');
  getIt.get<CrashlyticsHelper>().recordError(exception: error, stack: stackTrace);
}

InitialResource _loadInitialResource() {
  final appPreferences = getIt.get<AppPreferences>();
  final result = InitialResource(
    initialRoutes: [appPreferences.isLoggedIn ? InitialAppRoute.main : InitialAppRoute.login],
  );

  return result;
}
