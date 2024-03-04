import '../index.dart';

class PreferIsEmptyString extends OptionsLintRule<_PreferIsEmptyStringOption> {
  PreferIsEmptyString(
    CustomLintConfigs configs,
  ) : super(
          RuleConfig(
            name: lintName,
            configs: configs,
            paramsParser: _PreferIsEmptyStringOption.fromMap,
            problemMessage: (_) =>
                'Use \'isEmpty\' instead of \'==\' to test whether the string is empty.\nTry rewriting the expression to use \'isEmpty\'.',
          ),
        );

  static const String lintName = 'prefer_is_empty_string';

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    final rootPath = await resolver.rootPath;
    final parameters = config.parameters;
    if (parameters.shouldSkipAnalysis(
      path: resolver.path,
      rootPath: rootPath,
    )) {
      return;
    }

    final code = this.code.copyWith(
          errorSeverity: parameters.severity ?? this.code.errorSeverity,
        );

    context.registry.addBinaryExpression((node) {
      if (node.operator.type == TokenType.EQ_EQ &&
          (node.leftOperand.toString() == '\'\'' || node.rightOperand.toString() == '\'\'')) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithIsEmpty(config),
      ];
}

class _ReplaceWithIsEmpty extends OptionsFix<_PreferIsEmptyStringOption> {
  _ReplaceWithIsEmpty(super.config);

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) async {
    context.registry.addBinaryExpression((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange) ||
          node.operator.type != TokenType.EQ_EQ ||
          (node.leftOperand.toString() != '\'\'' && node.rightOperand.toString() != '\'\'')) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Replace with \'isEmpty\'',
        priority: 71,
      );

      final variable = node.leftOperand.toString() == '\'\'' ? node.rightOperand : node.leftOperand;

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
            node.sourceRange,
            variable.staticType?.isNullableType == true
                ? '${variable.toString()}?.isEmpty == true'
                : '${variable.toString()}.isEmpty');
      });
    });
  }
}

class _PreferIsEmptyStringOption extends Excludable {
  const _PreferIsEmptyStringOption({
    this.excludes = const [],
    this.includes = const [],
    this.severity,
  });

  final ErrorSeverity? severity;
  @override
  final List<String> excludes;
  @override
  final List<String> includes;

  static _PreferIsEmptyStringOption fromMap(Map<String, dynamic> map) {
    return _PreferIsEmptyStringOption(
      excludes: safeCastToListString(map['excludes']),
      includes: safeCastToListString(map['includes']),
      severity: convertStringToErrorSeverity(map['severity']),
    );
  }
}
