import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('safeCast', () {
    test('when using valid data type', () async {
      const dynamic input = 1;
      final result = safeCast<int>(input);

      expect(result, 1);
    });

    test('when using invalid data type', () async {
      const dynamic input = '1';
      final result = safeCast<int>(input);

      expect(result, null);
    });

    test('when using generic data type', () async {
      const dynamic input = [
        [1]
      ];
      final result = safeCast<List<List<int>>>(input);

      expect(result, input);
    });
  });

  group('ObjectExt', () {
    group('safeCast', () {
      test('when using valid data type', () async {
        final result = 1.safeCast<int>();

        expect(result, 1);
      });

      test('when using invalid data type', () async {
        final result = '1'.safeCast<int>();

        expect(result, null);
      });

      test('when using generic data type', () async {
        final input = [
          [1]
        ];
        final result = input.safeCast<List<List<int>>>();

        expect(result, input);
      });
    });

    group('let', () {
      test('when receiver is not null', () async {
        final result = 1.let((it) => it + 1);

        expect(result, 2);
      });

      test('when receiver is null', () async {
        const int? input = null;
        final result = input?.let((it) => it + 1);

        expect(result, null);
      });
    });
  });
}
