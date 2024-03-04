import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' as m;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../index.dart';

final appNavigatorProvider = Provider<AppNavigator>(
  (ref) => getIt.get<AppNavigator>(),
);

@LazySingleton()
class AppNavigator with LogMixin {
  AppNavigator(
    this._appRouter,
  );

  final tabRoutes = const [
    ContactListTab(),
    MyPageTab(),
  ];

  TabsRouter? tabsRouter;

  final AppRouter _appRouter;
  final _popups = <String, Completer<dynamic>>{};

  StackRouter? get _currentTabRouter => tabsRouter?.stackRouterOfIndex(currentBottomTab);

  StackRouter get _currentTabRouterOrRootRouter => _currentTabRouter ?? _appRouter;

  m.BuildContext get _rootRouterContext => _appRouter.navigatorKey.currentContext!;

  m.BuildContext? get _currentTabRouterContext => _currentTabRouter?.navigatorKey.currentContext;

  m.BuildContext get _currentTabContextOrRootContext =>
      _currentTabRouterContext ?? _rootRouterContext;

  int get currentBottomTab {
    if (tabsRouter == null) {
      throw 'Not found any TabRouter';
    }

    return tabsRouter?.activeIndex ?? 0;
  }

  bool get canPopSelfOrChildren => _appRouter.canPop();

  String getCurrentRouteName({bool useRootNavigator = false}) =>
      AutoRouter.of(useRootNavigator ? _rootRouterContext : _currentTabContextOrRootContext)
          .current
          .name;

  RouteData getCurrentRouteData({bool useRootNavigator = false}) =>
      AutoRouter.of(useRootNavigator ? _rootRouterContext : _currentTabContextOrRootContext)
          .current;

  void popUntilRootOfCurrentBottomTab() {
    if (tabsRouter == null) {
      throw 'Not found any TabRouter';
    }

    if (_currentTabRouter?.canPop() == true) {
      if (Config.enableNavigatorObserverLog) {
        logD('popUntilRootOfCurrentBottomTab');
      }
      _currentTabRouter?.popUntilRoot();
    }
  }

  void navigateToBottomTab({required int index, bool notify = true}) {
    if (tabsRouter == null) {
      throw 'Not found any TabRouter';
    }

    if (Config.enableNavigatorObserverLog) {
      logD('navigateToBottomTab with index = $index, notify = $notify');
    }
    tabsRouter?.setActiveIndex(index, notify: notify);
  }

  Future<T?> push<T extends Object?>(PageRouteInfo routeInfo) {
    if (Config.enableNavigatorObserverLog) {
      logD('push $routeInfo');
    }

    return _appRouter.push<T>(routeInfo);
  }

  Future<void> pushAll(List<PageRouteInfo> listRouteInfo) {
    if (Config.enableNavigatorObserverLog) {
      logD('pushAll $listRouteInfo');
    }

    return _appRouter.pushAll(listRouteInfo);
  }

  Future<T?> replace<T extends Object?>(PageRouteInfo routeInfo) {
    _popups.clear();
    if (Config.enableNavigatorObserverLog) {
      logD('replace by $routeInfo');
    }

    return _appRouter.replace<T>(routeInfo);
  }

  Future<void> replaceAll(List<PageRouteInfo> listRouteInfo) {
    _popups.clear();
    if (Config.enableNavigatorObserverLog) {
      logD('replaceAll by $listRouteInfo');
    }

    return _appRouter.replaceAll(listRouteInfo);
  }

  Future<bool> pop<T extends Object?>({
    T? result,
    bool useRootNavigator = false,
  }) {
    if (Config.enableNavigatorObserverLog) {
      logD('pop with result = $result, useRootNav = $useRootNavigator');
    }

    return useRootNavigator
        ? _appRouter.pop<T>(result)
        : _currentTabRouterOrRootRouter.pop<T>(result);
  }

  // ignore: prefer_named_parameters
  Future<T?> popAndPush<T extends Object?, R extends Object?>(
    PageRouteInfo routeInfo, {
    R? result,
    bool useRootNavigator = false,
  }) {
    if (Config.enableNavigatorObserverLog) {
      logD(
        'popAndPush $routeInfo with result = $result, useRootNav = $useRootNavigator',
      );
    }

    return useRootNavigator
        ? _appRouter.popAndPush<T, R>(
            routeInfo,
            result: result,
          )
        : _currentTabRouterOrRootRouter.popAndPush<T, R>(
            routeInfo,
            result: result,
          );
  }

  void popUntilRoot({bool useRootNavigator = false}) {
    if (Config.enableNavigatorObserverLog) {
      logD('popUntilRoot, useRootNav = $useRootNavigator');
    }

    useRootNavigator ? _appRouter.popUntilRoot() : _currentTabRouterOrRootRouter.popUntilRoot();
  }

