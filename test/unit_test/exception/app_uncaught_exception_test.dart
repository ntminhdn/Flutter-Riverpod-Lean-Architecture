import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('message', () {
    test('message', () async {
      expect(AppUncaughtException().message, l10n.unknownException('UE-00'));
    });

    test('action', () async {
      expect(AppUncaughtException().action, AppExceptionAction.doNothing);
    });
  });
}
