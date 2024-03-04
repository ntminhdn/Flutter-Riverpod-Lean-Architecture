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
    void _baseTestGoldens({
      required String description,
      required String filename,
      List<Override> overrides = const [],
      Future<void> Function(WidgetTester)? onCreate,
    }) {
      void _build({
        required bool isDarkMode,
      }) {
        testGoldens(TestUtil.description(description, isDarkMode), (tester) async {
          await tester.runAsync(() async {
            await tester.pumpWidgetBuilder(
              ProviderScope(
                overrides: overrides,
                child: TestUtil.buildRouterMaterialApp(
                  initialRoute: MainRoute(),
                  appRouter: appRouter,
                  isDarkMode: isDarkMode,
                ),
              ),
            );
          });

          await tester.pumpAndSettle();
          await onCreate?.call(tester);

          await screenMatchesGolden(
            tester,
            'main_page/${TestUtil.filename(filename, isDarkMode)}',
          );
        });
      }

      _build(isDarkMode: false);
      _build(isDarkMode: true);
    }

    group('test', () {
      _baseTestGoldens(
        description: 'when current bottom navigation index is 0',
        filename: 'when_current_bottom_navigation_index_is_0',
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
        ],
      );
    });

    group('test', () {
      _baseTestGoldens(
        description: 'when current bottom navigation index is 1',
        filename: 'when_current_bottom_navigation_index_is_1',
        onCreate: (tester) async {
          await tester.tapOnBottomNavigationTab(1);
        },
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
        ],
      );
    });
  });
}
