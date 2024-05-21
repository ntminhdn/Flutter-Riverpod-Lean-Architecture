import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../index.dart';

@LazySingleton()
class RandomUserApiClient extends RestApiClient {
  RandomUserApiClient()
      : super(
          dio: DioBuilder.createDio(
            options: BaseOptions(baseUrl: Constant.randomUserBaseUrl),
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
