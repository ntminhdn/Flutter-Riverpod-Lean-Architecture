import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';
import '../../../localizations/app_localization_view_model.dart';

enum BottomTab {
  home(icon: Icon(Icons.home), activeIcon: Icon(Icons.home)),
  myPage(icon: Icon(Icons.people), activeIcon: Icon(Icons.people));

  const BottomTab({
    required this.icon,
    required this.activeIcon,
  });
  final Icon icon;
  final Icon activeIcon;

  String get title {
    switch (this) {
      case BottomTab.home:
        return l10n.home;
      case BottomTab.myPage:
        return l10n.myPage;
    }
  }
}

@RoutePage()
class MainPage extends BasePage<MainState,
    AutoDisposeStateNotifierProvider<MainViewModel, CommonState<MainState>>> {
  MainPage({super.key});

  @override
  AutoDisposeStateNotifierProvider<MainViewModel, CommonState<MainState>> get provider =>
      mainViewModelProvider;

  final _bottomBarKey = GlobalKey();

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        Future.microtask(() {
          ref.read(provider.notifier).init();
        });

        return () {};
      },
      [],
    );

    return AutoTabsScaffold(
      routes: ref.read(appNavigatorProvider).tabRoutes,
      bottomNavigationBuilder: (_, tabsRouter) {
        ref.read(appNavigatorProvider).tabsRouter = tabsRouter;

        return BottomNavigationBar(
          key: _bottomBarKey,
          currentIndex: tabsRouter.activeIndex,
          onTap: (index) {
            if (index == tabsRouter.activeIndex) {
              ref.read(appNavigatorProvider).popUntilRootOfCurrentBottomTab();
            }
            tabsRouter.setActiveIndex(index);
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: cl.grey1,
          selectedItemColor: cl.black,
          type: BottomNavigationBarType.fixed,
          backgroundColor: cl.white,
          items: BottomTab.values
              .map(
                (tab) => BottomNavigationBarItem(
                  label: tab.title,
                  icon: tab.icon,
                  activeIcon: tab.activeIcon,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
