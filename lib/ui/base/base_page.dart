import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../index.dart';
import '../../localizations/app_localization_view_model.dart';

abstract class BasePage<S extends BaseState, P extends ProviderListenable<CommonState<S>>>
    extends HookConsumerWidget with LogMixin {
  const BasePage({super.key});

  P get provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppDimen.of(context);
    AppColor.of(context);
    l10n = AppString.of(context)!;
    ref.listen(
      appLocalizationViewModelProvider.select((value) => value.data.localization),
      (previous, next) {
        l10n = next!;
      },
    );

    ref.listen(
      languageCodeProvider,
      (previous, next) async {
        if (previous != next) {
          final modelManager = OnDeviceTranslatorModelManager();
          final isModelDownloaded = await modelManager.isModelDownloaded(next.localeCode);
          if (!isModelDownloaded) return;
          await onLanguageCodeChange(ref: ref);
        }
      },
    );
    ref.listen(
      provider.select((value) => value.appException),
      (previous, next) {
        if (previous != next && next != null) {
          handleException(next, ref);
        }
      },
    );

    return Stack(
      children: [
        buildPage(context, ref),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) => Visibility(
            visible: ref.watch(provider.select((value) => value.isLoading)),
            child: buildPageLoading(),
          ),
        ),
      ],
    );
  }

  Future<void> onLanguageCodeChange({required WidgetRef ref}) async {}

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
