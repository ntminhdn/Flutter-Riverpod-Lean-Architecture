import '../index.dart';

class PreferAsyncAwait extends OptionsLintRule<_PreferAsyncAwaitOption> {
  PreferAsyncAwait(
    CustomLintConfigs configs,
  ) : super(
          RuleConfig(
            name: lintName,
            configs: configs,
            paramsParser: _PreferAsyncAwaitOption.fromMap,
            problemMessage: (_) => 'Prefer using async/await syntax instead of .then invocations',
          ),
        );

  static const String lintName = 'prefer_async_await';

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
      final target = node.realTarget;
      if (target == null) return;

      final targetType = target.staticType;
      if (targetType == null || !targetType.isDartAsyncFuture) return;

      final methodName = node.methodName.name;
      if (methodName != 'then') return;

      reporter.atNode(node.methodName, code);
    });
  }
}

class _PreferAsyncAwaitOption extends Excludable {
  const _PreferAsyncAwaitOption({
    this.excludes = const [],
    this.includes = const [],
    this.severity,
  });

  final ErrorSeverity? severity;
  @override
  final List<String> excludes;
  @override
  final List<String> includes;

  static _PreferAsyncAwaitOption fromMap(Map<String, dynamic> map) {
    return _PreferAsyncAwaitOption(
      excludes: safeCastToListString(map['excludes']),
      includes: safeCastToListString(map['includes']),
      severity: convertStringToErrorSeverity(map['severity']),
    );
  }
}
