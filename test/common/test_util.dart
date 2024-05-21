import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:nalsflutter/index.dart';

import 'index.dart';

class TestUtil {
  const TestUtil._();

  static String filename(String filename) {
    return '${TestConfig.isDarkMode ? 'dark_mode/' : ''}$filename';
  }

  static String description(String description) {
    return '$description${TestConfig.isDarkMode ? ' dark mode' : ''}';
  }

  static ProviderContainer createContainer({
    ProviderContainer? parent,
    List<Override> overrides = const [],
    List<ProviderObserver>? observers,
  }) {
    final container = ProviderContainer(
      parent: parent,
      overrides: overrides,
      observers: observers,
    );

    addTearDown(container.dispose);

    return container;
  }

  static Widget buildRouterMaterialApp({
    required PageRouteInfo<dynamic> initialRoute,
    required AppRouter appRouter,
  }) {
    AppThemeSetting.currentAppThemeType =
        TestConfig.isDarkMode ? AppThemeType.dark : AppThemeType.light;

    return MediaQuery(
      data: const MediaQueryData(
        size: Size(Constant.designDeviceWidth, Constant.designDeviceHeight),
      ),
      child: ScreenUtilInit(
        designSize: const Size(Constant.designDeviceWidth, Constant.designDeviceHeight),
        builder: (context, __) {
          AppDimen.of(context);
          AppColor.of(context);

          return MaterialApp.router(
            builder: (context, child) {
              final widget = MediaQuery.withNoTextScaling(
                child: child ?? const SizedBox.shrink(),
              );

              return widget;
            },
            routerDelegate: appRouter.delegate(
              deepLinkBuilder: (deepLink) {
                return DeepLink([initialRoute]);
              },
            ),
            routeInformationParser: appRouter.defaultRouteParser(),
            title: Constant.materialAppTitle,
            color: Constant.taskMenuMaterialAppColor,
            themeMode: TestConfig.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) =>
                supportedLocales.contains(locale) ? locale : TestConfig.goldenTestsLocale,
            locale: TestConfig.goldenTestsLocale,
            supportedLocales: AppString.supportedLocales,
            localizationsDelegates: const [
              AppString.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }

  // ignore: prefer_named_parameters
  static Widget buildMaterialApp(
    Widget wrapper, {
    TargetPlatform platform = TestConfig.targetPlatform,
  }) {
    AppThemeSetting.currentAppThemeType =
        TestConfig.isDarkMode ? AppThemeType.dark : AppThemeType.light;

    return materialAppWrapper(
      platform: platform,
      localizations: const [
        AppString.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeOverrides: [TestConfig.goldenTestsLocale],
      theme: TestConfig.isDarkMode ? darkTheme : lightTheme,
    ).call(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(Constant.designDeviceWidth, Constant.designDeviceHeight),
        ),
        child: ScreenUtilInit(
          designSize: const Size(Constant.designDeviceWidth, Constant.designDeviceHeight),
          builder: (context, __) {
            AppDimen.of(context);
            AppColor.of(context);

            return wrapper;
          },
        ),
      ),
    );
  }
}

extension CommonStateExt<T extends BaseState> on CommonState<T> {
  List<CommonState<T>> get showAndHideLoading {
    return [
      copyWith(isLoading: true),
      copyWith(isLoading: false),
    ];
  }
}

extension WidgetTesterExt on WidgetTester {
  Future<void> testWidgetWithWidgetBuilder({
    required String filename,
    required Widget widget,
    Future<void> Function(WidgetTester)? onCreate,
    List<Override> overrides = const [],
    bool mergeIntoSingleImage = true,
    bool runAsynchronous = true,
    Future<void> Function(WidgetTester)? customPump,
  }) async {
    if (runAsynchronous) {
      await runAsync(() async => await _pumpWidgetBuilder(
            widget: widget,
            overrides: overrides,
          ));
    } else {
      await _pumpWidgetBuilder(
        widget: widget,
        overrides: overrides,
      );
    }

    await pumpAndSettle();
    await onCreate?.call(this);

    await _takeScreenshot(
      filename: filename,
      mergeIntoSingleImage: mergeIntoSingleImage,
      customPump: customPump,
    );
  }

  Future<void> testWidgetWithDeviceBuilder({
    required String filename,
    required Widget widget,
    Future<void> Function(WidgetTester, Key)? onCreate,
    List<Override> overrides = const [],
    bool mergeIntoSingleImage = true,
    bool runAsynchronous = true,
    Future<void> Function(WidgetTester)? customPump,
  }) async {
    final builder = DeviceBuilder()
      ..addScenario(
        widget: widget,
        onCreate: onCreate == null ? null : (key) => onCreate.call(this, key),
      );

    if (runAsynchronous) {
      await runAsync(
        () async => await _pumpDeviceBuilder(
          builder: builder,
          overrides: overrides,
        ),
      );
    } else {
      await _pumpDeviceBuilder(
        builder: builder,
        overrides: overrides,
      );
    }

    await _takeScreenshot(
      filename: filename,
      mergeIntoSingleImage: mergeIntoSingleImage,
      customPump: customPump,
    );
  }

  Future<void> _pumpWidgetBuilder({
    required Widget widget,
    List<Override> overrides = const [],
  }) {
    return mockNetworkImages(
      () async => await pumpWidgetBuilder(
        widget,
        wrapper: (wrapper) => ProviderScope(
          overrides: overrides,
          child: _buildMaterialApp(
            wrapper,
            overrides: overrides,
          ),
        ),
      ),
    );
  }

  Future<void> _pumpDeviceBuilder({
    required DeviceBuilder builder,
    List<Override> overrides = const [],
  }) {
    return mockNetworkImages(
      () async => await pumpDeviceBuilder(
        builder,
        wrapper: (wrapper) => _buildMaterialApp(
          wrapper,
          overrides: overrides,
        ),
      ),
    );
  }

  Widget _buildMaterialApp(
    Widget wrapper, {
    List<Override> overrides = const [],
  }) =>
      ProviderScope(
        overrides: overrides,
        child: TestUtil.buildMaterialApp(wrapper),
      );

  Future<void> _takeScreenshot({
    required String filename,
    bool mergeIntoSingleImage = true,
    Future<void> Function(WidgetTester)? customPump,
  }) async {
    if (mergeIntoSingleImage) {
      await screenMatchesGolden(
        this,
        filename,
        customPump: customPump,
      );
    } else {
      await multiScreenGolden(
        this,
        filename,
        devices: TestConfig.targetGoldenTestDevices,
        customPump: customPump,
      );
    }
  }

  Future<void> tapOnBottomNavigationTab(int index) async {
    final bottomNavigatorBarFinder = find.byType(BottomNavigationBar);
    expect(bottomNavigatorBarFinder, findsOneWidget);
    final bottomBarWidget = widget<BottomNavigationBar>(bottomNavigatorBarFinder);
    expect(bottomBarWidget.onTap, isNotNull);
    bottomBarWidget.onTap!.call(index);
    await pumpAndSettle();
  }
}

extension FinderExt on Finder {
  // ignore: prefer_named_parameters
  Finder isDescendantOf(Finder finder, CommonFinders find) {
    return find.descendant(of: finder, matching: this);
  }

  // ignore: prefer_named_parameters
  Finder isAncestorOf(Finder finder, CommonFinders find) {
    return find.ancestor(of: finder, matching: this);
  }
}
