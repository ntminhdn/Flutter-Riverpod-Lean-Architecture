import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import '../../../../../common/index.dart';

void main() {
  late LoadMoreUsersExecutor loadMoreUsersExecutor;
  late HomeViewModel homeViewModel;

  setUp(() {
    homeViewModel = HomeViewModel(ref);
    loadMoreUsersExecutor = ref.read(loadMoreUsersExecutorProvider);
  });

  group('fetchInitialUsers', () {
    group('test', () {
      final seed = CommonState(
        data: HomeState(
          users: const LoadMoreOutput(data: [
            ApiUserData(id: 1, email: 'name1'),
            ApiUserData(id: 2, email: 'name2'),
          ]),
        ),
      );
      //ignore:variable_type_mismatch
      const dummyUsers = LoadMoreOutput(data: [
        ApiUserData(id: 3, email: 'name3'),
        ApiUserData(id: 4, email: 'name4'),
      ]);

      stateNotifierTest(
        'when `loadUsersException` of seed is null',
        seed: () => [seed],
        setUp: () {
          when(() => loadMoreUsersExecutor.execute(isInitialLoad: true))
              .thenAnswer((_) async => dummyUsers);
        },
        actions: (vm) => vm.fetchInitialUsers(),
        expect: () {
          final state1 = seed.copyWithData(isShimmerLoading: true, loadUsersException: null);
          final state2 = state1.copyWithData(users: dummyUsers);
          final state3 = state2.copyWithData(isShimmerLoading: false);

          return [
            seed,
            state1,
            state2,
            state3,
          ];
        },
        build: () => homeViewModel,
      );
    });

    group('test', () {
      final seed = CommonState(
        data: HomeState(
          users: const LoadMoreOutput(data: [
            ApiUserData(id: 1, email: 'name1'),
            ApiUserData(id: 2, email: 'name2'),
          ]),
          loadUsersException: AppUncaughtException(),
        ),
      );
      //ignore:variable_type_mismatch
      const dummyUsers = LoadMoreOutput(data: [
        ApiUserData(id: 3, email: 'name3'),
        ApiUserData(id: 4, email: 'name4'),
      ]);

      stateNotifierTest(
        'when `loadUsersException` of seed is not null',
        seed: () => [seed],
        setUp: () {
          when(() => loadMoreUsersExecutor.execute(isInitialLoad: true))
              .thenAnswer((_) async => dummyUsers);
        },
        actions: (vm) => vm.fetchInitialUsers(),
        expect: () {
          final state1 = seed.copyWithData(isShimmerLoading: true, loadUsersException: null);
          final state2 = state1.copyWithData(users: dummyUsers);
          final state3 = state2.copyWithData(isShimmerLoading: false);

          return [
            seed,
            state1,
            state2,
            state3,
          ];
        },
        build: () => homeViewModel,
      );
    });

    group('test', () {
      final seed = CommonState(
        data: HomeState(
          users: const LoadMoreOutput(data: [
            ApiUserData(id: 1, email: 'name1'),
            ApiUserData(id: 2, email: 'name2'),
          ]),
        ),
      );

      final exception = AppUncaughtException();

      stateNotifierTest(
        'when fetchInitialUsers gets an error',
        seed: () => [seed],
        setUp: () {
          when(() => loadMoreUsersExecutor.execute(isInitialLoad: true)).thenThrow(exception);
        },
        actions: (vm) => vm.fetchInitialUsers(),
        expect: () {
          final state1 = seed.copyWithData(isShimmerLoading: true, loadUsersException: null);
          final state2 = state1.copyWithData(isShimmerLoading: false);
          final state3 = state2.copyWithData(loadUsersException: exception);

          return [
            seed,
            state1,
            state2,
            state3,
          ];
        },
        build: () => homeViewModel,
      );
    });
  });

  group('fetchMoreUsers', () {
    group('test', () {
      final seed = CommonState(
        data: HomeState(
          users: const LoadMoreOutput(data: [
            ApiUserData(id: 1, email: 'name1'),
            ApiUserData(id: 2, email: 'name2'),
          ]),
        ),
      );

      final exception = AppUncaughtException();

      stateNotifierTest(
        'when fetchMoreUsers gets an error',
        seed: () => [seed],
        setUp: () {
          when(() => loadMoreUsersExecutor.execute(isInitialLoad: false)).thenThrow(exception);
        },
        actions: (vm) => vm.fetchMoreUsers(),
        expect: () {
          final state1 = seed.copyWithData(loadUsersException: exception);

          return [
            seed,
            seed,
            seed,
            state1,
          ];
        },
        build: () => homeViewModel,
      );
    });

    group('test', () {
      final seed = CommonState(
        data: HomeState(
          users: const LoadMoreOutput(data: [
            ApiUserData(id: 1, email: 'name1'),
            ApiUserData(id: 2, email: 'name2'),
          ]),
        ),
      );
      //ignore:variable_type_mismatch
      const dummyUsers = LoadMoreOutput(data: [
        ApiUserData(id: 3, email: 'name3'),
        ApiUserData(id: 4, email: 'name4'),
      ]);

      stateNotifierTest(
        'when `loadUsersException` of seed is null',
        seed: () => [seed],
        setUp: () {
          when(() => loadMoreUsersExecutor.execute(isInitialLoad: false))
              .thenAnswer((_) async => dummyUsers);
        },
        actions: (vm) => vm.fetchMoreUsers(),
        expect: () {
          final state1 = seed.copyWithData(users: dummyUsers);

          return [
            seed,
            seed,
            state1,
            state1,
          ];
        },
        build: () => homeViewModel,
      );
    });

    group('test', () {
      final seed = CommonState(
        data: HomeState(
          users: const LoadMoreOutput(data: [
            ApiUserData(id: 1, email: 'name1'),
            ApiUserData(id: 2, email: 'name2'),
          ]),
          loadUsersException: AppUncaughtException(),
        ),
      );
      //ignore:variable_type_mismatch
      const dummyUsers = LoadMoreOutput(data: [
        ApiUserData(id: 3, email: 'name3'),
        ApiUserData(id: 4, email: 'name4'),
      ]);

      stateNotifierTest(
        'when `loadUsersException` of seed is not null',
        seed: () => [seed],
        setUp: () {
          when(() => loadMoreUsersExecutor.execute(isInitialLoad: false))
              .thenAnswer((_) async => dummyUsers);
        },
        actions: (vm) => vm.fetchMoreUsers(),
        expect: () {
          final state1 = seed.copyWithData(loadUsersException: null);
          final state2 = state1.copyWithData(users: dummyUsers);

          return [
            seed,
            state1,
            state2,
            state2,
          ];
        },
        build: () => homeViewModel,
      );
    });
  });
}

extension HomeStateExt on CommonState<HomeState> {
  CommonState<HomeState> copyWithData({
    LoadMoreOutput<ApiUserData>? users,
    bool? isShimmerLoading,
    AppException? loadUsersException,
  }) {
    return copyWith(
      data: data.copyWith(
        users: users ?? data.users,
        isShimmerLoading: isShimmerLoading ?? data.isShimmerLoading,
        loadUsersException: loadUsersException,
      ),
    );
  }
}