  void popUntilRouteName(String routeName) {
    if (Config.enableNavigatorObserverLog) {
      logD('popUntilRouteName $routeName');
    }

    _appRouter.popUntilRouteWithName(routeName);
  }

  bool removeUntilRouteName(String routeName) {
    if (Config.enableNavigatorObserverLog) {
      logD('removeUntilRouteName $routeName');
    }

    return _appRouter.removeUntil((route) => route.name == routeName);
  }

  bool removeAllRoutesWithName(String routeName) {
    if (Config.enableNavigatorObserverLog) {
      logD('removeAllRoutesWithName $routeName');
    }

    return _appRouter.removeWhere((route) => route.name == routeName);
  }

  // ignore: prefer_named_parameters
  Future<void> popAndPushAll(
    List<PageRouteInfo> listRouteInfo, {
    bool useRootNavigator = false,
  }) {
    if (Config.enableNavigatorObserverLog) {
      logD('popAndPushAll $listRouteInfo, useRootNav = $useRootNavigator');
    }

    return useRootNavigator
        ? _appRouter.popAndPushAll(listRouteInfo)
        : _currentTabRouterOrRootRouter.popAndPushAll(listRouteInfo);
  }

  bool removeLast() {
    if (Config.enableNavigatorObserverLog) {
      logD('removeLast');
    }

    return _appRouter.removeLast();
  }

  // ignore: prefer_named_parameters
  Future<T?> showDialog<T extends Object?>(
    CommonPopup popup, {
    bool barrierDismissible = true,
    bool useSafeArea = false,
    bool useRootNavigator = true,
  }) async {
    if (_popups.containsKey(popup.id)) {
      logD('Dialog $popup already shown');

      return _popups[popup.id]!.future as Future<T?>;
    }

    _popups[popup.id] = Completer<T?>();

    return m.showDialog<T>(
      context: useRootNavigator ? _rootRouterContext : _currentTabContextOrRootContext,
      builder: (context) => m.PopScope(
        onPopInvoked: (didPop) async {
          logD('Dialog $popup dismissed');
          _popups.remove(popup.id);
        },
        child: popup.builder(context, this),
      ),
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
    );
  }

  // ignore: prefer_named_parameters
  Future<T?> showGeneralDialog<T extends Object?>(
    CommonPopup popup, {
    Duration transitionDuration = Constant.generalDialogTransitionDuration,
    m.Widget Function(
      m.BuildContext,
      m.Animation<double>,
      m.Animation<double>,
      m.Widget,
    )? transitionBuilder,
    m.Color barrierColor = const m.Color(0x80000000),
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) {
    if (_popups.containsKey(popup.id)) {
      logD('Dialog $popup already shown');

      return _popups[popup.id]!.future as Future<T?>;
    }
    _popups[popup.id] = Completer<T?>();

    return m.showGeneralDialog<T>(
      context: useRootNavigator ? _rootRouterContext : _currentTabContextOrRootContext,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      pageBuilder: (
        m.BuildContext context,
        m.Animation<double> animation1,
        m.Animation<double> animation2,
      ) =>
          m.PopScope(
        onPopInvoked: (didPop) async {
          logD('Dialog $popup dismissed');
          _popups.remove(popup.id);
        },
        child: popup.builder(context, this),
      ),
      transitionBuilder: transitionBuilder,
      transitionDuration: transitionDuration,
    );
  }

  // ignore: prefer_named_parameters
  Future<T?> showModalBottomSheet<T extends Object?>(
    CommonPopup popup, {
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    m.Color barrierColor = m.Colors.black54,
    m.Color? backgroundColor,
  }) {
    if (_popups.containsKey(popup.id)) {
      logD('Dialog $popup already shown');

      return _popups[popup.id]!.future as Future<T?>;
    }
    _popups[popup.id] = Completer<T?>();

    return m.showModalBottomSheet<T>(
      context: useRootNavigator ? _rootRouterContext : _currentTabContextOrRootContext,
      builder: (context) => m.PopScope(
        onPopInvoked: (didPop) async {
          logD('Dialog $popup dismissed');
          _popups.remove(popup.id);
        },
        child: popup.builder(context, this),
      ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useRootNavigator: useRootNavigator,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
    );
  }

  void showSnackBar(CommonPopup popup) {
    final messengerState = m.ScaffoldMessenger.maybeOf(_rootRouterContext);
    if (messengerState == null) {
      return;
    }
    messengerState.hideCurrentSnackBar();
    messengerState.showSnackBar(
      popup.builder(_rootRouterContext, this) as m.SnackBar,
    );
  }
}
