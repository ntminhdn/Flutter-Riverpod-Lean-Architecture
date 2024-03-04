// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:tuple/tuple.dart';

void main() {
  const l10nPath = './lib/resource/l10n';

  Directory(l10nPath).listSync().forEach((file) {
    final listL10n = convertArbToListL10n(File(file.path).readAsStringSync());
    final countValueMap = groupByValue(listL10n);
    File(file.path).writeAsStringSync("{\n${listL10n.map((l10n) {
      final line =
          (countValueMap[l10n.value]?.item1 ?? 0) >= 2 ? l10n.copyWith(isDupValue: true) : l10n;

      return line;
    }).join(",\n")}\n}\n");
    print('Dup l10n of ${file.path}:\n${filterDuplicates(countValueMap)}');
  });
}

List<L10n> convertArbToListL10n(String arbText) {
  return arbText
      .split(',\n')
      .map((it) {
        final match = RegExp(r'(.*)"(\w+)" *: *"(.+)"').firstMatch(it);

        return match?.groups([0, 1, 2, 3]) ?? [];
      })
      .where((it) => it.isNotEmpty)
      .map((it) {
        return L10n(key: it[2]!, value: it[3]!, comment: it[1]!);
      })
      .toList();
}

Map<String, Tuple2<int, List<String>>> groupByValue(List<L10n> listL10n) {
  final countValueMap = <String, Tuple2<int, List<String>>>{};
  for (var l10n in listL10n) {
    countValueMap[l10n.value] = Tuple2(
      (countValueMap[l10n.value]?.item1 ?? 0) + 1,
      countValueMap[l10n.value]?.item2.appendElement(l10n.key).toList() ?? [l10n.key],
    );
  }

  return countValueMap;
}

String filterDuplicates(Map<String, Tuple2<int, List<String>>> countValueMap) {
  final dups = countValueMap.filter((entry) => entry.value.item1 >= 2);
  String result = '';

  for (var dup in dups.entries) {
    result += '* "${dup.key}" (${dup.value.item1}): ${dup.value.item2}\n';
  }

  return result;
}

class L10n {
  L10n({
    required this.key,
    required this.value,
    required this.comment,
    this.isDupValue = false,
  });

  final String key;
  final String value;
  final String comment;
  final bool isDupValue;

  @override
  String toString() {
    final commentPrefix =
        isDupValue && !comment.trimLeft().startsWith('//[DupValue]') ? '//[DupValue]' : '';
    final line = '$commentPrefix $comment "${key}": "${value}"'.trim();

    return !line.startsWith('//') ? '  $line' : line;
  }

  L10n copyWith({
    String? key,
    String? value,
    String? comment,
    bool? isDupValue,
  }) {
    return L10n(
      key: key ?? this.key,
      value: value ?? this.value,
      comment: comment ?? this.comment,
      isDupValue: isDupValue ?? this.isDupValue,
    );
  }
}
