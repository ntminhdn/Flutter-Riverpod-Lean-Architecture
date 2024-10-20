import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: prefer_importing_index_file
import 'di.config.dart';
import 'index.dart';

@module
abstract class ServiceModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  Future<Isar> get isar => openIsar();
}

final GetIt getIt = GetIt.instance;
@injectableInit
Future<void> configureInjection() => getIt.init();
