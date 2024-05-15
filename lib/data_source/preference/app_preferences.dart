import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../index.dart';

final appPreferencesProvider = Provider((ref) => getIt.get<AppPreferences>());

@LazySingleton()
class AppPreferences with LogMixin {
  AppPreferences(this._sharedPreference)
      : _encryptedSharedPreferences = EncryptedSharedPreferences(prefs: _sharedPreference),
        _secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  final SharedPreferences _sharedPreference;
  final EncryptedSharedPreferences _encryptedSharedPreferences;
  final FlutterSecureStorage _secureStorage;

  // keys should be removed when logout
  static const keyAccessToken = 'accessToken';
  static const keyRefreshToken = 'refreshToken';
  static const keyUserId = 'userId';
  static const keyEmail = 'email';
  static const keyPassword = 'password';
  static const keyDeviceToken = 'deviceToken';
  static const keyIsLoggedIn = 'isLoggedIn';

  // keys should not be removed when logout
  static const keyIsDarkMode = 'isDarkMode';
  static const keyLanguageCode = 'languageCode';
  static const keyNickName = 'nickName';

  static const appLanguageCodeKey = 'appLanguageCode';

  Future<bool> saveIsDarkMode(bool isDarkMode) {
    return _sharedPreference.setBool(keyIsDarkMode, isDarkMode);
  }

  bool get isDarkMode {
    return _sharedPreference.getBool(keyIsDarkMode) ?? false;
  }

  Future<bool> saveLanguageCode(String languageCode) {
    return _sharedPreference.setString(keyLanguageCode, languageCode);
  }

  String get languageCode =>
      _sharedPreference.getString(keyLanguageCode) ?? LanguageCode.defaultValue.localeCode;

  Future<bool> saveDeviceToken(String token) {
    return _sharedPreference.setString(keyDeviceToken, token);
  }

  String get deviceToken {
    return _sharedPreference.getString(keyDeviceToken) ?? '';
  }

  Future<void> saveAccessToken(String token) async {
    await _encryptedSharedPreferences.setString(
      keyAccessToken,
      token,
    );
  }

  Future<String> get accessToken {
    return _encryptedSharedPreferences.getString(keyAccessToken);
  }

  Future<void> saveIsLoggedIn(bool isLoggedIn) async {
    await _sharedPreference.setBool(keyIsLoggedIn, isLoggedIn);
  }

  bool get isLoggedIn {
    return _sharedPreference.getBool(keyIsLoggedIn) ?? false;
  }

  Future<void> saveRefreshToken(String token) async {
    await _encryptedSharedPreferences.setString(
      keyRefreshToken,
      token,
    );
  }

  Future<String> get refreshToken {
    return _encryptedSharedPreferences.getString(keyRefreshToken);
  }

  Future<bool> saveUserId(String userId) {
    return _sharedPreference.setString(keyUserId, userId);
  }

  String get userId {
    return _sharedPreference.getString(keyUserId) ?? '';
  }

  Future<bool> saveEmail(String email) {
    return _sharedPreference.setString(keyEmail, email);
  }

  String get email {
    return _sharedPreference.getString(keyEmail) ?? '';
  }

  Future<void> savePassword(String password) {
    return _secureStorage.write(
      key: keyPassword,
      value: password,
    );
  }

  Future<String?> get password async {
    return _secureStorage.read(key: keyPassword);
  }

  Future<bool> saveUserNickname({
    required String conversationId,
    required String memberId,
    required String nickname,
  }) {
    final key = '$keyNickName/$userId/$conversationId/$memberId';

    return _sharedPreference.setString(key, nickname.trim());
  }

  String? getUserNickname({
    required String conversationId,
    required String memberId,
  }) {
    final key = '$keyNickName/$userId/$conversationId/$memberId';

    return _sharedPreference.getString(key);
  }

  Future<void> clearCurrentUserData() async {
    await Future.wait(
      [
        _sharedPreference.remove(keyAccessToken),
        _sharedPreference.remove(keyRefreshToken),
        _sharedPreference.remove(keyDeviceToken),
        _sharedPreference.remove(keyUserId),
        _sharedPreference.remove(keyEmail),
        _sharedPreference.remove(keyPassword),
        _sharedPreference.remove(keyIsLoggedIn),
      ],
    );
  }
}
