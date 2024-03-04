import 'package:flutter_test/flutter_test.dart';
import 'package:nalsflutter/index.dart';

void main() {
  group('NullableListExtensions', () {
    group('isNullOrEmpty', () {
      test('when list is null', () {
        List<int>? list;
        final result = list.isNullOrEmpty;
        expect(result, isTrue);
      });

      test('when list is empty', () {
        final list = <int>[];
        final result = list.isNullOrEmpty;
        expect(result, isTrue);
      });

      test('when list is not empty and list is nullable', () {
        final list = <int?>[1, 2, null, 3];
        final result = list.isNullOrEmpty;
        expect(result, isFalse);
      });

      test('when list is not empty and list is not nullable', () {
        final list = <int>[1, 2, 3];
        final result = list.isNullOrEmpty;
        expect(result, isFalse);
      });
    });
  });

  group('ListExtensions', () {
    group('appendOrExceptElement', () {
      test('when list is empty', () {
        final list = <int>[];
        final result = list.appendOrExceptElement(1);
        expect(result, [1]);
      });

      test('when list contains item', () {
        final list = <int>[1, 2, 3];
        final result = list.appendOrExceptElement(2);
        expect(result, [1, 3]);
      });

      test('when list does not contain item', () {
        final list = <int>[1, 2, 3];
        final result = list.appendOrExceptElement(4);
        expect(result, [1, 2, 3, 4]);
      });
    });

    group('plus', () {
      test('when list is empty', () {
        final list = <int>[];
        final result = list.plus(1);
        expect(result, [1]);
      });

      test('when list is not empty', () {
        final list = <int>[1, 2, 3];
        final result = list.plus(4);
        expect(result, [1, 2, 3, 4]);
      });
    });

    group('minus', () {
      test('when list is empty', () {
        final list = <int>[];
        final result = list.minus(1);
        expect(result, []);
      });

      test('when list contains item', () {
        final list = <int>[1, 2, 3];
        final result = list.minus(2);
        expect(result, [1, 3]);
      });

      test('when list does not contain item', () {
        final list = <int>[1, 2, 3];
        final result = list.minus(4);
        expect(result, [1, 2, 3]);
      });
    });

    group('plusAll', () {
      test('when elements is empty', () {
        final list = <int>[1, 2, 3];
        final result = list.plusAll([]);
        expect(result, [1, 2, 3]);
      });

      test('when elements is not empty', () {
        final list = <int>[1, 2, 3];
        final result = list.plusAll([2, 3, 4]);
        expect(result, [1, 2, 3, 2, 3, 4]);
      });
    });

    group('minusAll', () {
      test('when list is empty', () {
        final list = <int>[];
        final result = list.minusAll([1, 2, 3]);
        expect(result, []);
      });

      test('when list contains all items', () {
        final list = <int>[1, 2, 3, 4, 5, 6];
        final result = list.minusAll([4, 5, 6]);
        expect(result, [1, 2, 3]);
      });

      test('when list does not contain any items', () {
        final list = <int>[1, 2, 3];
        final result = list.minusAll([4, 5, 6]);
        expect(result, [1, 2, 3]);
      });

      test('when list contains some items', () {
        final list = <int>[1, 2, 3, 4, 5, 6];
        final result = list.minusAll([4, 5, 7]);
        expect(result, [1, 2, 3, 6]);
      });
    });
  });

  group('SetExtensions', () {
    group('appendOrExceptElement', () {
      test('when set is empty', () {
        final set = <int>{};
        final result = set.appendOrExceptElement(1);
        expect(result, {1});
      });

      test('when set contains item', () {
        final set = {1, 2, 3};
        final result = set.appendOrExceptElement(2);
        expect(result, {1, 3});
      });

      test('when set does not contain item', () {
        final set = {1, 2, 3};
        final result = set.appendOrExceptElement(4);
        expect(result, {1, 2, 3, 4});
      });
    });

    group('plus', () {
      test('when set is empty', () {
        final set = <int>{};
        final result = set.plus(1);
        expect(result, {1});
      });

      test('when set is not empty', () {
        final set = {1, 2, 3};
        final result = set.plus(4);
        expect(result, {1, 2, 3, 4});
      });
    });

    group('minus', () {
      test('when set is empty', () {
        final set = <int>{};
        final result = set.minus(1);
        expect(result, <int>{});
      });

      test('when set contains item', () {
        final set = {1, 2, 3};
        final result = set.minus(2);
        expect(result, {1, 3});
      });

      test('when set does not contain item', () {
        final set = {1, 2, 3};
        final result = set.minus(4);
        expect(result, {1, 2, 3});
      });
    });

    group('plusAll', () {
      test('when elements is empty', () {
        final set = <int>{1, 2, 3};
        final result = set.plusAll([]);
        expect(result, {1, 2, 3});
      });

      test('when set contains some items', () {
        final set = {1, 2, 3};
        final result = set.plusAll([3, 4, 5]);
        expect(result, {1, 2, 3, 4, 5});
      });

      test('when set contains all items', () {
        final set = {1, 2, 3};
        final result = set.plusAll([1, 2, 3]);
        expect(result, {1, 2, 3});
      });

      test('when set does not contain any items', () {
        final set = {1, 2, 3};
        final result = set.plusAll([4, 5]);
        expect(result, {1, 2, 3, 4, 5});
      });
    });

    group('minusAll', () {
      test('when set is empty', () {
        final set = <int>{};
        final result = set.minusAll([1, 2, 3]);
        expect(result, <int>{});
      });

      test('when set contains all items', () {
        final set = {1, 2, 3, 4, 5, 6};
        final result = set.minusAll([4, 5, 6]);
        expect(result, {1, 2, 3});
      });

      test('when set does not contain any items', () {
        final set = {1, 2, 3};
        final result = set.minusAll([4, 5, 6]);
        expect(result, {1, 2, 3});
      });

      test('when set contains some items', () {
        final set = {1, 2, 3, 4, 5, 6};
        final result = set.minusAll([4, 5, 5, 7]);
        expect(result, {1, 2, 3, 6});
      });
    });
  });

  group('NullableMapExtensions', () {
    group('isNullOrEmpty', () {
      test('when map is null', () {
        Map<int, int>? map;
        final result = map.isNullOrEmpty;
        expect(result, isTrue);
      });

      test('when map is empty', () {
        final map = <int, int>{};
        final result = map.isNullOrEmpty;
        expect(result, isTrue);
      });

      test('when map is not empty and map is nullable', () {
        final map = <int, int?>{1: 1, 2: null, 3: 3};
        final result = map.isNullOrEmpty;
        expect(result, isFalse);
      });

      test('when map is not empty and map is not nullable', () {
        final map = <int, int>{1: 1, 2: 2, 3: 3};
        final result = map.isNullOrEmpty;
        expect(result, isFalse);
      });
    });
  });

  group('MapExtensions', () {
    group('plus', () {
      test('when map is empty', () {
        final map = <int, int>{};
        final result = map.plus(key: 1, value: 1);
        expect(result, {1: 1});
      });

      test('when map is not empty', () {
        final map = <int, int>{1: 1, 2: 2, 3: 3};
        final result = map.plus(key: 2, value: 4);
        expect(result, {1: 1, 2: 4, 3: 3});
      });
    });

    group('minus', () {
      test('when map is empty', () {
        final map = <int, int>{};
        final result = map.minus(1);
        expect(result, {});
      });

      test('when map contains key', () {
        final map = <int, int>{1: 1, 2: 2, 3: 3};
        final result = map.minus(2);
        expect(result, {1: 1, 3: 3});
      });

      test('when map does not contain key', () {
        final map = <int, int>{1: 1, 2: 2, 3: 3};
        final result = map.minus(4);
        expect(result, {1: 1, 2: 2, 3: 3});
      });
    });

    group('plusAll', () {
      test('when map is empty', () {
        final map = <int, int>{};
        final result = map.plusAll({1: 1, 2: 2, 3: 3});
        expect(result, {1: 1, 2: 2, 3: 3});
      });

      test('when map is not empty', () {
        final map = <int, int>{1: 1, 2: 2, 3: 3};
        final result = map.plusAll({4: 4, 5: 5, 6: 6});
        expect(result, {1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6});
      });

      test('when map contains some keys', () {
        final map = <int, int>{1: 1, 2: 2, 3: 3};
        final result = map.plusAll({3: 3, 4: 4, 5: 5});
        expect(result, {1: 1, 2: 2, 3: 3, 4: 4, 5: 5});
      });

      test('when map contains all keys', () {
        final map = <int, int>{1: 1, 2: 2, 3: 3};
        final result = map.plusAll({1: 1, 2: 2, 3: 3});
        expect(result, {1: 1, 2: 2, 3: 3});
      });

      test('when map does not contain any keys', () {
        final map = <int, int>{1: 1, 2: 2, 3: 3};
        final result = map.plusAll({4: 4, 5: 5, 6: 6});
        expect(result, {1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6});
      });
    });

    group('minusAll', () {
      test('when map is empty', () {
        final map = <int, int>{};
        final result = map.minusAll({1: 1, 2: 2, 3: 3});
        expect(result, {});
      });

      test('when map contains all keys', () {
        final map = <int, int>{1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6};
        final result = map.minusAll({4: 4, 5: 5, 6: 6});
        expect(result, {1: 1, 2: 2, 3: 3});
      });

      test('when map does not contain any keys', () {
        final map = <int, int>{1: 1, 2: 2, 3: 3};
        final result = map.minusAll({4: 4, 5: 5, 6: 6});
        expect(result, {1: 1, 2: 2, 3: 3});
      });

      test('when map contains some keys', () {
        final map = <int, int>{1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6};
        final result = map.minusAll({4: 4, 5: 5, 7: 7});
        expect(result, {1: 1, 2: 2, 3: 3, 6: 6});
      });
    });
  });

  group('NumExtensions', () {
    group('plus', () {
      test('when num is 1 and other is 2', () {
        const num number = 1;
        final result = number.plus(2);
        expect(result, 3);
      });
    });

    group('minus', () {
      test('when num is 3 and other is 2', () {
        const num number = 3;
        final result = number.minus(2);
        expect(result, 1);
      });
    });

    group('times', () {
      test('when num is 3 and other is 2', () {
        const num number = 3;
        final result = number.times(2);
        expect(result, 6);
      });
    });

    group('div', () {
      test('when num is 6 and other is 2', () {
        const num number = 6;
        final result = number.div(2);
        expect(result, 3);
      });
    });
  });

  group('IntExtensions', () {
    group('plus', () {
      test('when int is 1 and other is 2', () {
        const int number = 1;
        final result = number.plus(2);
        expect(result, 3);
      });
    });

    group('minus', () {
      test('when int is 3 and other is 2', () {
        const int number = 3;
        final result = number.minus(2);
        expect(result, 1);
      });
    });

    group('times', () {
      test('when int is 3 and other is 2', () {
        const int number = 3;
        final result = number.times(2);
        expect(result, 6);
      });
    });

    group('div', () {
      test('when int is 6 and other is 2', () {
        const int number = 6;
        final result = number.div(2);
        expect(result, 3);
      });
    });

    group('truncateDiv', () {
      test('when int is 6 and other is 2', () {
        const int number = 6;
        final result = number.truncateDiv(2);
        expect(result, 3);
      });
    });
  });

  group('DoubleExtensions', () {
    group('plus', () {
      test('when double is 1 and other is 2', () {
        const double number = 1;
        final result = number.plus(2);
        expect(result, 3);
      });
    });

    group('minus', () {
      test('when double is 3 and other is 2', () {
        const double number = 3;
        final result = number.minus(2);
        expect(result, 1);
      });
    });

    group('times', () {
      test('when double is 3 and other is 2', () {
        const double number = 3;
        final result = number.times(2);
        expect(result, 6);
      });
    });

    group('div', () {
      test('when double is 6 and other is 2', () {
        const double number = 6;
        final result = number.div(2);
        expect(result, 3);
      });
    });
  });

  group('StringExtensions', () {
    group('plus', () {
      test('when string is "1" and other is "2"', () {
        const String string = '1';
        final result = string.plus('2');
        expect(result, '12');
      });

      test('when string is "ab" and other is empty', () {
        const String string = 'ab';
        final result = string.plus('');
        expect(result, 'ab');
      });

      test('when string is empty and other is "abc"', () {
        const String string = '';
        final result = string.plus('abc');
        expect(result, 'abc');
      });

      test('when string is null and other is "abc"', () {
        const String? string = null;
        final result = string?.plus('abc');
        expect(result, null);
      });
    });

    group('firstOrNull', () {
      test('when string is empty', () {
        const String string = '';
        final result = string.firstOrNull;
        expect(result, null);
      });

      test('when string is not empty', () {
        const String string = 'abc';
        final result = string.firstOrNull;
        expect(result, 'a');
      });
    });

    group('equalsIgnoreCase', () {
      test('when string is "abc" and other is "ABC"', () {
        const String string = 'abc';
        final result = string.equalsIgnoreCase('ABC');
        expect(result, true);
      });

      test('when string is "abc" and other is "ABCD"', () {
        const String string = 'abc';
        final result = string.equalsIgnoreCase('ABCD');
        expect(result, false);
      });

      test('when string is "abc" and other is "abc"', () {
        const String string = 'abc';
        final result = string.equalsIgnoreCase('abc');
        expect(result, true);
      });

      test('when string is "abc" and other is "abcd"', () {
        const String string = 'abc';
        final result = string.equalsIgnoreCase('abcd');
        expect(result, false);
      });
    });

    group('containsIgnoreCase', () {
      test('when string is "abcd" and other is "ABC"', () {
        const String string = 'abcd';
        final result = string.containsIgnoreCase('ABC');
        expect(result, true);
      });

      test('when string is "abc" and other is "ABCD"', () {
        const String string = 'abc';
        final result = string.containsIgnoreCase('ABCD');
        expect(result, false);
      });

      test('when string is "abc" and other is "abc"', () {
        const String string = 'abc';
        final result = string.containsIgnoreCase('abc');
        expect(result, true);
      });

      test('when string is "abcde" and other is "abcd"', () {
        const String string = 'abc';
        final result = string.containsIgnoreCase('abcd');
        expect(result, false);
      });

      test('when string is "abcd" and other is "aBc"', () {
        const String string = 'abcd';
        final result = string.containsIgnoreCase('aBc');
        expect(result, true);
      });

      test('when string is "ABCD" and other is "bc"', () {
        const String string = 'ABCD';
        final result = string.containsIgnoreCase('bc');
        expect(result, true);
      });
    });

    group('replaceLast', () {
      test('when string is "abcd" and pattern is "c" and replacement is "e"', () {
        const String string = 'abcd';
        final result = string.replaceLast(pattern: 'c', replacement: 'e');
        expect(result, 'abed');
      });

      test('when string is "abcd" and pattern is "e" and replacement is "f"', () {
        const String string = 'abcd';
        final result = string.replaceLast(pattern: 'e', replacement: 'f');
        expect(result, 'abcd');
      });

      test('when string is "abcd" and pattern is "a" and replacement is "f"', () {
        const String string = 'abcd';
        final result = string.replaceLast(pattern: 'a', replacement: 'f');
        expect(result, 'fbcd');
      });

      test('when string is "abcd" and pattern is "d" and replacement is "f"', () {
        const String string = 'abcd';
        final result = string.replaceLast(pattern: 'd', replacement: 'f');
        expect(result, 'abcf');
      });

      test('when string is "abcd" and pattern is "abcd" and replacement is "f"', () {
        const String string = 'abcd';
        final result = string.replaceLast(pattern: 'abcd', replacement: 'f');
        expect(result, 'f');
      });

      test('when string is "abcd" and pattern is "bc" and replacement is "f"', () {
        const String string = 'abcd';
        final result = string.replaceLast(pattern: 'bc', replacement: 'f');
        expect(result, 'afd');
      });

      test('when string is "abcdabcd" and pattern is "bc" and replacement is "f"', () {
        const String string = 'abcdabcd';
        final result = string.replaceLast(pattern: 'bc', replacement: 'f');
        expect(result, 'abcdafd');
      });

      test('when string is "aaaabbbcc" and pattern is "b" and replacement is "fgh"', () {
        const String string = 'aaaabbbcc';
        final result = string.replaceLast(pattern: 'b', replacement: 'fgh');
        expect(result, 'aaaabbfghcc');
      });
    });
  });
}
