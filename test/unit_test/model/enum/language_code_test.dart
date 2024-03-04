import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('fromValue', () {
    test('when data is en', () async {
      final result = LanguageCode.fromValue(Constant.en);
      expect(result, LanguageCode.en);
    });

    test('when data is ja', () async {
      final result = LanguageCode.fromValue(Constant.ja);
      expect(result, LanguageCode.ja);
    });

    test('when data is invalid', () async {
      final result = LanguageCode.fromValue('invalid');
      expect(result, LanguageCode.defaultValue);
    });
  });
}
