import '../index.dart';

class AvoidHardCodedColors extends OptionsLintRule<_AvoidHardCodedColorsOption> {
  AvoidHardCodedColors(
    CustomLintConfigs configs,
  ) : super(
          RuleConfig(
              name: lintName,
              configs: configs,
              paramsParser: _AvoidHardCodedColorsOption.fromMap,
              problemMessage: (_) =>
                  'Avoid hard-coding colors, except for Colors.transparent, such as Color(0xFFFFFF) and Colors.white.\nPlease use \'cl.xxx\' instead'),
        );
  static const String lintName = 'avoid_hard_coded_colors';

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

    unawaited(resolver
        .getResolvedUnitResult()
        .then((value) => value.unit.visitChildren(VariableAndArgumentVisitor(
              onVisitInstanceCreationExpression: (InstanceCreationExpression node) {
                for (var element in node.argumentList.arguments) {
                  if (element is NamedExpression) {
                    if (_isHardCoded(element.expression.toString())) {
                      reporter.atNode(element.expression, code);
                    }
                  } else if (_isHardCoded(element.toString())) {
                    reporter.atNode(element, code);
                  }
                }
              },
              onVisitVariableDeclaration: (VariableDeclaration node) {
                if (node.initializer != null && _isHardCoded(node.initializer.toString())) {
                  reporter.atNode(node.initializer!, code);
                }
              },
              onVisitAssignmentExpression: (AssignmentExpression node) {
                if (_isHardCoded(node.rightHandSide.toString())) {
                  reporter.atNode(node.rightHandSide, code);
                }
              },
              onVisitConstructorFieldInitializer: (ConstructorFieldInitializer node) {
                if (_isHardCoded(node.expression.toString())) {
                  reporter.atNode(node.expression, code);
                }
              },
              onVisitSuperConstructorInvocation: (SuperConstructorInvocation node) {
                for (var element in node.argumentList.arguments) {
                  if (element is NamedExpression) {
                    if (_isHardCoded(element.expression.toString())) {
                      reporter.atNode(element.expression, code);
                    }
                  } else if (_isHardCoded(element.toString())) {
                    reporter.atNode(element, code);
                  }
                }
              },
              onVisitConstructorDeclaration: (ConstructorDeclaration node) {
                for (var element in node.parameters.parameterElements) {
                  if (element?.defaultValueCode != null &&
                      _isHardCoded(element!.defaultValueCode!)) {
                    if (element is DefaultFieldFormalParameterElementImpl) {
                      reporter.atNode(element.constantInitializer!, code);
                    } else if (element is DefaultParameterElementImpl) {
                      reporter.atNode(element.constantInitializer!, code);
                    } else {
                      reporter.atNode(node, code);
                    }
                  }
                }
              },
              onVisitArgumentList: (node) {
                for (var element in node.arguments) {
                  if (element is NamedExpression) {
                    if (_isHardCoded(element.expression.toString())) {
                      reporter.atNode(element.expression, code);
                    }
                  } else if (_isHardCoded(element.toString())) {
                    reporter.atNode(element, code);
                  }
                }
              },
            ))));
  }

  bool _isHardCoded(String color) {
    if (color == 'Colors.transparent') {
      return false;
    }

    if (color.replaceAll(' ', '').startsWith('Color(') ||
        color.replaceAll(' ', '').startsWith('Colors.') ||
        color.replaceAll(' ', '').startsWith('Color.')) {
      return true;
    }

    return false;
  }
}

class _AvoidHardCodedColorsOption extends Excludable {
  const _AvoidHardCodedColorsOption({
    this.excludes = const [],
    this.includes = const [],
    this.severity,
  });

  final ErrorSeverity? severity;
  @override
  final List<String> excludes;
  @override
  final List<String> includes;

  static _AvoidHardCodedColorsOption fromMap(Map<String, dynamic> map) {
    return _AvoidHardCodedColorsOption(
      excludes: safeCastToListString(map['excludes']),
      includes: safeCastToListString(map['includes']),
      severity: convertStringToErrorSeverity(map['severity']),
    );
  }
}
