import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class MockHomeViewModel extends StateNotifier<CommonState<HomeState>>
    with Mock
    implements HomeViewModel {
  MockHomeViewModel(super.state);
}

HomeViewModel _buildHomeViewModel(CommonState<HomeState> state) {
  final vm = MockHomeViewModel(state);

  when(() => vm.fetchInitialUsers()).thenAnswer((_) async {});

  return vm;
}

void main() {
  group('HomePage', () {
    testGoldens(
      TestUtil.description('when fetching background image failed'),
      (tester) async {
        await runZonedGuarded(
          () async {
            /// Exception to cause errors on purpose also causes errors in this test case, which are mixed with Golden errors.
            /// Therefore, Exception errors in this test case are ignored and only cause Golden errors.
            final oldCallback = FlutterError.onError;
            FlutterError.onError = (details) {
              if (details.exception is HttpExceptionWithStatus) {
                return;
              }
              oldCallback?.call(details);
            };

            await tester.testWidgetWithDeviceBuilder(
              filename: 'home_page/${TestUtil.filename('when_fetching_background_image_failed')}',
              widget: HomePage(cacheManager: MockInvalidCacheManager()),
              overrides: [
                homeViewModelProvider.overrideWith(
                  (_) => _buildHomeViewModel(
                    CommonState(
                      data: HomeState(),
                    ),
                  ),
                ),
              ],
              customPump: (t) => t.pump(),
            );
          },
          (error, stack) {},
        );
      },
    );

    testGoldens(
      TestUtil.description('when `isShimmerLoading` is true'),
      (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'home_page/${TestUtil.filename('when_isShimmerLoading_is_true')}',
          widget: HomePage(cacheManager: MockCacheManager()),
          overrides: [
            homeViewModelProvider.overrideWith(
              (_) => _buildHomeViewModel(
                CommonState(
                  data: HomeState(
                    isShimmerLoading: true,
                  ),
                ),
              ),
            ),
          ],
          customPump: (t) => t.pump(),
        );
      },
    );

    testGoldens(
      TestUtil.description('when `users` is empty'),
      (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'home_page/${TestUtil.filename('when_users_is_empty')}',
          widget: HomePage(cacheManager: MockCacheManager()),
          overrides: [
            homeViewModelProvider.overrideWith(
              (_) => _buildHomeViewModel(
                CommonState(
                  data: HomeState(),
                ),
              ),
            ),
          ],
          customPump: (t) => t.pump(),
        );
      },
    );

    testGoldens(
      TestUtil.description('when `users` is not empty'),
      (tester) async {
        await tester.testWidgetWithDeviceBuilder(
          filename: 'home_page/${TestUtil.filename('when_users_is_not_empty')}',
          widget: HomePage(cacheManager: MockCacheManager()),
          onCreate: (tester, key) async {
            await tester.pump(30.seconds);
            final widget = tester.widget<CommonPagedListView<ApiUserData>>(
              find.byType(CommonPagedListView<ApiUserData>).isDescendantOf(find.byKey(key), find),
            );
            widget.pagingController.appendLoadMoreOutput(
              LoadMoreOutput(
                data: List.generate(
                  Constant.itemsPerPage,
                  (index) => ApiUserData(
                    id: 1,
                    email: 'duynn@gmail.com',
                    birthday: DateTime(2000, 1, 1),
                  ),
                ),
              ),
            );
            await tester.pump(30.seconds);
          },
          overrides: [
            homeViewModelProvider.overrideWith(
              (_) => _buildHomeViewModel(
                CommonState(
                  data: HomeState(),
                ),
              ),
            ),
          ],
          customPump: (t) => t.pump(30.seconds),
        );
      },
    );
  });
}
