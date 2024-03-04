// ignore_for_file: avoid_print

import 'dart:io';

/// Actions: 'remove', 'check', 'comment' (default)
/// Commands:
/// - make remove_unused_l10n
/// - make check_unused_l10n
/// - make comment_unused_l10n
void main(List<String> args) async {
  const l10nPath = './lib/resource/l10n';

  final input = args.isNotEmpty ? args.first : 'comment';
  print('$input unused l10n...');
  final consoleOutput = await runCommandAndReadOutput();

  final unusedL10nText = getUnusedL10n(consoleOutput);

  print(unusedL10nText);

  final unusedL10nKeys = getUnusedL10nKey(unusedL10nText);

  Directory(l10nPath).listSync().forEach((file) {
    final result =
        commentOrRemoveUnusedL10n(File(file.path).readAsLinesSync(), input, unusedL10nKeys);
    final content = result.join('\n').trimRight();
    File(file.path).writeAsStringSync('$content\n');
  });
}

List<String> commentOrRemoveUnusedL10n(List<String> arb, String input, Set<String> unused) {
  return arb
      .map((it) {
        final trimText = it.trim();
        if (trimText.startsWith('"')) {
          final key = trimText.substring(1, trimText.indexOf('"', 1));

          return unused.contains(key)
              ? input == 'remove'
                  ? ''
                  : '//[Unused] $it'.trimRight()
              : it.trimRight();
        } else {
          return it.trimRight();
        }
      })
      .where((it) => it.trim().isNotEmpty)
      .toList()
    ..sort((o1, o2) {
      if (input == 'check') {
        if (o1.startsWith('{') || o2.startsWith('{')) {
          return -2;
        } else if (o1.startsWith('//')) {
          return -1;
        } else if (o2.startsWith('//')) {
          return 1;
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    });
}

String getUnusedL10n(String input) {
  final classIndex = input.indexOf(RegExp(r'\bclass S\b'));
  if (classIndex >= 0) {
    final afterClassIndex = input.indexOf(RegExp(r'\bclass\b'), classIndex + 1);
    if (afterClassIndex >= 0) {
      final result = input.substring(classIndex, afterClassIndex).trim();

      return result;
    }
  }

  return '';
}

Set<String> getUnusedL10nKey(String output) {
  return output
      .split('\n')
      .where((it) => it.trim().startsWith('⚠ unused') && !it.contains('of(BuildContext context)'))
      .map((it) => it.substring(it.indexOf('unused') + 'unused'.length).trim())
      .toSet();
}

Future<String> runCommandAndReadOutput() async {
  try {
    final result = await Process.run('/usr/bin/make', ['dcm_check_unused_l10n']);

    final String stdout = result.stdout as String;
    // final String stderr = result.stderr as String;

    return stdout;
  } catch (e) {
    throw 'Error executing the command: $e';
  }
}
