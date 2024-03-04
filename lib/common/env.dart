import '../index.dart';

enum Flavor { develop, qa, staging, production }

class Env {
  const Env._();

  static const _flavorKey = 'FLAVOR';
  static const _appBasicAuthNameKey = 'APP_BASIC_AUTH_NAME';
  static const _appBasicAuthPasswordKey = 'APP_BASIC_AUTH_PASSWORD';

  static late Flavor flavor =
      Flavor.values.byName(const String.fromEnvironment(_flavorKey, defaultValue: 'develop'));
  static const String appBasicAuthName = String.fromEnvironment(_appBasicAuthNameKey);
  static const String appBasicAuthPassword = String.fromEnvironment(_appBasicAuthPasswordKey);

  static void init() {
    Log.d(flavor, name: _flavorKey);
    Log.d(appBasicAuthName, name: _appBasicAuthNameKey);
    Log.d(appBasicAuthPassword, name: _appBasicAuthPasswordKey);
  }
}
