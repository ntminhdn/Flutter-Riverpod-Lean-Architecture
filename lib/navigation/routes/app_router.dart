import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../index.dart';

final appRouterProvider = Provider<AppRouter>(
  (ref) => getIt.get<AppRouter>(),
);

// ignore_for_file:prefer-single-widget-per-file
@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
@LazySingleton()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: ChatRoute.page),
        AutoRoute(page: AllUsersRoute.page),
        AutoRoute(page: RenameConversationRoute.page),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: MainRoute.page, children: [
          AutoRoute(
            page: ContactListTab.page,
            maintainState: true,
            children: [
              AutoRoute(page: ContactListRoute.page, initial: true),
            ],
          ),
          AutoRoute(
            page: MyPageTab.page,
            maintainState: true,
            children: [
              AutoRoute(page: MyPageRoute.page, initial: true),
              AutoRoute(page: SettingRoute.page),
            ],
          ),
        ]),
      ];
}

@RoutePage(name: 'ContactListTab')
class ContactListTabPage extends AutoRouter {
  const ContactListTabPage({super.key});
}

@RoutePage(name: 'MyPageTab')
class MyPageTabPage extends AutoRouter {
  const MyPageTabPage({super.key});
}
