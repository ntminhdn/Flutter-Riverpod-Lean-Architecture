// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:yaml/yaml.dart';

void main() {
  const pubspecPath = './pubspec.yaml';
  final pubspecContent = File(pubspecPath).readAsStringSync();
  final yaml = loadYaml(pubspecContent);
  final dependencies = yaml['dependencies'] as YamlMap? ?? {};
  final devDependencies = yaml['dev_dependencies'] as YamlMap? ?? {};
  final dependencyOverrides = yaml['dependency_overrides'] as YamlMap? ?? {};

  final invalidDependencies = dependencies.filter((entry) => isInvalidPub(entry.value));
  final invalidDevDependencies = devDependencies.filter((entry) => isInvalidPub(entry.value));
  final invalidDependencyOverrides =
      dependencyOverrides.filter((entry) => isInvalidPub(entry.value));

  if (invalidDependencies.isNotEmpty) {
    print('Invalid dependencies: ${invalidDependencies.keys}');
  }

  if (invalidDevDependencies.isNotEmpty) {
    print('Invalid dev dependencies: ${invalidDevDependencies.keys}');
  }

  if (invalidDependencyOverrides.isNotEmpty) {
    print('Invalid dependency overrides: ${invalidDependencyOverrides.keys}');
  }

  exit(invalidDependencies.isNotEmpty ||
          invalidDevDependencies.isNotEmpty ||
          invalidDependencyOverrides.isNotEmpty
      ? 1
      : 0);
}

bool isInvalidPub(dynamic pubVersion) {
  return pubVersion == null ||
      pubVersion is String &&
          (pubVersion.trim() == 'any' || pubVersion.isBlank || pubVersion.startsWith('^'));
}
