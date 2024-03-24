import 'package:clock/clock.dart';
import 'package:intl/intl.dart';

import '../../../index.dart';

DateTime get now => clock.now();

DateTime get today => now.withTimeAtStartOfDay();

class DateTimeUtil {
  DateTimeUtil._();

  static int daysBetween({
    required DateTime from,
    required DateTime to,
  }) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return (to.difference(from).inHours / 24).round();
  }

  // VN: 7
  // JP: 9
  // UTC: 0
  static int timezoneOffset() {
    return now.timeZoneOffset.inHours;
  }

  static DateTime utcToLocal(int utcTimestampMillis) {
    return DateTime.fromMillisecondsSinceEpoch(utcTimestampMillis, isUtc: true).toLocal();
  }

  static DateTime localToUtc(int localTimestampMillis) {
    return DateTime.fromMillisecondsSinceEpoch(localTimestampMillis, isUtc: false).toUtc();
  }

// ignore: prefer_named_parameters
  static DateTime? tryParse(
    String? dateTime, {
    bool utc = false,
    String? format,
    String? locale,
  }) {
    if (dateTime == null) {
      return null;
    }

    if (format == null) {
      return DateTime.tryParse(dateTime);
    }

    final DateFormat dateFormat =
        DateFormat(format, locale ?? LanguageCode.defaultValue.localeCode);
    try {
      return dateFormat.parse(dateTime, utc);
    } catch (e) {
      Log.e(e, name: 'DateTimeUtil.tryParse');

      return null;
    }
  }
}

extension DateTimeExtensions on DateTime {
  // ignore: prefer_named_parameters
  String toStringWithFormat(
    String format, {
    String? locale,
  }) {
    return DateFormat(format, locale).format(this);
  }

  DateTime get lastDateOfMonth {
    return DateTime(year, month + 1, 0);
  }

  DateTime withTimeAtStartOfDay() {
    return DateTime(
      year,
      month,
      day,
    );
  }
}
