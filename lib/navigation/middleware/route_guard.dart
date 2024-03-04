import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../../index.dart';

@Injectable()
class RouteGuard extends AutoRouteGuard {
  RouteGuard(this.appPreferences);

  final AppPreferences appPreferences;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (appPreferences.isLoggedIn) {
      resolver.next(true);
    } else {
      router.push(const LoginRoute());
      resolver.next(false);
    }
  }
}
