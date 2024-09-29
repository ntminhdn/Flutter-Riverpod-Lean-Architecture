import '../index.dart';

class IncorrectParentClass extends OptionsLintRule<_IncorrectParentClassOption> {
  IncorrectParentClass(
    CustomLintConfigs configs,
  ) : super(
          RuleConfig(
            name: lintName,
            configs: configs,
            paramsParser: _IncorrectParentClassOption.fromMap,
            problemMessage: (options) =>
                'Page classes must extend ${options.parentClassPreFixes.join(' or ')}',
          ),
        );

  static const String lintName = 'incorrect_parent_class';

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

    context.registry.addClassDeclaration((node) {
      final parent = node.extendsClause?.superclass;
      final currentClass = node.name.toString();
      if (parent != null) {
        final parentName = parent.toString();
        if (parameters.classPostFixes.any((e) => currentClass.endsWith(e)) &&
            !parameters.parentClassPreFixes.any((e) => parentName.startsWith(e))) {
          reporter.atNode(
            node,
            code,
          );
        }
      }
    });
  }
}

class _IncorrectParentClassOption extends Excludable {
  const _IncorrectParentClassOption({
    this.excludes = const [],
    this.includes = const [],
    this.severity,
    this.classPostFixes = _defaultClassPostFixes,
    this.parentClassPreFixes = _defaultParentClassPreFixes,
  });

  final ErrorSeverity? severity;
  @override
  final List<String> excludes;
  @override
  final List<String> includes;

  final List<String> classPostFixes;
  final List<String> parentClassPreFixes;

  static _IncorrectParentClassOption fromMap(Map<String, dynamic> map) {
    return _IncorrectParentClassOption(
      excludes: safeCastToListString(map['excludes']),
      includes: safeCastToListString(map['includes']),
      severity: convertStringToErrorSeverity(map['severity']),
      classPostFixes:
          safeCastToListString(map['class_post_fixes'], defaultValue: _defaultClassPostFixes),
      parentClassPreFixes: safeCastToListString(map['parent_class_pre_fixes'],
          defaultValue: _defaultParentClassPreFixes),
    );
  }

  static const _defaultClassPostFixes = ['Page', 'PageState'];
  static const _defaultParentClassPreFixes = [
    'BasePage',
    'BaseStatefulPageState',
    'StatefulHookConsumerWidget',
  ];
}
