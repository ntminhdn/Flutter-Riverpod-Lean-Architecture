import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../index.dart';

class AppProviderObserver extends ProviderObserver {
  AppProviderObserver({
    this.logOnDidAddProvider = Config.logOnDidAddProvider,
    this.logOnDidDisposeProvider = Config.logOnDidDisposeProvider,
    this.logOnDidUpdateProvider = Config.logOnDidUpdateProvider,
    this.logOnProviderDidFail = Config.logOnProviderDidFail,
  });

  final bool logOnDidAddProvider;
  final bool logOnDidDisposeProvider;
  final bool logOnDidUpdateProvider;
  final bool logOnProviderDidFail;

  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value, ProviderContainer container) {
    if (logOnDidAddProvider) {
      Log.d('didAddProvider: $provider, value: $value, container: $container');
    }
    super.didAddProvider(provider, value, container);
  }

  @override
  void didDisposeProvider(ProviderBase<Object?> provider, ProviderContainer container) {
    if (logOnDidDisposeProvider) {
      Log.d('didDisposeProvider: $provider, container: $container');
    }
    super.didDisposeProvider(provider, container);
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (logOnDidUpdateProvider) {
      Log.d(
        'didUpdateProvider: $provider, previousValue: $previousValue, newValue: $newValue, container: $container',
      );
    }
    super.didUpdateProvider(provider, previousValue, newValue, container);
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    if (logOnProviderDidFail) {
      Log.e(
        'providerDidFail: $provider, error: $error, stackTrace: $stackTrace, container: $container',
      );
    }
    super.providerDidFail(provider, error, stackTrace, container);
  }
}
