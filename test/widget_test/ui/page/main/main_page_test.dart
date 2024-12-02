import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';
import '../contact_list/contact_list_page_test.dart';

class MockMainViewModel extends StateNotifier<CommonState<MainState>>
    with Mock
    implements MainViewModel {
  MockMainViewModel(super.state);
}

void main() {
  final appRouter = AppRouter();

  setUp(() {
    when(() => navigator.tabRoutes).thenReturn(const [
      ContactListTab(),
      MyPageTab(),
    ]);
  });

  group('MainPage', () {
    testGoldens(TestUtil.description('when current bottom navigation index is 0'), (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidgetBuilder(
          ProviderScope(
            overrides: [
              mainViewModelProvider.overrideWith(
                (_) => MockMainViewModel(
                  const CommonState(
                    data: MainState(),
                  ),
                ),
              ),
              contactListViewModelProvider.overrideWith(
                (_) => MockContactListViewModel(
                  const CommonState(
                    data: ContactListState(),
                  ),
                ),
              ),
              currentUserProvider.overrideWith(
                (ref) => const FirebaseUserData(
                  id: '1',
                  email: 'duynn@gmail.com',
                ),
              ),
              appNavigatorProvider.overrideWith((ref) => navigator),
              analyticsHelperProvider.overrideWith((ref) => analyticsHelper),
            ],
            child: TestUtil.buildRouterMaterialApp(
              initialRoute: MainRoute(),
              appRouter: appRouter,
            ),
          ),
        );
      });

      await tester.pumpAndSettle();

      await screenMatchesGolden(
        tester,
        'main_page/${TestUtil.filename('when_current_bottom_navigation_index_is_0')}',
      );
    });

    testGoldens(TestUtil.description('when current bottom navigation index is 1'), (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidgetBuilder(
          ProviderScope(
            overrides: [
              mainViewModelProvider.overrideWith(
                (_) => MockMainViewModel(
                  const CommonState(
                    data: MainState(),
                  ),
                ),
              ),
              contactListViewModelProvider.overrideWith(
                (_) => MockContactListViewModel(
                  const CommonState(
                    data: ContactListState(),
                  ),
                ),
              ),
              currentUserProvider.overrideWith(
                (ref) => const FirebaseUserData(
                  id: '1',
                  email: 'duynn@gmail.com',
                ),
              ),
              appNavigatorProvider.overrideWith((ref) => navigator),
              analyticsHelperProvider.overrideWith((ref) => analyticsHelper),
            ],
            child: TestUtil.buildRouterMaterialApp(
              initialRoute: MainRoute(),
              appRouter: appRouter,
            ),
          ),
        );
      });

      await tester.pumpAndSettle();
      await tester.tapOnBottomNavigationTab(1);

      await screenMatchesGolden(
        tester,
        'main_page/${TestUtil.filename('when_current_bottom_navigation_index_is_1')}',
      );
    });
  });
}
