import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../index.dart';

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
            ],
          ),
        );
}
