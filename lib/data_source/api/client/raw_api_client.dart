import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../index.dart';

@LazySingleton()
class RawApiClient extends RestApiClient {
  RawApiClient()
      : super(
          dio: DioBuilder.createDio(
            options: BaseOptions(baseUrl: ''),
            interceptors: (dio) => [
              CustomLogInterceptor(),
              ConnectivityInterceptor(
                getIt.get<ConnectivityHelper>(),
              ),
              RetryOnErrorInterceptor(
                dio,
                RetryOnErrorInterceptorHelper(),
              ),
            ],
          ),
        );
}
