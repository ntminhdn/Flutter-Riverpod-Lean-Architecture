import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../index.dart';

final refreshTokenApiClientProvider = Provider<RefreshTokenApiClient>(
  (ref) => getIt.get<RefreshTokenApiClient>(),
);

@LazySingleton()
class RefreshTokenApiClient extends RestApiClient {
  RefreshTokenApiClient()
      : super(
          dio: DioBuilder.createDio(
            options: BaseOptions(baseUrl: Constant.appApiBaseUrl),
            interceptors: (dio) => [
              CustomLogInterceptor(),
              ConnectivityInterceptor(
                getIt.get<ConnectivityHelper>(),
              ),
              RetryOnErrorInterceptor(
                dio,
                RetryOnErrorInterceptorHelper(),
              ),
              BasicAuthInterceptor(),
              HeaderInterceptor(
                packageHelper: getIt.get<PackageHelper>(),
                deviceHelper: getIt.get<DeviceHelper>(),
              ),
              AccessTokenInterceptor(
                getIt.get<AppPreferences>(),
              ),
            ],
          ),
        );
}
