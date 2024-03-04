import '../index.dart';

T run<T>(T Function() block) {
  return block();
}

extension ObjectUtils<T> on T? {
  R? safeCast<R>() {
    final that = this;
    if (that is R) {
      return that;
    }

    return null;
  }

  R? let<R>(R Function(T)? cb) {
    final that = this;
    if (that == null) {
      return null;
    }

    return cb?.call(that);
  }
}

T? safeCast<T>(dynamic value) {
  if (value is T) {
    return value;
  }

  return null;
}

List<String> safeCastToListString(
  dynamic value, {
  List<String> defaultValue = const [],
}) {
  if (value is List<String>) {
    return value;
  }

  if (value is YamlList) {
    return value.map((element) => element.toString()).toList();
  }

  return defaultValue;
}

List<Map<String, String>> safeCastToListJson(
  dynamic value, {
  List<Map<String, String>> defaultValue = const [],
}) {
  if (value is List<Map<String, String>>) {
    return value;
  }

  if (value is YamlList) {
    return value.map((element) => safeCastToJson(element)).toList();
  }

  return defaultValue;
}

Map<String, String> safeCastToJson(
  dynamic value, {
  Map<String, String> defaultValue = const {},
}) {
  if (value is Map<String, String>) {
    return value;
  }

  if (value is YamlMap) {
    return value.cast<String, String>();
  }

  return defaultValue;
}
