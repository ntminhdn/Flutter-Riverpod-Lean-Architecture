import 'package:collection/collection.dart';

import '../index.dart';

class TestFolderMustMirrorLibFolder extends OptionsLintRule<_TestFolderMustMirrorLibFolderOption> {
  TestFolderMustMirrorLibFolder(
    CustomLintConfigs configs,
  ) : super(
          RuleConfig(
            name: lintName,
            configs: configs,
            paramsParser: _TestFolderMustMirrorLibFolderOption.fromMap,
            problemMessage: (_) =>
                'Test files must have names ending with \'$_testFileSuffix\', and their paths must mirror the structure of the \'lib\' folder.',
          ),
        );

  static const String lintName = 'test_folder_must_mirror_lib_folder';
  static const _testFileSuffix = '_test';

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

    final relatedPath = relativePath(resolver.path, rootPath);

    final testFolderPath =
        parameters.testFolderPaths.firstWhereOrNull((element) => relatedPath.startsWith(element));

    if (testFolderPath == null) {
      return;
    }

    final fileName = getFileNameFromPath(resolver.path);

    if (!fileName.endsWith(_testFileSuffix)) {
      reporter.atOffset(
        offset: 0,
        length: resolver.documentLength,
        errorCode: code,
      );
      return;
    }

    final libFilePath = relatedPath
        .replaceFirst(testFolderPath, parameters.libFolderPath)
        .replaceLast(pattern: _testFileSuffix, replacement: '');

    if (!File('$rootPath/$libFilePath').existsSync()) {
      reporter.atOffset(
        offset: 0,
        length: resolver.documentLength,
        errorCode: code,
      );
    }
  }
}

class _TestFolderMustMirrorLibFolderOption extends Excludable {
  const _TestFolderMustMirrorLibFolderOption({
    this.excludes = const [],
    this.includes = const [],
    this.severity,
    this.libFolderPath = _defaultLibFolderPath,
    this.testFolderPaths = _defaultTestFolderPaths,
  });

  final ErrorSeverity? severity;
  @override
  final List<String> excludes;
  @override
  final List<String> includes;
  final String libFolderPath;
  final List<String> testFolderPaths;

  static _TestFolderMustMirrorLibFolderOption fromMap(Map<String, dynamic> map) {
    return _TestFolderMustMirrorLibFolderOption(
      excludes: safeCastToListString(map['excludes']),
      includes: safeCastToListString(map['includes']),
      severity: convertStringToErrorSeverity(map['severity']),
      libFolderPath: safeCast(map['lib_folder_path']) ?? _defaultLibFolderPath,
      testFolderPaths:
          safeCastToListString(map['test_folder_paths'], defaultValue: _defaultTestFolderPaths),
    );
  }

  static const _defaultLibFolderPath = 'lib';
  static const _defaultTestFolderPaths = ['test/unit_test', 'test/widget_test'];
}
