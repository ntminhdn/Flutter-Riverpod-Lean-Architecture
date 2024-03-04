import 'dart:async';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nalsflutter/index.dart';
import 'package:platform/platform.dart';

import 'common/base_test.dart' as base;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      adjustDiff();
      await loadFonts();
      await base.main();
      return testMain();
    },
    config: GoldenToolkitConfiguration(
      enableRealShadows: true,
      defaultDevices: const [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
      ],
    ),
  );
}

void adjustDiff() {
  // NOTE: Tolerance specified as a number between 0 and 1, not as a percentage, where 1 corresponds to 100%.
  const _acceptableErrorThresholdValue = 0.003 / 100;

  if (goldenFileComparator is LocalFileComparator) {
    final testUrl = (goldenFileComparator as LocalFileComparator).basedir;

    goldenFileComparator = LocalFileComparatorWithThreshold(
      Uri.parse('$testUrl/test.dart'),
      acceptableErrorThresholdValue: _acceptableErrorThresholdValue,
    );
  } else {
    throw Exception(
      'Expected `goldenFileComparator` to be of type `LocalFileComparator`, '
      'but it is of type `${goldenFileComparator.runtimeType}`',
    );
  }
}

Future<void> loadFonts() async {
  await loadAppFonts();

  // load the MaterialIcons font
  final materialIconsFont = _loadMaterialIconFont();
  final materialIconsFontLoader = FontLoader('MaterialIcons')..addFont(materialIconsFont);
  await materialIconsFontLoader.load();

  // load CupertinoIcons font
  final cupertinoIconsFontLoader = FontLoader('packages/cupertino_icons/CupertinoIcons')
    ..addFont(
      rootBundle.load('assets/fonts/Cupertino/CupertinoIcons.ttf'),
    );
  await cupertinoIconsFontLoader.load();
}

Future<ByteData> _loadMaterialIconFont() async {
  const FileSystem fs = LocalFileSystem();
  const Platform platform = LocalPlatform();
  final flutterRoot = fs.directory(platform.environment['FLUTTER_ROOT']);

  final iconFont = flutterRoot.childFile(
    fs.path.join(
      'bin',
      'cache',
      'artifacts',
      'material_fonts',
      'MaterialIcons-Regular.otf',
    ),
  );

  final bytes = Future<ByteData>.value(
    iconFont.readAsBytesSync().buffer.asByteData(),
  );

  return bytes;
}

class LocalFileComparatorWithThreshold extends LocalFileComparator {
  // ignore: prefer_named_parameters
  LocalFileComparatorWithThreshold(super.testFile, {required this.acceptableErrorThresholdValue})
      : assert(acceptableErrorThresholdValue >= 0 && acceptableErrorThresholdValue <= 1);
  final double acceptableErrorThresholdValue;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    // Note: diffPercent contains "Percent" in the name, but is actually a number between 0 and 1.
    if (!result.passed && result.diffPercent <= acceptableErrorThresholdValue) {
      Log.d(
        'A difference of ${result.diffPercent * 100}% was found, but it is '
        'acceptable since it is not greater than the threshold of '
        '${acceptableErrorThresholdValue * 100}%',
      );
      return true;
    }

    if (!result.passed) {
      final error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    return result.passed;
  }
}
