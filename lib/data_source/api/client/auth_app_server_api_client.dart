import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../index.dart';

final authApiClientProvider = Provider<AuthAppServerApiClient>(
  (ref) => getIt.get<AuthAppServerApiClient>(),
);

@LazySingleton()
class AuthAppServerApiClient extends RestApiClient {
  AuthAppServerApiClient()
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
              RefreshTokenInterceptor(
                getIt.get<AppPreferences>(),
                getIt.get<RefreshTokenApiClient>(),
                getIt.get<NoneAuthAppServerApiClient>(),
              ),
            ],
          ),
        );
}
