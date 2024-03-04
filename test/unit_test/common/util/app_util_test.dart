import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('formatPrice', () {
    test('when price is 1000', () {
      final formattedPrice = AppUtil.formatPrice(1000);

      expect(formattedPrice, equals('￥1,000'));
    });

    test('when price is 1000000', () {
      final formattedPrice = AppUtil.formatPrice(1000000);

      expect(formattedPrice, equals('￥1,000,000'));
    });

    test('when price is 0', () {
      final formattedPrice = AppUtil.formatPrice(0);

      expect(formattedPrice, equals('￥0'));
    });

    test('when price is 100', () {
      final formattedPrice = AppUtil.formatPrice(100);

      expect(formattedPrice, equals('￥100'));
    });

    test('when price is -1', () {
      final formattedPrice = AppUtil.formatPrice(-1);

      expect(formattedPrice, equals('-￥1'));
    });

    test('when price is 1234.12', () {
      final formattedPrice = AppUtil.formatPrice(1234.12);

      expect(formattedPrice, equals('￥1,234'));
    });

    test('when price is -01234.56789', () {
      final formattedPrice = AppUtil.formatPrice(-1234.56789);

      expect(formattedPrice, equals('-￥1,235'));
    });
  });

  group('formatNumber', () {
    test('when number is 1000', () {
      final formattedNumber = AppUtil.formatNumber(1000);

      expect(formattedNumber, equals('1,000'));
    });

    test('when number is 1000000', () {
      final formattedNumber = AppUtil.formatNumber(1000000);

      expect(formattedNumber, equals('1,000,000'));
    });

    test('when number is 0', () {
      final formattedNumber = AppUtil.formatNumber(0);

      expect(formattedNumber, equals('0'));
    });

    test('when number is 100', () {
      final formattedNumber = AppUtil.formatNumber(100);

      expect(formattedNumber, equals('100'));
    });

    test('when number is -1', () {
      final formattedNumber = AppUtil.formatNumber(-1);

      expect(formattedNumber, equals('-1'));
    });

    test('when number is -12345', () {
      final formattedNumber = AppUtil.formatNumber(-12345);

      expect(formattedNumber, equals('-12,345'));
    });
  });

  group('isValidPassword', () {
    test('when password lenth = 6', () {
      final isValid = AppUtil.isValidPassword('123456');

      expect(isValid, equals(true));
    });

    test('when password length = 5', () {
      final isValid = AppUtil.isValidPassword('12345');

      expect(isValid, equals(false));
    });

    test('when password contains whitespace', () {
      final isValid = AppUtil.isValidPassword('123 45');

      expect(isValid, equals(false));
    });
  });

  group('isValidEmail', () {
    test('when email is duynn@gmail.com', () {
      final isValid = AppUtil.isValidEmail('duynn@gmail.com');

      expect(isValid, equals(true));
    });

    test('when email is duynn@gmail.com.vn', () {
      final isValid = AppUtil.isValidEmail('duynn@gmail.com.vn');

      expect(isValid, equals(true));
    });

    test('when email contains whitespace at the beginning', () {
      final isValid = AppUtil.isValidEmail('  duynn@gmail.com');

      expect(isValid, equals(true));
    });

    test('when email contains whitespace at the end', () {
      final isValid = AppUtil.isValidEmail('duynn@gmail.com  ');

      expect(isValid, equals(true));
    });

    test('when email contains whitespace', () {
      final isValid = AppUtil.isValidEmail('duynn @gmail.com');

      expect(isValid, equals(false));
    });

    test('when email does not contain @', () {
      final isValid = AppUtil.isValidEmail('duynngmail.com');

      expect(isValid, equals(false));
    });

    test('when email does not contain .', () {
      final isValid = AppUtil.isValidEmail('duynn@gmailcom');

      expect(isValid, equals(false));
    });

    test('when email contains invalid characters', () {
      final isValid = AppUtil.isValidEmail('!duynn@gmail.com');

      expect(isValid, equals(false));
    });
  });
}
