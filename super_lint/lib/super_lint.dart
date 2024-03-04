import 'src/index.dart';

PluginBase createPlugin() => _SuperLintPlugin();

class _SuperLintPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [
      AvoidUnnecessaryAsyncFunction(configs),
      PreferNamedParameters(configs),
      PreferIsEmptyString(configs),
      PreferIsNotEmptyString(configs),
      IncorrectTodoComment(configs),
      PreferAsyncAwait(configs),
      PreferLowerCaseTestDescription(configs),
      TestFolderMustMirrorLibFolder(configs),
      AvoidHardCodedColors(configs),
    ];
  }
}
