import '../index.dart';

class PreferImportingIndexFile extends OptionsLintRule<_PreferImportingIndexFileOption> {
  PreferImportingIndexFile(
    CustomLintConfigs configs,
  ) : super(
          RuleConfig(
            name: lintName,
            configs: configs,
            paramsParser: _PreferImportingIndexFileOption.fromMap,
            problemMessage: (options) =>
                'Should export these files to index.dart file and import index.dart file instead of importing each file separately.',
          ),
        );

  static const String lintName = 'prefer_importing_index_file';

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

    context.registry.addImportDirective((node) {
      final importUri = node.uri.stringValue;
      if (importUri != null &&
          !importUri.startsWith('dart:') &&
          !importUri.startsWith('package:') &&
          !importUri.endsWith('index.dart')) {
        reporter.atNode(node, code);
      }
    });
  }
}

class _PreferImportingIndexFileOption extends Excludable {
  const _PreferImportingIndexFileOption({
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

  static _PreferImportingIndexFileOption fromMap(Map<String, dynamic> map) {
    return _PreferImportingIndexFileOption(
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
