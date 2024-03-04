import 'package:dio/dio.dart';

import '../../../index.dart';

class ConnectivityInterceptor extends BaseInterceptor {
  ConnectivityInterceptor(this._connectivityHelper) : super(InterceptorType.connectivity);

  final ConnectivityHelper _connectivityHelper;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!await _connectivityHelper.isNetworkAvailable) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: RemoteException(kind: RemoteExceptionKind.noInternet),
        ),
      );
    }

    return super.onRequest(options, handler);
  }
}
