import 'package:collection/collection.dart';

import '../index.dart';

class MissingExpandedOrFlexible extends OptionsLintRule<_MissingExpandedOrFlexibleOption> {
  MissingExpandedOrFlexible(
    CustomLintConfigs configs,
  ) : super(
          RuleConfig(
            name: lintName,
            configs: configs,
            paramsParser: _MissingExpandedOrFlexibleOption.fromMap,
            problemMessage: (options) =>
                'Should use Expanded or Flexible widget to avoid overflow error.',
          ),
        );

  static const String lintName = 'missing_expanded_or_flexible';

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

    context.registry.addInstanceCreationExpression((node) {
      final widget = node.constructorName.type.toString();
      if (widget == 'Row' || widget == 'Column') {
        final children = node.argumentList.arguments
            .whereType<NamedExpression>()
            .firstWhereOrNull((element) => element.name.label.name == 'children');

        if (children != null) {
          final childrenList = children.expression;
          if (childrenList is ListLiteral && childrenList.elements.length >= 2) {
            final children = childrenList.elements;
            final hasExpandedOrFlexible = children.any((element) {
              if (element is! InstanceCreationExpression) {
                return false;
              }
              final type = element.constructorName.type.toString();
              return type == 'Expanded' || type == 'Flexible';
            });

            if (!hasExpandedOrFlexible) {
              reporter.atNode(node.constructorName, code);
            }
          }
        }
      }
    });
  }
}

class _MissingExpandedOrFlexibleOption extends Excludable {
  const _MissingExpandedOrFlexibleOption({
    this.excludes = const [],
    this.includes = const [],
    this.severity,
  });

  final ErrorSeverity? severity;
  @override
  final List<String> excludes;
  @override
  final List<String> includes;

  static _MissingExpandedOrFlexibleOption fromMap(Map<String, dynamic> map) {
    return _MissingExpandedOrFlexibleOption(
      excludes: safeCastToListString(map['excludes']),
      includes: safeCastToListString(map['includes']),
      severity: convertStringToErrorSeverity(map['severity']),
    );
  }
}
