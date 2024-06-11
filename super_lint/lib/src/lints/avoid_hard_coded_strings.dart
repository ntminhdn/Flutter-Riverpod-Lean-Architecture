import '../index.dart';

class AvoidHardCodedStrings extends OptionsLintRule<_AvoidHardCodedStringsOption> {
  AvoidHardCodedStrings(
    CustomLintConfigs configs,
  ) : super(
          RuleConfig(
            name: lintName,
            configs: configs,
            paramsParser: _AvoidHardCodedStringsOption.fromMap,
            problemMessage: (_) =>
                'Avoid hardcoding strings. Use a localization package or append ".hardcoded" to the string to suppress this message.',
          ),
        );

  static const String lintName = 'avoid_hard_coded_strings';

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

    context.registry.addSimpleStringLiteral((node) {
      if (node.value.length < config.parameters.minimumLength) {
        return;
      }

      if (node.parent?.toSource().startsWith('import') ?? false) {
        return;
      }

      if (node.parent?.toSource().startsWith('export') ?? false) {
        return;
      }

      if (node.parent?.toSource().startsWith('part') ?? false) {
        return;
      }

      if (node.parent?.toSource().endsWith('.hardcoded') ?? false) {
        return;
      }

      if (node.parent?.parent?.parent?.toSource().startsWith('@RoutePage') ?? false) {
        return;
      }

      reporter.atNode(node, code);
    });

    context.registry.addInterpolationString((node) {
      if (node.value.length < config.parameters.minimumLength) {
        return;
      }

      // ignore if ".hardcoded" is appended after the string
      if (node.parent?.parent?.toSource().endsWith('.hardcoded') ?? false) {
        return;
      }
      reporter.atNode(node.parent ?? node, code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _AvoidHardCodedStringsFix(config),
      ];
}

class _AvoidHardCodedStringsFix extends OptionsFix<_AvoidHardCodedStringsOption> {
  _AvoidHardCodedStringsFix(super.config);

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) async {
    context.registry.addSimpleStringLiteral((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Append ".hardcoded"',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(node.end, '.hardcoded');
      });
    });

    context.registry.addInterpolationString((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Append ".hardcoded"',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(node.parent?.end ?? node.end, '.hardcoded');
      });
    });
  }
}

class _AvoidHardCodedStringsOption extends Excludable {
  const _AvoidHardCodedStringsOption({
    this.excludes = const [],
    this.includes = const [],
    this.severity,
    this.minimumLength = _defaultMinimumLength,
  });

  final ErrorSeverity? severity;
  @override
  final List<String> excludes;
  @override
  final List<String> includes;

  final int minimumLength;

  static _AvoidHardCodedStringsOption fromMap(Map<String, dynamic> map) {
    return _AvoidHardCodedStringsOption(
      excludes: safeCastToListString(map['excludes']),
      includes: safeCastToListString(map['includes']),
      severity: convertStringToErrorSeverity(map['severity']),
      minimumLength: safeCast(map['minimum_length']) ?? _defaultMinimumLength,
    );
  }

  static const _defaultMinimumLength = 1;
}
