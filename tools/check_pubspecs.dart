// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:yaml/yaml.dart';

void main() {
  final excludes = ['analyzer'];
  const pubspecPath = './pubspec.yaml';
  final pubspecContent = File(pubspecPath).readAsStringSync();
  final yaml = loadYaml(pubspecContent);
  final dependencies = yaml['dependencies'] as YamlMap? ?? {};
  final devDependencies = yaml['dev_dependencies'] as YamlMap? ?? {};
  final dependencyOverrides = yaml['dependency_overrides'] as YamlMap? ?? {};

  final invalidDependencies =
      dependencies.filter((entry) => isInvalidPub(entry.value) && !excludes.contains(entry.key));
  final invalidDevDependencies =
      devDependencies.filter((entry) => isInvalidPub(entry.value) && !excludes.contains(entry.key));
  final invalidDependencyOverrides = dependencyOverrides
      .filter((entry) => isInvalidPub(entry.value) && !excludes.contains(entry.key));

  if (invalidDependencies.isNotEmpty) {
    print('Invalid dependencies: ${invalidDependencies.keys}');
  }

  if (invalidDevDependencies.isNotEmpty) {
    print('Invalid dev dependencies: ${invalidDevDependencies.keys}');
  }

  if (invalidDependencyOverrides.isNotEmpty) {
    print('Invalid dependency overrides: ${invalidDependencyOverrides.keys}');
  }

  final exitCode = invalidDependencies.isNotEmpty ||
          invalidDevDependencies.isNotEmpty ||
          invalidDependencyOverrides.isNotEmpty
      ? 1
      : 0;
  print('Exit code: $exitCode');

  exit(exitCode);
}

bool isInvalidPub(dynamic pubVersion) {
  return pubVersion == null ||
      pubVersion is String &&
          (pubVersion.trim() == 'any' || pubVersion.isBlank || pubVersion.startsWith('^'));
}
