import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../index.dart';

abstract class BaseStatefulPageState<
    S extends BaseState,
    VM extends BaseViewModel<S>,
    P extends ProviderListenable<CommonState<S>>,
    W extends StatefulHookConsumerWidget> extends ConsumerState<W> with LogMixin {
  P get provider;
  ScreenName get screenName;

  AppNavigator get nav => ref.read(appNavigatorProvider);

  VM get vm;

  ExceptionHandler get exceptionHandler => ref.read(exceptionHandlerProvider);

  @override
  Widget build(BuildContext context) {
    AppDimen.of(context);
    AppColor.of(context);
    l10n = AppString.of(context)!;

    ref.listen(
      provider.select((value) => value.appException),
      (previous, next) async {
        if (previous != next && next != null) {
          await exceptionHandler.handleException(next);
        }
      },
    );

    return VisibilityDetector(
      key: Key(runtimeType.toString()),
      onVisibilityChanged: (info) => onVisibilityChanged(info.visibleFraction),
      child: Stack(
        children: [
          buildPage(context),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) => Visibility(
              visible: ref.watch(provider.select((value) => value.isLoading)),
              child: buildPageLoading(),
            ),
          ),
        ],
      ),
    );
  }

  void onVisibilityChanged(double visibleFraction) {
    if (visibleFraction == 1) {
      ref.analyticsHelper.logScreenView(screenName: screenName);
    }
  }

  Widget buildPageLoading() => const CommonProgressIndicator();

  Widget buildPage(BuildContext context);
}
