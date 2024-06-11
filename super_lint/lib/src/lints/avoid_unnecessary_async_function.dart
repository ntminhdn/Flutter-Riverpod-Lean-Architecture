import '../index.dart';

class AvoidUnnecessaryAsyncFunction extends OptionsLintRule<_AvoidUnnecessaryAsyncFunctionOption> {
  AvoidUnnecessaryAsyncFunction(
    CustomLintConfigs configs,
  ) : super(
          RuleConfig(
              name: lintName,
              configs: configs,
              paramsParser: _AvoidUnnecessaryAsyncFunctionOption.fromMap,
              problemMessage: (_) =>
                  'This async function is unnecessary. Please remove \'async\' keyword'),
        );

  static const String lintName = 'avoid_unnecessary_async_function';

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

    unawaited(resolver.getResolvedUnitResult().then(
          (value) => value.unit.visitChildren(
            FunctionAndMethodDeclarationVisitor(
              onVisitFunctionDeclaration: (node) {
                if (node.functionExpression.body.isAsynchronous &&
                    node.functionExpression.body.childAwaitExpressions.isEmpty &&
                    !node.childReturnStatements.any((element) =>
                        element.expression?.staticType.toString().startsWith('Future') == true)) {
                  if (node.functionExpression.body.keyword != null) {
                    reporter.atToken(node.functionExpression.body.keyword!, code);
                  } else {
                    reporter.atNode(node, code);
                  }
                }
              },
              onVisitMethodDeclaration: (node) {
                if (node.body.isAsynchronous &&
                    !node.isOverrideMethod &&
                    node.body.childAwaitExpressions.isEmpty &&
                    !node.childReturnStatements.any((element) =>
                        element.expression?.staticType.toString().startsWith('Future') == true)) {
                  if (node.body.keyword != null) {
                    reporter.atToken(node.body.keyword!, code);
                  } else {
                    reporter.atNode(node, code);
                  }
                }
              },
            ),
          ),
        ));
  }

  @override
  List<Fix> getFixes() => [
        _RemoveUnnecessaryAsyncKeyWord(config),
      ];
}

class _RemoveUnnecessaryAsyncKeyWord extends OptionsFix<_AvoidUnnecessaryAsyncFunctionOption> {
  _RemoveUnnecessaryAsyncKeyWord(super.config);

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) async {
    unawaited(resolver.getResolvedUnitResult().then(
          (value) => value.unit.visitChildren(
            FunctionAndMethodDeclarationVisitor(
              onVisitFunctionDeclaration: (node) {
                _fix(
                  isArrowFunction: node.functionExpression.toString().contains('=>'),
                  body: node.functionExpression.body,
                  sourceRange: node.sourceRange,
                  analysisError: analysisError,
                  reporter: reporter,
                  returnType: node.returnType,
                );
              },
              onVisitMethodDeclaration: (node) {
                _fix(
                  isArrowFunction: node.toString().contains('=>'),
                  body: node.body,
                  sourceRange: node.sourceRange,
                  analysisError: analysisError,
                  reporter: reporter,
                  returnType: node.returnType,
                );
              },
            ),
          ),
        ));
  }

  void _fix({
    required bool isArrowFunction,
    required FunctionBody body,
    required SourceRange sourceRange,
    required AnalysisError analysisError,
    required ChangeReporter reporter,
    required TypeAnnotation? returnType,
  }) {
    if (!sourceRange.intersects(analysisError.sourceRange)) {
      return;
    }

    final changeBuilder = reporter.createChangeBuilder(
      message: 'Remove unnecessary async keyword',
      priority: 79,
    );

    changeBuilder.addDartFileEdit((builder) {
      builder.addDeletion(analysisError.sourceRange);
      if (returnType != null) {
        final returnTypeIsFuture = returnType.toString().startsWith('Future');
        final isArrowFunctionReturnNonFuture = body
                .safeCast<ExpressionFunctionBody>()
                ?.expression
                .staticType
                .toString()
                .startsWith('Future') !=
            true;

        if ((isArrowFunction && isArrowFunctionReturnNonFuture) ||
            (!isArrowFunction && returnTypeIsFuture)) {
          builder.addSimpleReplacement(
              returnType.sourceRange,
              returnType.toString().replaceFirstMapped(RegExp(r'(Future<|FutureOr<)(.+)>'),
                  (match) {
                return match.group(2) ?? '';
              }));
        }
      }
      builder.formatWithPageWidth(sourceRange);
    });
  }
}

class _AvoidUnnecessaryAsyncFunctionOption extends Excludable {
  const _AvoidUnnecessaryAsyncFunctionOption({
    this.excludes = const [],
    this.includes = const [],
    this.severity,
  });

  final ErrorSeverity? severity;
  @override
  final List<String> excludes;
  @override
  final List<String> includes;

  static _AvoidUnnecessaryAsyncFunctionOption fromMap(Map<String, dynamic> map) {
    return _AvoidUnnecessaryAsyncFunctionOption(
      excludes: safeCastToListString(map['excludes']),
      includes: safeCastToListString(map['includes']),
      severity: convertStringToErrorSeverity(map['severity']),
    );
  }
}
