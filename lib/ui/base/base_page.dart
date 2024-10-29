import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../index.dart';

abstract class BasePage<S extends BaseState, P extends ProviderListenable<CommonState<S>>>
    extends HookConsumerWidget with LogMixin {
  const BasePage({super.key});

  P get provider;
  ScreenName get screenName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppDimen.of(context);
    AppColor.of(context);
    l10n = AppString.of(context)!;

    ref.listen(
      provider.select((value) => value.appException),
      (previous, next) {
        if (previous != next && next != null) {
          handleException(next, ref);
        }
      },
    );

    return VisibilityDetector(
      key: Key(runtimeType.toString()),
      onVisibilityChanged: (info) => onVisibilityChanged(info.visibleFraction, ref),
      child: Stack(
        children: [
          buildPage(context, ref),
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

  // ignore: prefer_named_parameters
  void onVisibilityChanged(double visibleFraction, WidgetRef ref) {
    if (visibleFraction == 1) {
      ref.analyticsHelper.logScreenView(screenName: screenName);
    }
  }

  Widget buildPageLoading() => const CommonProgressIndicator();

  // ignore: prefer_named_parameters
  Widget buildPage(BuildContext context, WidgetRef ref);

  // ignore: prefer_named_parameters
  Future<void> handleException(
    AppException appException,
    WidgetRef ref,
  ) async {
    await ref.read(exceptionHandlerProvider).handleException(appException);
  }
}
