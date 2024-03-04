import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nalsflutter/index.dart';

void main() {
  setUp(() {
    initializeDateFormatting();
  });

  group('today', () {
    test('hour, minute, and second should be 0', () async {
      withClock(Clock.fixed(DateTime(2024, 1, 2, 3, 4, 5, 6, 7)), () {
        final t = today;
        expect(t, DateTime(2024, 1, 2, 0, 0, 0, 0, 0));
      });
    });
  });

  group('daysBetween', () {
    test('when from < to', () {
      final from = DateTime(2023, 1, 1);
      final to = DateTime(2023, 1, 3);
      const expected = 2;

      final result = DateTimeUtil.daysBetween(from: from, to: to);

      expect(result, expected);
    });

    test('when from = to', () {
      final from = DateTime(2023, 1, 1);
      final to = DateTime(2023, 1, 1);
      const expected = 0;

      final result = DateTimeUtil.daysBetween(from: from, to: to);

      expect(result, expected);
    });

    test('when from > to', () {
      final from = DateTime(2023, 1, 11);
      final to = DateTime(2023, 1, 10);
      const expected = -1;

      final result = DateTimeUtil.daysBetween(from: from, to: to);

      expect(result, expected);
    });

    test('when from and to are the same day but different time', () {
      final from = DateTime(2023, 1, 1, 1, 0, 0);
      final to = DateTime(2023, 1, 1, 23, 59, 59);
      const expected = 0;

      final result = DateTimeUtil.daysBetween(from: from, to: to);

      expect(result, expected);
    });

    test('when from and to are the same day but different time and from > to', () {
      final from = DateTime(2023, 1, 1, 23, 59, 59);
      final to = DateTime(2023, 1, 1, 1, 0, 0);
      const expected = 0;

      final result = DateTimeUtil.daysBetween(from: from, to: to);

      expect(result, expected);
    });

    test('when from < to 1 second and they are not the same day', () {
      final from = DateTime(2023, 1, 1, 23, 59, 59);
      final to = DateTime(2023, 1, 2, 0, 0, 0);
      const expected = 1;

      final result = DateTimeUtil.daysBetween(from: from, to: to);

      expect(result, expected);
    });

    test('when they have different years', () {
      final from = DateTime(2023, 12, 31);
      final to = DateTime(2024, 1, 1);
      const expected = 1;

      final result = DateTimeUtil.daysBetween(from: from, to: to);

      expect(result, expected);
    });

    test('when they have different months', () {
      final from = DateTime(2023, 1, 31);
      final to = DateTime(2023, 2, 1);
      const expected = 1;

      final result = DateTimeUtil.daysBetween(from: from, to: to);

      expect(result, expected);
    });

    test('they are 3 months apart in a non-leap year', () {
      final from = DateTime(2023, 1, 31);
      final to = DateTime(2023, 4, 31);
      const expected = 90;

      final result = DateTimeUtil.daysBetween(from: from, to: to);

      expect(result, expected);
    });

    test('they are 3 months apart in a leap year', () {
      final from = DateTime(2024, 1, 31);
      final to = DateTime(2024, 4, 31);
      const expected = 91;

      final result = DateTimeUtil.daysBetween(from: from, to: to);

      expect(result, expected);
    });

    test('they are 4 years apart', () {
      final from = DateTime(2023, 1, 1);
      final to = DateTime(2027, 1, 1);
      const expected = 365 * 3 + 366;

      final result = DateTimeUtil.daysBetween(from: from, to: to);

      expect(result, expected);
    });
  });

  group('timezoneOffset', () {
    test('when timezone is UTC', () {
      withClock(Clock.fixed(DateTime.utc(2023, 1, 1, 0, 0, 0, 0, 0)), () {
        final result = DateTimeUtil.timezoneOffset();
        expect(result, 0);
      });
    });
  });

  group('utcToLocal', () {
    test('when utcTimestampMillis is 0', () {
      final result = DateTimeUtil.utcToLocal(0);
      expect(
        result,
        isA<DateTime>().having(
          (e) => e.year == 1970 && e.month == 1 && e.day == 1 && e.minute == 0 && e.second == 0,
          'DateTime',
          true,
        ),
      );
    });

    if (DateTimeUtil.timezoneOffset() == 7) {
      test('when timezone is +07:00 and utcDateTime is DateTime(2024, 12, 31, 7, 15, 30)', () {
        final input = DateTime.utc(2024, 12, 31, 7, 15, 30).millisecondsSinceEpoch; // 7h utc
        final expected = DateTime(2024, 12, 31, 14, 15, 30); // = 14h local
        final result = DateTimeUtil.utcToLocal(input);

        expect(
          result,
          expected,
        );
      });
    }

    if (DateTimeUtil.timezoneOffset() == 9) {
      test('when timezone is +09:00 utcDateTime is DateTime(2023, 11, 12, 9, 15, 30)', () {
        final input = DateTime.utc(2023, 11, 12, 9, 15, 30).millisecondsSinceEpoch; // 9h utc
        final expected = DateTime(2023, 11, 12, 18, 15, 30); // = 18h local
        final result = DateTimeUtil.utcToLocal(input);

        expect(
          result,
          expected,
        );
      });
    }
  });

  group('localToUtc', () {
    test('when localTimestampMillis is 0', () {
      final result = DateTimeUtil.localToUtc(0);
      expect(
        result,
        isA<DateTime>().having(
          (e) => e.year == 1970 && e.month == 1 && e.day == 1 && e.minute == 0 && e.second == 0,
          'DateTime',
          true,
        ),
      );
    });

    if (DateTimeUtil.timezoneOffset() == 7) {
      test('when timezone is +07:00 and localDateTime is DateTime(2024, 12, 31, 14, 15, 30)', () {
        final input = DateTime(2024, 12, 31, 14, 15, 30).millisecondsSinceEpoch; // 14h local
        final expected = DateTime.utc(2024, 12, 31, 7, 15, 30); // = 7h utc
        final result = DateTimeUtil.localToUtc(input);

        expect(
          result,
          expected,
        );
      });
    }

    if (DateTimeUtil.timezoneOffset() == 9) {
      test('when timezone is +09:00 and localDateTime is DateTime(2023, 11, 12, 18, 15, 30)', () {
        final input = DateTime(2023, 11, 12, 18, 15, 30).millisecondsSinceEpoch; // 18h local
        final expected = DateTime.utc(2023, 11, 12, 9, 15, 30); // = 9h utc
        final result = DateTimeUtil.localToUtc(input);

        expect(
          result,
          expected,
        );
      });
    }
  });

  group('tryParse', () {
    test('when dateTime is null', () {
      final result = DateTimeUtil.tryParse(null);
      expect(result, null);
    });

    test('when format is null', () {
      final result = DateTimeUtil.tryParse('2023-01-01');
      expect(result, DateTime(2023, 1, 1));
    });

    test('when format is null and dateTime is invalid', () {
      final result = DateTimeUtil.tryParse('');
      expect(result, null);
    });

    test('when format is not null', () {
      final result =
          DateTimeUtil.tryParse('2023--01--01 04:06:08', format: 'yyyy--MM--dd hh:mm:ss');
      expect(result, DateTime(2023, 1, 1, 4, 6, 8));
    });

    test('when format is not null and locale is not null', () {
      final result = DateTimeUtil.tryParse(
        '月, 1月 02, 2023 15:16:17',
        format: 'E, MMM dd, yyyy HH:mm:ss',
        locale: 'ja',
      );
      expect(result, DateTime(2023, 1, 2, 15, 16, 17));
    });

    test('when using wrong locale', () {
      final result = DateTimeUtil.tryParse(
        '月, 1月 02, 2023 15:16:17',
        format: 'E, MMM dd, yyyy HH:mm:ss',
        locale: 'en',
      );
      expect(result, null);
    });

    test(
      'when format is not null and locale is not null and utc is false and dateTime is invalid',
      () {
        final result = DateTimeUtil.tryParse('', format: 'yyyy-MM-dd', locale: 'en', utc: false);
        expect(result, null);
      },
    );
  });

  group('toStringWithFormat', () {
    test('when format is yyyy-MM-dd', () {
      final result = DateTime(2023, 1, 1, 4, 6, 8).toStringWithFormat('yyyy--MM--dd hh:mm:ss');
      expect(result, '2023--01--01 04:06:08');
    });

    test('when format is yyyy-MM-dd and locale is ja', () {
      final result = DateTime(2023, 1, 2, 15, 16, 17)
          .toStringWithFormat('E, MMM dd, yyyy HH:mm:ss', locale: 'ja');
      expect(result, '月, 1月 02, 2023 15:16:17');
    });
  });

  group('lastDateOfMonth', () {
    test('when date is 2023-01-01', () {
      final result = DateTime(2023, 1, 1).lastDateOfMonth;
      expect(result, DateTime(2023, 1, 31));
    });

    test('when date is 2023-02-01', () {
      final result = DateTime(2023, 2, 1).lastDateOfMonth;
      expect(result, DateTime(2023, 2, 28));
    });

    test('when date is 2023-03-01', () {
      final result = DateTime(2023, 3, 1).lastDateOfMonth;
      expect(result, DateTime(2023, 3, 31));
    });

    test('when date is 2023-04-01', () {
      final result = DateTime(2023, 4, 1).lastDateOfMonth;
      expect(result, DateTime(2023, 4, 30));
    });

    test('when date is 2023-05-01', () {
      final result = DateTime(2023, 5, 1).lastDateOfMonth;
      expect(result, DateTime(2023, 5, 31));
    });

    test('when date is 2023-06-01', () {
      final result = DateTime(2023, 6, 1).lastDateOfMonth;
      expect(result, DateTime(2023, 6, 30));
    });

    test('when date is 2023-07-01', () {
      final result = DateTime(2023, 7, 1).lastDateOfMonth;
      expect(result, DateTime(2023, 7, 31));
    });

    test('when date is 2023-08-01', () {
      final result = DateTime(2023, 8, 1).lastDateOfMonth;
      expect(result, DateTime(2023, 8, 31));
    });

    test('when date is 2023-09-01', () {
      final result = DateTime(2023, 9, 1).lastDateOfMonth;
      expect(result, DateTime(2023, 9, 30));
    });

    test('when date is 2023-10-01', () {
      final result = DateTime(2023, 10, 1).lastDateOfMonth;
      expect(result, DateTime(2023, 10, 31));
    });

    test('when date is 2023-11-01', () {
      final result = DateTime(2023, 11, 1).lastDateOfMonth;
      expect(result, DateTime(2023, 11, 30));
    });

    test('when date is 2023-12-01', () {
      final result = DateTime(2023, 12, 1).lastDateOfMonth;
      expect(result, DateTime(2023, 12, 31));
    });
  });

  group('withTimeAtStartOfDay', () {
    test('when date is 2023-01-01 04:06:08', () {
      final result = DateTime(2023, 1, 1, 4, 6, 8).withTimeAtStartOfDay();
      expect(result, DateTime(2023, 1, 1));
    });
  });
}
