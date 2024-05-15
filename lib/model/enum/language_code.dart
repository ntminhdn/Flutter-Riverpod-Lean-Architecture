import 'package:dartx/dartx.dart';

import '../../index.dart';

enum LanguageCode {
  en(
    localeCode: 'en',
    value: Constant.en,
  ),
  ja(
    localeCode: 'ja',
    value: Constant.ja,
  ),

  ko(
    localeCode: 'ko',
    value: Constant.ko,
  ),
  zh(
    localeCode: 'zh',
    value: Constant.zh,
  );

  const LanguageCode({
    required this.localeCode,
    required this.value,
  });

  factory LanguageCode.fromValue(String? data) {
    return values.firstOrNullWhere((element) => element.value == data) ?? defaultValue;
  }

  final String localeCode;
  final String value;

  static const defaultValue = ja;
}
