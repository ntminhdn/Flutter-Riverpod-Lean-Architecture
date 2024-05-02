import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../index.dart';

@RoutePage()
class HomePage extends BasePage<HomeState,
    AutoDisposeStateNotifierProvider<HomeViewModel, CommonState<HomeState>>> {
  const HomePage({this.cacheManager, super.key});

  @override
  AutoDisposeStateNotifierProvider<HomeViewModel, CommonState<HomeState>> get provider =>
      homeViewModelProvider;

  @visibleForTesting
  final BaseCacheManager? cacheManager;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final pagingController = useMemoized(() => CommonPagingController<ApiUserData>());

    useEffect(
      () {
        Future.microtask(() {
          ref.read(provider.notifier).fetchInitialUsers();
        });
        pagingController.listen(
          onLoadMore: () => ref.read(provider.notifier).fetchMoreUsers(),
        );

        return () {
          pagingController.dispose();
        };
      },
      [],
    );

    ref.listen(provider.select((value) => value.data.users), (previous, next) {
      if (previous != next) {
        pagingController.appendLoadMoreOutput(next);
      }
    });

    ref.listen(provider.select((value) => value.data.loadUsersException), (previous, next) {
      if (previous != next && next != null) {
        pagingController.error = next;
      }
    });

    return CommonScaffold(
      shimmerEnabled: true,
      appBar: CommonAppBar.back(text: l10n.home),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CommonImage.network(
              url: Constant.contactListBg,
              fit: BoxFit.cover,
              cacheManager: cacheManager,
              errorBuilder: (context, error) => CommonContainer(color: cl.red1),
            ),
            Consumer(
              builder: (context, ref, child) {
                final users = ref.watch(provider.select((value) => value.data.users));
                final isShimmerLoading =
                    ref.watch(provider.select((value) => value.data.isShimmerLoading));

                return RefreshIndicator(
                  onRefresh: ref.read(provider.notifier).fetchInitialUsers,
                  child: isShimmerLoading && users.data.isEmpty
                      ? const _ListViewLoader()
                      : CommonPagedListView<ApiUserData>(
                          pagingController: pagingController,
                          itemBuilder: (context, user, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.rps,
                                vertical: 4.rps,
                              ),
                              child: ShimmerLoading(
                                isLoading: isShimmerLoading,
                                loadingWidget: const _LoadingItem(),
                                child: GestureDetector(
                                  onTap: () async {
                                    await ref.read(appNavigatorProvider).push(HomeRoute());
                                  },
                                  child: CommonContainer(
                                    padding: EdgeInsets.all(8.rps),
                                    color: cl.green1,
                                    border: SolidBorder.allRadius(radius: 8.rps),
                                    width: double.infinity,
                                    child: CommonText(
                                      '${user.email}\n${user.gender}\n${user.birthday?.toIso8601String()}'
                                          .hardcoded,
                                      style: ts(
                                        color: cl.black,
                                        fontSize: 14.rps,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingItem extends StatelessWidget {
  const _LoadingItem();

  @override
  Widget build(BuildContext context) {
    return RounedRectangleShimmer(
      width: double.infinity,
      height: 60.rps,
    );
  }
}

/// Because [PagedListView] does not expose the [itemCount] property, itemCount = 0 on the first load and thus the Shimmer loading effect can not work. We need to create a fake ListView for the first load.
class _ListViewLoader extends StatelessWidget {
  const _ListViewLoader();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Constant.shimmerItemCount,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.rps,
          vertical: 4.rps,
        ),
        child: const ShimmerLoading(
          loadingWidget: _LoadingItem(),
          isLoading: true,
          child: _LoadingItem(),
        ),
      ),
    );
  }
}
