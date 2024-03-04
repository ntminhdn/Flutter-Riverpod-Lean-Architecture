import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test/src/channel.dart';
import 'package:nalsflutter/index.dart';

import '../../integration_test/common/index.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> pumpWithDuration(
    Duration duration, {
    int delayMillisecond = TestConfig.delayInMillis,
  }) {
    final waitingForRenderer = Completer<void>();
    var afterTime = Duration(milliseconds: duration.inMilliseconds);
    Future.doWhile(() async {
      if (afterTime.inMilliseconds == 0) {
        waitingForRenderer.complete();

        return false;
      }

      await Future.delayed(
        Duration(milliseconds: delayMillisecond),
        () async {
          await pump();
          afterTime = Duration(
            milliseconds: afterTime.inMilliseconds > delayMillisecond
                ? afterTime.inMilliseconds - delayMillisecond
                : 0,
          );
        },
      );

      return true;
    });

    return waitingForRenderer.future;
  }

  Future<void> pumpTillDone(
    Finder finder, {
    int delayMilliseconds = TestConfig.delayInMillis,
    int timeoutMilliseconds = TestConfig.timeoutInMillis,
  }) {
    final waitingForRenderer = Completer<void>();
    var afterTime = Duration.zero;
    Future.doWhile(() async {
      if (any(finder) || afterTime.inMilliseconds >= timeoutMilliseconds) {
        waitingForRenderer.complete();

        return false;
      }

      await Future.delayed(
        Duration(milliseconds: delayMilliseconds),
        () async {
          await pump();
          afterTime = Duration(
            milliseconds: afterTime.inMilliseconds + delayMilliseconds,
          );
        },
      );

      return true;
    });

    return waitingForRenderer.future;
  }

  Future<void> pumpTillOneVisible(
    List<Finder> finders, {
    int delayMilliseconds = TestConfig.delayInMillis,
    int timeoutMilliseconds = TestConfig.timeoutInMillis,
  }) {
    final waitingForRenderer = Completer<void>();
    var afterTime = Duration.zero;
    Future.doWhile(() async {
      for (var index = 0; index < finders.length; index++) {
        if (any(finders[index]) || afterTime.inMilliseconds >= timeoutMilliseconds) {
          waitingForRenderer.complete();

          return false;
        }
      }

      await Future.delayed(
        Duration(milliseconds: delayMilliseconds),
        () async {
          await pump();
          afterTime = Duration(
            milliseconds: afterTime.inMilliseconds + delayMilliseconds,
          );
        },
      );

      return true;
    });

    return waitingForRenderer.future;
  }

  Future<void> pumpTillSatisfied(
    bool Function() isSatified, {
    int delayMilliseconds = TestConfig.delayInMillis,
    int timeoutMilliseconds = TestConfig.timeoutInMillis,
  }) {
    final waitingForRenderer = Completer<void>();
    var afterTime = Duration.zero;
    Future.doWhile(() async {
      if (isSatified() || afterTime.inMilliseconds >= timeoutMilliseconds) {
        waitingForRenderer.complete();

        return false;
      }

      await Future.delayed(
        Duration(milliseconds: delayMilliseconds),
        () async {
          await pump();
          afterTime = Duration(
            milliseconds: afterTime.inMilliseconds + delayMilliseconds,
          );
        },
      );

      return true;
    });

    return waitingForRenderer.future;
  }

  Future<void> tapOnBottomNavigationTab(int index) async {
    final bottomNavigatorBarFinder = find.byType(BottomNavigationBar);
    expect(bottomNavigatorBarFinder, findsOneWidget);
    final bottomBarWidget = widget<BottomNavigationBar>(bottomNavigatorBarFinder);
    expect(bottomBarWidget.onTap, isNotNull);
    bottomBarWidget.onTap!.call(index);
    await pumpAndSettle();
  }

  Future<void> popCurrentPage() async {
    state<NavigatorState>(find.byType(Navigator)).pop();
    await pumpAndSettle();
  }

  Future<void> openLoginPage() async {
    final loginPageFinder = find.byType(LoginPage);
    await pumpTillOneVisible([loginPageFinder]);
  }

  Future<void> dismissOnScreenKeyboard() {
    return testTextInput.receiveAction(TextInputAction.done);
  }

  Future<void> takeScreenShot({
    required IntegrationTestWidgetsFlutterBinding binding,
    required String fileName,
  }) async {
    if (Platform.isAndroid) {
      await _takeScreenshotForAndroid(
        binding: binding,
        fileName: '${TestConfig.androidScreenShotsFolder}/$fileName',
      );
    } else {
      await binding.takeScreenshot('${TestConfig.iosScreenShotsFolder}/$fileName');
    }
  }

  Future<void> _takeScreenshotForAndroid({
    required IntegrationTestWidgetsFlutterBinding binding,
    required String fileName,
  }) async {
    await integrationTestChannel.invokeMethod<void>(
      'convertFlutterSurfaceToImage',
    );

    await pumpWithDuration(500.milliseconds);

    binding.reportData ??= <String, dynamic>{};
    binding.reportData!['screenshots'] ??= <dynamic>[];
    integrationTestChannel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'scheduleFrame':
          PlatformDispatcher.instance.scheduleFrame();
      }

      return null;
    });

    final rawBytes = await integrationTestChannel
        .invokeMethod<List<int>>('captureScreenshot', <String, dynamic>{'name': fileName});

    if (rawBytes == null) {
      return;
    }

    final data = <String, dynamic>{'screenshotName': fileName, 'bytes': rawBytes};
    assert(data.containsKey('bytes'));
    (binding.reportData!['screenshots'] as List<dynamic>).add(data);

    await integrationTestChannel.invokeMethod<void>('revertFlutterImage');
  }
}
