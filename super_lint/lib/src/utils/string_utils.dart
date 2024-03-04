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
