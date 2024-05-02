import 'package:dartx/dartx.dart';

extension NullableListExtensions<T> on List<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension ListExtensions<T> on List<T> {
  List<T> appendOrExceptElement(T item) {
    return contains(item)
        ? exceptElement(item).toList(growable: false)
        : appendElement(item).toList(growable: false);
  }

  List<T> plus(T element) {
    return appendElement(element).toList(growable: false);
  }

  List<T> minus(T element) {
    return exceptElement(element).toList(growable: false);
  }

  List<T> plusAll(List<T> elements) {
    return append(elements).toList(growable: false);
  }

  List<T> minusAll(List<T> elements) {
    return except(elements).toList(growable: false);
  }
}

extension SetExtensions<T> on Set<T> {
  Set<T> appendOrExceptElement(T item) {
    return contains(item) ? exceptElement(item).toSet() : appendElement(item).toSet();
  }

  Set<T> plus(T element) {
    return appendElement(element).toSet();
  }

  Set<T> minus(T element) {
    return exceptElement(element).toSet();
  }

  Set<T> plusAll(List<T> elements) {
    return append(elements).toSet();
  }

  Set<T> minusAll(List<T> elements) {
    return except(elements).toSet();
  }
}

extension NullableMapExtensions<K, V> on Map<K, V>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension MapExtensions<K, V> on Map<K, V> {
  Map<K, V> plus({
    required K key,
    required V value,
  }) {
    return <K, V>{...this, key: value};
  }

  Map<K, V> minus(K key) {
    return <K, V>{...this..remove(key)};
  }

  Map<K, V> plusAll(Map<K, V> map) {
    return <K, V>{...this, ...map};
  }

  Map<K, V> minusAll(Map<K, V> map) {
    return filterKeys((key) => !map.containsKey(key));
  }
}

extension NumExtensions on num {
  num plus(num other) {
    return this + other;
  }

  num minus(num other) {
    return this - other;
  }

  num times(num other) {
    return this * other;
  }

  num div(num other) {
    return this / other;
  }
}

extension IntExtensions on int {
  int plus(int other) {
    return this + other;
  }

  int minus(int other) {
    return this - other;
  }

  int times(int other) {
    return this * other;
  }

  double div(int other) {
    return this / other;
  }

  int truncateDiv(int other) {
    return this ~/ other;
  }
}

extension DoubleExtensions on double {
  double plus(double other) {
    return this + other;
  }

  double minus(double other) {
    return this - other;
  }

  double times(double other) {
    return this * other;
  }

  double div(double other) {
    return this / other;
  }
}

extension StringExtensions on String {
  String plus(String other) {
    return this + other;
  }

  String? get firstOrNull => isNotEmpty ? this[0] : null;

  bool equalsIgnoreCase(String secondString) => toLowerCase().contains(secondString.toLowerCase());

  bool containsIgnoreCase(String secondString) =>
      toLowerCase().contains(secondString.toLowerCase());

  String replaceLast({
    required Pattern pattern,
    required String replacement,
  }) {
    final match = pattern.allMatches(this).lastOrNull;
    if (match == null) {
      return this;
    }
    final prefix = substring(0, match.start);
    final suffix = substring(match.end);

    return '$prefix$replacement$suffix';
  }

  String get hardcoded => this;
}
