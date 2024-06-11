import 'package:collection/collection.dart';

import '../index.dart';

class PreferCommonWidgets extends OptionsLintRule<_PreferCommonWidgetsOption> {
  PreferCommonWidgets(
    CustomLintConfigs configs,
  ) : super(
          RuleConfig(
            name: lintName,
            configs: configs,
            paramsParser: _PreferCommonWidgetsOption.fromMap,
            problemMessage: (_) =>
                'Use Common Widgets(e.g. CommonText, CommonContainer,...) instead of built-in Widgets',
          ),
        );

  static const String lintName = 'prefer_common_widgets';

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
      final bannedWidget = parameters.bannedWidgets.firstWhereOrNull((element) {
        final methodName = element[_PreferCommonWidgetsOption.keyBannedWidget];
        return node.constructorName.type.toString() == methodName;
      });

      if (bannedWidget != null) {
        reporter.atNode(node.constructorName, code);
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithCommonWidget(config),
      ];
}

class _ReplaceWithCommonWidget extends OptionsFix<_PreferCommonWidgetsOption> {
  _ReplaceWithCommonWidget(super.config);

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) async {
    context.registry.addInstanceCreationExpression((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) {
        return;
      }

      final bannedWidget = config.parameters.bannedWidgets.firstWhereOrNull((element) {
        final methodName = element[_PreferCommonWidgetsOption.keyBannedWidget];
        return node.constructorName.toString() == methodName;
      });

      if (bannedWidget == null) {
        return;
      }

      final commonWidget = bannedWidget[_PreferCommonWidgetsOption.keyCommonWidget];

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Replace with \'$commonWidget\'',
        priority: 7100,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          node.constructorName.sourceRange,
          commonWidget.toString(),
        );
      });
    });
  }
}

class _PreferCommonWidgetsOption extends Excludable {
  const _PreferCommonWidgetsOption({
    this.excludes = const [],
    this.includes = const [],
    this.severity,
    this.bannedWidgets = _defaultBannedWidgets,
  });

  final ErrorSeverity? severity;
  @override
  final List<String> excludes;
  @override
  final List<String> includes;

  final List<Map<String, String>> bannedWidgets;

  static _PreferCommonWidgetsOption fromMap(Map<String, dynamic> map) {
    return _PreferCommonWidgetsOption(
      excludes: safeCastToListString(map['excludes']),
      includes: safeCastToListString(map['includes']),
      severity: convertStringToErrorSeverity(map['severity']),
      bannedWidgets: safeCastToListJson(map['banned_widgets'], defaultValue: _defaultBannedWidgets),
    );
  }

  static const _defaultBannedWidgets = [
    {
      keyBannedWidget: 'Text',
      keyCommonWidget: 'CommonText',
    },
    {
      keyBannedWidget: 'AppBar',
      keyCommonWidget: 'CommonAppBar',
    },
    {
      keyBannedWidget: 'Image',
      keyCommonWidget: 'CommonImage',
    },
    {
      keyBannedWidget: 'CachedNetworkImage',
      keyCommonWidget: 'CommonImage',
    },
    {
      keyBannedWidget: 'SvgPicture',
      keyCommonWidget: 'CommonImage',
    },
    {
      keyBannedWidget: 'Scaffold',
      keyCommonWidget: 'CommonScaffold',
    },
    {
      keyBannedWidget: 'Divider',
      keyCommonWidget: 'CommonDivider',
    },
    {
      keyBannedWidget: 'VerticalDivider',
      keyCommonWidget: 'CommonDivider',
    }
  ];

  static const keyBannedWidget = 'banned_widget';
  static const keyCommonWidget = 'common_widget';
}
