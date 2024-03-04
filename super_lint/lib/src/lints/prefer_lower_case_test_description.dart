import 'package:collection/collection.dart';

import '../index.dart';

const _testFunctionArgCount = 2;
const _regex = r'[A-Z]';

class PreferLowerCaseTestDescription
    extends OptionsLintRule<_PreferLowerCaseTestDescriptionOption> {
  PreferLowerCaseTestDescription(
    CustomLintConfigs configs,
  ) : super(
          RuleConfig(
              name: lintName,
              configs: configs,
              paramsParser: _PreferLowerCaseTestDescriptionOption.fromMap,
              problemMessage: (_) =>
                  'Lower case the first character when writing tests descriptions.'),
        );

  static const String lintName = 'prefer_lower_case_test_description';

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

    context.registry.addMethodInvocation((node) {
      final testMethod = parameters.testMethods.firstWhereOrNull((element) {
        final methodName = element[_PreferLowerCaseTestDescriptionOption.keyMethodName];
        return node.methodName.name == methodName;
      });

      if (testMethod == null) {
        return;
      }

      final descriptionParamName = testMethod[_PreferLowerCaseTestDescriptionOption.keyParamName];

      if (node.argumentList.arguments.length >= _testFunctionArgCount) {
        final firstArgument = node.argumentList.arguments[0];
        if (firstArgument is StringLiteral &&
            firstArgument.stringValue?.isNotEmpty == true &&
            firstArgument.staticParameterElement?.name == descriptionParamName) {
          final firstCharacter = firstArgument.stringValue?[0];
          if (RegExp(_regex).hasMatch(firstCharacter ?? '')) {
            reporter.reportErrorForNode(code, firstArgument);
          }
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        _ChangeToLowerCase(config),
      ];
}

class _ChangeToLowerCase extends OptionsFix<_PreferLowerCaseTestDescriptionOption> {
  _ChangeToLowerCase(super.config);

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) async {
    context.registry.addMethodInvocation((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange) ||
          node.argumentList.arguments.length < _testFunctionArgCount) {
        return;
      }

      final testMethod = config.parameters.testMethods.firstWhereOrNull((element) {
        final methodName = element[_PreferLowerCaseTestDescriptionOption.keyMethodName];
        return node.methodName.name == methodName;
      });

      if (testMethod == null) {
        return;
      }

      final descriptionParamName = testMethod[_PreferLowerCaseTestDescriptionOption.keyParamName];

      final firstArgument = node.argumentList.arguments[0];
      if (firstArgument is StringLiteral &&
          firstArgument.stringValue?.isNotEmpty == true &&
          firstArgument.staticParameterElement?.name == descriptionParamName) {
        final firstCharacter = firstArgument.stringValue?[0];
        if (RegExp(_regex).hasMatch(firstCharacter ?? '')) {
          final changeBuilder = reporter.createChangeBuilder(
            message: 'Lower case the first character',
            priority: 1709,
          );

          changeBuilder.addDartFileEdit((builder) {
            builder.addSimpleReplacement(
              firstArgument.sourceRange,
              '\'${firstCharacter?.toLowerCase()}${firstArgument.stringValue?.substring(1)}\'',
            );
          });
        }
      }
    });
  }
}

class _PreferLowerCaseTestDescriptionOption extends Excludable {
  const _PreferLowerCaseTestDescriptionOption({
    this.excludes = const [],
    this.includes = const [],
    this.severity,
    this.testMethods = _defaultTestMethods,
  });

  final ErrorSeverity? severity;
  @override
  final List<String> excludes;
  @override
  final List<String> includes;

  final List<Map<String, String>> testMethods;

  static _PreferLowerCaseTestDescriptionOption fromMap(Map<String, dynamic> map) {
    return _PreferLowerCaseTestDescriptionOption(
      excludes: safeCastToListString(map['excludes']),
      includes: safeCastToListString(map['includes']),
      severity: convertStringToErrorSeverity(map['severity']),
      testMethods: safeCastToListJson(map['test_methods'], defaultValue: _defaultTestMethods),
    );
  }

  static const _defaultTestMethods = [
    {
      keyMethodName: 'test',
      keyParamName: 'description',
    },
    {
      keyMethodName: 'stateNotifierTest',
      keyParamName: 'description',
    },
    {
      keyMethodName: 'testWidgets',
      keyParamName: 'description',
    },
    {
      keyMethodName: 'testGoldens',
      keyParamName: 'description',
    }
  ];

  static const keyMethodName = 'method_name';
  static const keyParamName = 'param_name';
}
