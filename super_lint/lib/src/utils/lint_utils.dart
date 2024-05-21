import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

import '../index.dart';

/// Determines whether the file should be skipped using Glob patterns
///
/// There are three modes:
/// 1. Include only - only files matching [includeGlobs] will be
///    included
/// 2. Exclude only - all files will be included except those
///    matching [excludeGlobs]
/// 3. Include and exclude - only files matching [includeGlobs]
///    and not matching [excludeGlobs] will be included
///
/// See https://pub.dev/packages/glob
bool shouldSkipFile({
  required List<String> includeGlobs,
  required List<String> excludeGlobs,
  required String path,
  String? rootPath,
}) {
  final relative = relativePath(path, rootPath);
  final shouldAnalyzeFile = (includeGlobs.isEmpty || _matchesAnyGlob(includeGlobs, relative)) &&
      (excludeGlobs.isEmpty || _doesNotMatchGlobs(excludeGlobs, relative));
  return !shouldAnalyzeFile;
}

bool _matchesAnyGlob(List<String> globsList, String path) {
  final hasMatch = globsList.map(Glob.new).toList().any((glob) => glob.matches(path));
  return hasMatch;
}

bool _doesNotMatchGlobs(List<String> globList, String path) {
  return !_matchesAnyGlob(globList, path);
}

/// Converts path to relative using posix style and
/// replaces backslashes with forward slashes
String relativePath(String path, [String? root]) {
  final uriNormlizedPath = p.toUri(path).normalizePath().path;
  final uriNormlizedRoot = root != null ? p.toUri(root).normalizePath().path : null;

  final relative = p.posix.relative(uriNormlizedPath, from: uriNormlizedRoot);
  return relative;
}

String getFileNameFromPath(String path) {
  final uri = p.toUri(path);
  final uriNormlizedPath = uri.normalizePath().path;
  final fileName = p.basenameWithoutExtension(uriNormlizedPath);
  return fileName;
}

String convertSnakeCaseToPascalCase(String snakeCase) {
  final words = snakeCase.split('_');
  final pascalCase = words.map((word) => word[0].toUpperCase() + word.substring(1)).join('');
  return pascalCase;
}

extension StringExtension on String {
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
}

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
